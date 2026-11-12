require "minitest/autorun"
require "nokogiri"
require "json"
require "uri"
require "yaml"

class AssetsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  SITE = File.join(ROOT, "_site")
  ORIGIN = URI(YAML.safe_load(File.read(File.join(ROOT, "_config.yml"))).fetch("url"))

  def assert_local_resource(url, source)
    return if url.nil? || url.empty? || url.start_with?("#", "data:")

    relative_source = source.delete_prefix(SITE)
    uri = URI.join(ORIGIN.to_s + relative_source, url)
    return unless %w[http https].include?(uri.scheme) && uri.host == ORIGIN.host

    path = File.join(SITE, URI::DEFAULT_PARSER.unescape(uri.path).delete_prefix("/"))
    assert File.file?(path), "Missing local resource #{url} referenced by #{relative_source}"
  end

  def test_html_images_scripts_stylesheets_and_sharing_images_exist
    Dir.glob(File.join(SITE, "**/*.html")).each do |source|
      page = Nokogiri::HTML(File.read(source))
      page.css("[src], [poster]").each do |node|
        %w[src poster].each { |attribute| assert_local_resource(node[attribute], source) }
      end
      page.css("link[href]").each do |node|
        next if (node["rel"].to_s.split & %w[stylesheet icon apple-touch-icon mask-icon manifest preload]).empty?
        assert_local_resource(node["href"], source)
      end
      page.css('meta[property="og:image"], meta[name="twitter:image"], meta[name="msapplication-TileImage"]').each do |node|
        assert_local_resource(node["content"], source)
      end
    end
  end

  def test_compiled_css_font_and_image_references_exist
    stylesheets = Dir.glob(File.join(SITE, "assets/**/*.css"))
    refute_empty stylesheets
    stylesheets.each do |source|
      File.read(source).scan(/url\(\s*['"]?([^'"\)]+)['"]?\s*\)/i).flatten.each do |url|
        assert_local_resource(url.strip, source)
      end
    end
  end

  def test_manifest_and_browser_icons_exist
    manifest = File.join(SITE, "site.webmanifest")
    JSON.parse(File.read(manifest)).fetch("icons").each do |icon|
      assert_local_resource(icon.fetch("src"), manifest)
    end
    browserconfig = File.join(SITE, "browserconfig.xml")
    Nokogiri::XML(File.read(browserconfig)).css("[src]").each do |icon|
      assert_local_resource(icon["src"], browserconfig)
    end
    # Browsers can request these conventional paths without an HTML link.
    %w[favicon.ico apple-touch-icon.png].each do |icon|
      assert File.file?(File.join(SITE, icon)), "Missing browser icon #{icon}"
    end
  end
end
