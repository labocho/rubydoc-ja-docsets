require "shellwords"

def run(command)
  exit $?.exitstatus unless system(command)
end

def version
  ENV["VERSION"] || raise("!!! Please specify VERSION (1.8.7|1.9.3|2.0.0) !!!")
end

def svnversion
  `svnversion #{File.expand_path(File.dirname(__FILE__)).shellescape}/build/rubydoc`.to_i
end

task :checkout do
  run "svn co http://jp.rubyist.net/svn/rurema/doctree/trunk build/rubydoc"
  run "svn co http://jp.rubyist.net/svn/rurema/bitclust/trunk build/bitclust"
end

task :generate_html => :checkout do
  if File.exists?("build/rubydoc/refm/api/html/#{version}/REVISION") &&
     File.read("build/rubydoc/refm/api/html/#{version}/REVISION").to_i == svnversion
     next
  end
  Dir.chdir("build/rubydoc/refm/api") do
    mkdir_p "html"
    run "ruby -I ../../../bitclust/lib ../../../bitclust/bin/bitclust -d ./db-#{version} init version=#{version} encoding=utf-8"
    run "ruby -I ../../../bitclust/lib ../../../bitclust/bin/bitclust -d ./db-#{version} update --stdlibtree=src"
    rm_rf "./html/#{version}"
    run "mkdir ./html/#{version} ./html/#{version}/function ./html/#{version}/json"
    run "ruby ../../../bitclust/tools/bc-tohtmlpackage.rb -d ./db-#{version} -o ./html/#{version} --catalog=../../../bitclust/data/bitclust/catalog"
    run "echo #{svnversion} > html/#{version}/REVISION"
  end
end

task :generate_docsets => :generate_html do
  if File.exists?("docsets/Ruby #{version}-ja.docset/REVISION")
     File.read("docsets/Ruby #{version}-ja.docset/REVISION").to_i == svnversion
     next
  end
  ruby "generate_docsets.rb #{version}"
  run "echo #{svnversion} > docsets/Ruby\\ #{version}-ja.docset/REVISION"
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
