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
                   entries.map { |entry| text(entry.at_css(".publication-entry__title")) }
      expected.zip(entries).each do |paper, entry|
        authors = paper["authors"].map { |author| author.split(", ").reverse.join(" ") }.join(", ")
        assert_equal authors, text(entry.at_css(".publication-entry__authors"))
      end
    end
    assert_empty @page.css(".publication-entry__number")
  end

  def test_accepted_paper_has_year_and_status_in_articles
    entry = @page.at_css("#refereed-articles #pub-subdiffusive-grain-growth")
    refute_nil entry
    source = text(entry.at_css(".publication-entry__source"))
    assert_includes source, "Applied Mathematics and Computation"
    assert_includes source, "2026"
    assert_includes source, "To appear"
    refute_nil entry.at_css("a[href='https://www.sciencedirect.com/journal/applied-mathematics-and-computation']")
  end

  def test_research_links_resolve_and_publication_anchors_are_unique
    ids = @page.css(".publication-entry").map { |entry| entry["id"] }
    assert_equal ids.uniq, ids
    links = @page.css(".research-gallery a[href^='#pub-']")
    refute_empty links
    links.each { |link| assert_includes ids, link["href"].delete_prefix("#") }
    assert_empty @page.css("a[href^='#pub']").reject { |link| link["href"].start_with?("#pub-", "#publications") }
  end

  def test_non_arxiv_preprint_is_not_mislabeled
    link = @page.at_css(".publication-entry a[href='https://doi.org/10.13140/RG.2.2.25976.00007']")
    refute_nil link
    assert_equal "Preprint", text(link)
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
      titles = Nokogiri::HTML.fragment(html).css(".publication-entry__title").map { |node| text(node) }
      assert_equal expected, titles
    end
  end
end
