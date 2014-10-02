# encoding: UTF-8
require "sqlite3"
require "active_record"
require "fileutils"
require "pp"
require "find"
require "cgi"
require "pathname"
require "yaml"
require "shellwords"
require "bitclust"

include FileUtils
include BitClust::NameUtils

version = ARGV.shift

docset = "docsets/Ruby #{version}-ja.docset"
mkdir_p "#{docset}/Contents/Resources/Documents"
exit $?.exitstatus unless system("cp -R html/#{version}/* #{"#{docset}/Contents/Resources/Documents".shellescape}")
cp "#{docset}/Contents/Resources/Documents/rurema.png", "#{docset}/icon.png"

open("#{docset}/Contents/Info.plist", "w") do |f|
  f.write <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>CFBundleIdentifier</key>
        <string>Ruby #{version}-ja</string>
        <key>CFBundleName</key>
        <string>Ruby #{version}-ja</string>
        <key>DocSetPlatformFamily</key>
        <string>Ruby #{version}-ja</string>
        <key>isDashDocset</key>
        <true/>
        <key>dashIndexFilePath</key>
        <string>doc/index.html</string>
      </dict>
    </plist>
  XML
end

rm "#{docset}/Contents/Resources/docSet.dsidx", force: true

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "#{docset}/Contents/Resources/docSet.dsidx"
)

ActiveRecord::Base.connection.execute <<-SQL
  CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)
SQL

class SearchIndex < ActiveRecord::Base
  self.table_name = "searchIndex"
end

html_dir = "#{docset}/Contents/Resources/Documents"
method_dir = File.join(html_dir, "method")
char_to_mark = MARK_TO_CHAR.invert
Find.find(html_dir) do |file|
  if file !~ /\/doc\// && FileTest.file?(file) && File.extname(file) == '.html'
    html = File.read(file)
    item = {key: '', type: ""}

    # method
    if html =~ %r{<title>(.*? method|module function|constant|variable) (.*?)</title>}
      is_variable = /variable\z/.match($1)
      path = Pathname.new(file).relative_path_from(Pathname.new(method_dir)).to_s.gsub(/\.\w+$/, "")
      item[:key] = decodename_fs(path).gsub(%r|/[\w]/|) { |s|
        char_to_mark[s.delete("/")]
      }
      item[:key].gsub!(/^Kernel/, "") if is_variable
      item[:type] = "Method"
    end

    # class
    if html =~ %r{<title>(class|module|object) (.*?)</title>}
      item[:key] = CGI.unescapeHTML($2)
      item[:type] = $1.camelize
    end

    # library
    if html =~ %r{<title>(library) (.*?)</title>}
      item[:key] = CGI.unescapeHTML($2) + 'ライブラリ'
      item[:type] = "Library"
    end

    # CAPI function
    if html =~ %r{<title>(function) (.*?)</title>}
      item[:key] = CGI.unescapeHTML($2)
      item[:type] = "Function"
    end

    if item[:key].empty?
      $stderr.puts 'no key. ' + file
    else
      index = SearchIndex.new
      index.name = item[:key]
      index.type = item[:type]
      index.path = Pathname.new(file).relative_path_from(Pathname.new(html_dir)).to_s
      index.save!
      pp index.attributes
    end
  end
end

YAML.load_file("default_index.yml").each do |attributes|
  index = SearchIndex.new
  index.name = attributes[:key]
  index.type = "Guide"
  index.path = attributes[:path]
  index.save!
  pp index.attributes
end
