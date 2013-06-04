require "shellwords"

def version
  ENV["VERSION"] || raise("!!! Please specify VERSION (1.8.7|1.9.3|2.0.0) !!!")
end

def root
  File.expand_path(File.dirname(__FILE__))
end

def sha1
  `cd #{root.shellescape}/build/doctree && git log -n 1 --format=format:%H`.strip
end

task :clone do
  unless File.exists? "build/doctree"
    sh "git clone git://github.com/rurema/doctree.git build/doctree"
  end
end

task :pull => :clone do
  sh "cd build/doctree && git pull"
end

task :generate_html => :pull do
  if File.exists?("html/#{version}/REVISION") &&
     File.read("html/#{version}/REVISION").strip == sha1
     next
  end
  outputdir = File.expand_path("html/#{version}")
  rm_rf outputdir
  mkdir_p "#{outputdir}/function"
  mkdir_p "#{outputdir}/json"

  database = File.expand_path("#{outputdir}/../db-#{version}")
  bitclust = "bundle exec bitclust --database=#{database.shellescape}"
  sh "#{bitclust} init version=#{version} encoding=utf-8"
  sh "#{bitclust} update --stdlibtree=build/doctree/refm/api/src"
  sh "#{bitclust} statichtml --outputdir=#{outputdir.shellescape}"
  sh "echo #{sha1} > #{outputdir.shellescape}/REVISION"
  rm_rf database
end

task :generate_docsets => :generate_html do
  revision_file = "docsets/Ruby #{version}-ja.docset/REVISION"
  if File.exists?(revision_file)
     next if File.read(revision_file).strip == sha1
  end
  ruby "generate_docsets.rb #{version}"
  sh "echo #{sha1} > #{revision_file.shellescape}"
end

task :clean_docsets do
  rm_rf "docsets/Ruby #{version}-ja.docset"
end

task :install => :generate_docsets do
  source = "docsets/Ruby #{version}-ja.docset"
  dest = "#{ENV["HOME"]}/Library/Application Support/Dash/DocSets/Ruby #{version}-ja"
  rm_rf dest
  mkdir_p dest
  cp_r source, dest
end

task :tarball => [:generate_docsets, :feed] do
  source = "docsets/Ruby #{version}-ja.docset"
  dest = "tarball/Ruby-#{version}-ja.tgz"
  rm_f dest
  mkdir_p File.dirname(dest)
  sh "tar --exclude='.DS_Store' -czf #{dest.shellescape} #{source.shellescape}"
end

task :feed => :generate_docsets do
  mkdir_p "tarball"
  url = "http://raw.github.com/labocho/rubydoc-ja-docsets/master/tarball/Ruby-#{version}-ja.tgz"
  open("tarball/Ruby-#{version}-ja.xml", "w"){|f|
    f.write %(<entry><version>#{sha1}</version><url>#{url}</url></entry>)
  }
end

