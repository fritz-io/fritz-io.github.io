require "jekyll"
require "minitest/autorun"
require "nokogiri"
require "yaml"

class PublicationsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def setup
    @papers = YAML.safe_load(File.read(File.join(ROOT, "_data/publications.yml")))
    @page = Nokogiri::HTML(File.read(File.join(ROOT, "_site/index.html")))
  end

  def text(node)
    node.text.gsub(/\s+/, " ").strip
  end

  def author_key(paper)
    paper.fetch("authors").map do |author|
      author.downcase.unicode_normalize(:nfd).gsub(/\p{Mn}/, "")
    end
  end

  def test_data_is_complete_and_contains_only_used_fields
    allowed = %w[id category title authors year status venue doi journal arxiv preprint]
    ids = @papers.map { |paper| paper.fetch("id") }
    assert_equal ids.uniq, ids
    ids.each { |id| assert_match(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, id) }
    @papers.each do |paper|
      assert_empty paper.keys - allowed, paper["title"]
      assert_includes %w[article preprint], paper["category"]
      assert_kind_of Integer, paper["year"]
      %w[title status].each { |field| refute_empty paper.fetch(field) }
      assert_includes paper.fetch("authors"), "Fritz, M."
      paper["authors"].each { |author| assert_match(/\A[^,]+, [^,]+\z/, author) }
      assert paper["venue"] if paper["category"] == "article"
    end
    refute File.exist?(File.join(ROOT, "_data/publication_authors.yml"))
  end

  def test_all_papers_render_once_in_bibliographic_order
    {"preprint" => "publications", "article" => "refereed-articles"}.each do |category, section|
      papers = @papers.select { |paper| paper["category"] == category }
      expected = papers.sort_by { |paper| [-paper["year"], author_key(paper), paper["title"].downcase] }
      entries = @page.css("##{section} .publication-entry")
      assert_equal expected.map { |paper| paper["title"] },
                   entries.map { |entry| text(entry.at_css(".publication-entry__title strong")) }
      expected.zip(entries).each do |paper, entry|
        authors = paper["authors"].map { |author| author.split(", ").reverse.join(" ") }.join(", ")
        assert_equal authors, text(entry.at_css(".publication-entry__authors"))
      end
    end
  end

  def numbers(page, selector = ".publication-entry__number")
    page.css(selector).map { |node| text(node).delete("[]").to_i }
  end

  def test_numbers_are_continuous_across_categories
    article_count = @papers.count { |paper| paper["category"] == "article" }
    total = @papers.size
    assert_equal article_count.downto(1).to_a,
                 numbers(@page, "#refereed-articles .publication-entry__number")
    assert_equal total.downto(article_count + 1).to_a,
                 numbers(@page, "#publications .publication-entry__number")
    assert_equal (1..total).to_a, numbers(@page).sort
  end

  def test_article_sources_match_current_publication_data
    @papers.select { |paper| paper["category"] == "article" }.each do |paper|
      entry = @page.at_css("#refereed-articles #pub-#{paper.fetch('id')}")
      refute_nil entry
      source = text(entry.at_css(".publication-entry__source"))
      assert_includes source, paper.fetch("venue")
      assert_includes source, paper.fetch("year").to_s
      if paper["status"] == "Published"
        refute_includes source, "Published"
      else
        assert_includes source, paper.fetch("status")
      end
      assert_equal paper["doi"] || paper["journal"], entry.at_css(".publication-entry__source a")["href"]
    end
  end

  def test_research_links_resolve_and_publication_anchors_are_unique
    ids = @page.css(".publication-entry").map { |entry| entry["id"] }
    assert_equal ids.uniq, ids
    links = @page.css("#research a[href^='#pub-']")
    refute_empty links
    links.each { |link| assert_includes ids, link["href"].delete_prefix("#") }
    assert_empty @page.css("a[href^='#pub']").reject { |link| link["href"].start_with?("#pub-", "#publications") }
  end

  def test_non_arxiv_preprint_is_not_mislabeled
    link = @page.at_css(".publication-entry a[href='https://doi.org/10.13140/RG.2.2.25976.00007']")
    refute_nil link
    assert_equal "Preprint", text(link)
  end

  def test_every_research_topic_has_valid_numbered_references
    topics = YAML.safe_load(File.read(File.join(ROOT, "_data/research_papers.yml")))
    ids = @papers.map { |paper| paper.fetch("id") }
    areas = @page.css(".research-area")
    assert_equal topics.size, areas.size
    areas.each { |area| assert_equal 1, area.css(".research-references").size }
    assert_equal topics.keys.sort, @page.css(".research-references").map { |node| node["data-research-topic"] }.sort
    topics.each do |topic, selected_ids|
      refute_empty selected_ids
      assert_equal selected_ids.uniq, selected_ids
      assert_empty selected_ids - ids
      references = @page.at_css(".research-references[data-research-topic='#{topic}']")
      links = references.css("a")
      assert_equal selected_ids.sort, links.map { |link| link["href"].delete_prefix("#pub-") }.sort
      assert_equal "Selected papers: [#{links.map { |link| text(link) }.join(', ')}]", text(references)
      links.each do |link|
        entry = @page.at_css(link["href"])
        refute_nil entry
        number = text(entry.at_css(".publication-entry__number")).delete("[]")
        title = text(entry.at_css(".publication-entry__title strong"))
        assert_equal number, text(link)
        assert_equal title, link["title"]
        assert_equal "Publication #{number}: #{title}", link["aria-label"]
      end
    end
  end

  def test_references_follow_papers_when_numbering_changes
    site = Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "plugins" => [], "quiet" => true))
    records = [
      {"id" => "older", "title" => "Older article", "year" => 2023, "category" => "article"},
      {"id" => "newer", "title" => "Newer article", "year" => 2024, "category" => "article"},
      {"id" => "preprint", "title" => "A preprint", "year" => 2025, "category" => "preprint"}
    ].map { |paper| paper.merge("authors" => ["Fritz, M."]) }
    site.data["research_papers"] = {"example" => %w[older preprint]}
    check = lambda do |expected|
      site.data["publications"] = records.shuffle(random: Random.new(42))
      template = Liquid::Template.parse('{% include research-references.html topic="example" %}<div id="bibliography">{% include publication-list.html category="preprint" %}{% include publication-list.html category="article" %}</div>')
      page = Nokogiri::HTML.fragment(template.render!(site.site_payload, registers: {site: site}))
      links = page.css(".research-references a")
      assert_equal expected, links.to_h { |link| [link["href"], text(link).to_i] }
      links.each do |link|
        entry = page.at_css(link["href"])
        refute_nil entry
        assert_equal text(entry.at_css(".publication-entry__number")).delete("[]"), text(link)
      end
    end
    check.call({"#pub-preprint" => 3, "#pub-older" => 1})
    records << {"id" => "oldest", "title" => "Oldest article", "year" => 2020, "category" => "article", "authors" => ["Fritz, M."]}
    check.call({"#pub-preprint" => 4, "#pub-older" => 2})
    records[2]["category"] = "article"
    records[2]["year"] = 2022
    records[2]["title"] = "Revised title after acceptance"
    check.call({"#pub-older" => 3, "#pub-preprint" => 2})
  end

  def test_sorting_is_independent_of_record_order
    records = [
      ["suli", 2023, ["Fritz, M.", "Süli, E."]],
      ["zulu", 2023, ["Brunk, A.", "Fritz, M."]],
      ["alpha", 2023, ["Brunk, A.", "Fritz, M."]],
      ["recent", 2024, ["Fritz, M."]],
      ["old", 2022, ["Brunk, A."]],
      ["solo", 2023, ["Fritz, M."]],
      ["suarez", 2023, ["Fritz, M.", "Suarez, A."]],
      ["smith", 2023, ["Fritz, M.", "Smith, Z."]],
      ["kuttler", 2023, ["Fritz, M.", "Kuttler, C."]],
      ["koppl", 2023, ["Fritz, M.", "Köppl, T."]],
      ["di-primio", 2023, ["Di Primio, A.", "Fritz, M."]]
    ].map do |title, year, authors|
      {"title" => title, "year" => year, "authors" => authors,
       "category" => "article", "status" => "Published"}
    end
    records << records.first.merge("title" => "excluded-preprint", "category" => "preprint")
    expected = %w[recent alpha zulu di-primio solo koppl kuttler smith suarez suli old]
    site = Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "plugins" => [], "quiet" => true))
    [records, records.reverse, records.shuffle(random: Random.new(42))].each do |input|
      site.data["publications"] = input
      template = Liquid::Template.parse('{% include publication-list.html category="article" %}')
      html = template.render!(site.site_payload, registers: {site: site})
      fragment = Nokogiri::HTML.fragment(html)
      titles = fragment.css(".publication-entry__title strong").map { |node| text(node) }
      assert_equal expected, titles
      assert_equal expected.length.downto(1).to_a, numbers(fragment)
    end
  end

  def test_numbering_updates_when_a_preprint_is_accepted_or_added
    site = Jekyll::Site.new(Jekyll.configuration("source" => ROOT, "plugins" => [], "quiet" => true))
    records = [
      {"title" => "Older article", "year" => 2023, "category" => "article"},
      {"title" => "Newer article", "year" => 2024, "category" => "article"},
      {"title" => "First preprint", "year" => 2025, "category" => "preprint"},
      {"title" => "Second preprint", "year" => 2026, "category" => "preprint"}
    ].map { |paper| paper.merge("authors" => ["Fritz, M."]) }
    check_numbers = lambda do |expected_preprints, expected_articles|
      site.data["publications"] = records
      # Render in page order; the preprints appear before the articles.
      template = Liquid::Template.parse('<div id="preprints">{% include publication-list.html category="preprint" %}</div><div id="articles">{% include publication-list.html category="article" %}</div>')
      fragment = Nokogiri::HTML.fragment(template.render!(site.site_payload, registers: {site: site}))
      assert_equal expected_preprints, numbers(fragment, "#preprints .publication-entry__number")
      assert_equal expected_articles, numbers(fragment, "#articles .publication-entry__number")
    end

    check_numbers.call([4, 3], [2, 1])
    records[2]["category"] = "article"
    check_numbers.call([4], [3, 2, 1])
    records << {"title" => "New preprint", "year" => 2026, "category" => "preprint", "authors" => ["Brunk, A.", "Fritz, M."]}
    check_numbers.call([5, 4], [3, 2, 1])
    records.each { |paper| paper["category"] = "article" }
    check_numbers.call([], [5, 4, 3, 2, 1])
    records.each { |paper| paper["category"] = "preprint" }
    check_numbers.call([5, 4, 3, 2, 1], [])
  end
end

