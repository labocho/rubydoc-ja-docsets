require "shellwords"

AVAILABLE_VERSIONS = %w(3.1 3.2 3.3 3.4).map(&:freeze).freeze

def version
  @version ||= case (v = ENV.fetch("VERSION", nil))
  when *AVAILABLE_VERSIONS
    v
  else
    raise "!!! Please specify VERSION (#{AVAILABLE_VERSIONS.join(", ")}) !!!"
  end
end

def root
  __dir__
end

def sha1
  `cd #{root.shellescape}/build/doctree && git log -n 1 --format=format:%H`.strip
end

def tarball_name
  "Ruby-#{version}-ja.tgz"
end

def s3_endpoint
  ENV["S3_ENDPOINT"] || "s3.amazonaws.com"
end

# s3 にアップロードする際の prefix。
# 通常 doctree の sha1 だが、doctree の更新を待たずに docset を更新したい場合に環境変数 BUILD を指定する。
def s3_prefix
  [sha1, ENV.fetch("BUILD", nil)].compact.join("-")
end

task :clone do
  unless File.exist? "build/doctree"
    sh "git clone https://github.com/rurema/doctree.git build/doctree"
  end
end

task :pull => :clone do
  sh "cd build/doctree && git pull"
end

task :generate_html => :pull do
  if File.exist?("html/#{version}/REVISION") &&
     File.read("html/#{version}/REVISION").strip == sha1
    next
  end

  outputdir = File.expand_path("html/#{version}")
  rm_rf outputdir
  mkdir_p "#{outputdir}/function"
  mkdir_p "#{outputdir}/json"

  database = File.expand_path("#{outputdir}/../db-#{version}")
  stdlibtree = File.expand_path("build/doctree/refm/api/src")
  capipaths = Dir.glob("build/doctree/refm/capi/src/*")

  bitclust = "bundle exec bitclust --database=#{database.shellescape}"
  sh "#{bitclust} init version=#{version} encoding=utf-8"
  sh "#{bitclust} update --stdlibtree=#{stdlibtree.shellescape}"
  sh "#{bitclust} --capi update #{capipaths.collect(&:shellescape).join(" ")}"
  sh "#{bitclust} statichtml --outputdir=#{outputdir.shellescape}"

  sh "echo #{sha1} > #{outputdir.shellescape}/REVISION"
  rm_rf database
end

task :add_original_url => :generate_html do
  next if File.read("html/#{version}/doc/index.html")[%(<html lang="ja-JP"><!-- Online page at http://docs.ruby-lang.org/ja/#{version}/doc/index.html -->)]

  ruby "add_original_url.rb #{version}"
end

task :generate_docsets => :add_original_url do
  revision_file = "docsets/Ruby #{version}-ja.docset/REVISION"
  if File.exist?(revision_file) && File.read(revision_file).strip == (sha1)
    next
  end

  ruby "generate_docsets.rb #{version}"
  docset_file = "docsets/Ruby #{version}-ja.docset/Contents/Resources/docSet.dsidx"
  sh %(echo 'PRAGMA journal_mode=delete' | sqlite3 #{docset_file.shellescape})

  sh "echo #{sha1} > #{revision_file.shellescape}"
end

task :clean_docsets do
  rm_rf "docsets/Ruby #{version}-ja.docset"
end

task :install => :generate_docsets do
  source = "docsets/Ruby #{version}-ja.docset"
  dest = "#{Dir.home}/Library/Application Support/Dash/DocSets/Ruby #{version}-ja"
  rm_rf dest
  mkdir_p dest
  cp_r source, dest
end

task :uninstall do
  dest = "#{Dir.home}/Library/Application Support/Dash/DocSets/Ruby #{version}-ja"
  rm_rf dest
end

task :tarball => [:generate_docsets, :feed] do
  source = "docsets/Ruby #{version}-ja.docset"
  dest = "tarball/#{tarball_name}"
  rm_f dest
  mkdir_p File.dirname(dest)

  loop do
    break if File.exist?("#{source}/Contents/Resources/docSet.dsidx")

    sleep 1
  end

  sh "tar --exclude='.DS_Store' -czf #{dest.shellescape} #{source.shellescape}"
end

task :feed => :generate_docsets do
  mkdir_p "tarball"
  url = "https://#{s3_endpoint}/rubydoc-ja-docsets/#{s3_prefix}/#{tarball_name}"
  open("tarball/Ruby-#{version}-ja.xml", "w") {|f|
    f.write %(<entry><version>#{s3_prefix}</version><url>#{url}</url></entry>)
  }
end

task :release => :tarball do
  require "aws"
  s3 = Aws::S3.new(ENV.fetch("AWS_ACCESS_KEY_ID"), ENV.fetch("AWS_SECRET_ACCESS_KEY"), server: s3_endpoint)
  bucket = s3.bucket("rubydoc-ja-docsets")

  if bucket.key("#{s3_prefix}/#{tarball_name}").exists?
    puts "Already uploaded"
    next
  end

  open("tarball/#{tarball_name}", "rb:ascii-8bit") do |file|
    puts "Uploading... tarball/#{tarball_name}"
    bucket.put "#{s3_prefix}/#{tarball_name}", file, {}, "public-read", "content-type" => "application/x-compressed"
  end
end

task :server do
  ruby "-run", "-e", "httpd", "--", "gh-pages"
end

task :clean do
  rm_rf "build"
  rm_rf "docsets"
  rm_rf "html"
  rm_rf "tarball/*.tgz"
end
