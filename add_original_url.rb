require "find"
version = ARGV.shift

def insert_url_after_html_tag(html, url)
  comment = "<!-- Online page at #{url} -->"
  html.gsub(/(<html[^>]*>)/i){ $1 + comment }
end

Dir.chdir("html/#{version}") {
  Find.find(".") {|file|
    next unless File.extname(file) == ".html"
    path = file[1..-1] # remove first .
    path.gsub!(/-([a-z])/){ $1.upcase } # -a -> A
    url = "http://docs.ruby-lang.org/ja/#{version}#{path}"
    puts file
    File.write(file, insert_url_after_html_tag(File.read(file), url))
  }
}
