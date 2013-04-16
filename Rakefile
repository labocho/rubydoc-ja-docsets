require "shellwords"

def version
  ENV["VERSION"] || raise("!!! Please specify VERSION (1.8.7|1.9.3|2.0.0) !!!")
end

def svnversion
  `svnversion #{File.expand_path(File.dirname(__FILE__)).shellescape}/build/rubydoc`.to_i
end

task :checkout do
  sh "svn co http://jp.rubyist.net/svn/rurema/doctree/trunk build/rubydoc"
  sh "svn co http://jp.rubyist.net/svn/rurema/bitclust/trunk build/bitclust"
end

task :generate_html => :checkout do
  if File.exists?("html/#{version}/REVISION") &&
     File.read("html/#{version}/REVISION").to_i == svnversion
     next
  end
  outputdir = File.expand_path("html/#{version}")
  rm_rf outputdir
  mkdir_p "#{outputdir}/function"
  mkdir_p "#{outputdir}/json"
  Dir.chdir("build/bitclust") do
    database = File.expand_path("#{outputdir}/../db-#{version}")
    bitclust = "bundle exec bitclust --database=#{database.shellescape}"
    sh "bundle install"
    sh "#{bitclust} init version=#{version} encoding=utf-8"
    sh "#{bitclust} update --stdlibtree=../rubydoc/refm/api/src"
    sh "#{bitclust} statichtml --database=#{database.shellescape} --outputdir=#{outputdir.shellescape} --catalog=data/bitclust/catalog"
    sh "echo #{svnversion} > #{outputdir.shellescape}/REVISION"
    rm_rf database
  end
end

task :generate_docsets => :generate_html do
  if File.exists?("docsets/Ruby #{version}-ja.docset/REVISION")
     File.read("docsets/Ruby #{version}-ja.docset/REVISION").to_i == svnversion
     next
  end
  ruby "generate_docsets.rb #{version}"
  sh "echo #{svnversion} > docsets/Ruby\\ #{version}-ja.docset/REVISION"
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
