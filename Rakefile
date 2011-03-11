require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require File.join(File.dirname(__FILE__), "lib", "attach_file_field", "version")

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the attach_file_field plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the attach_file_field plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AttachFileField'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "attach_file_field"
    gemspec.version = AttachFileField::Version.dup
    gemspec.summary = "Easy upload files via Swfupload"
    gemspec.description = "Upload files via Swfupload with Freeberry CMS style"
    gemspec.email = "superp1987@gmail.com"
    gemspec.homepage = "http://github.com/galetahub/attach_file_field"
    gemspec.authors = ["Pavlo Galeta", "Igor Galeta"]
    gemspec.files = FileList["[A-Z]*", "{lib}/**/*"]
    gemspec.rubyforge_project = "attach_file_field"
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
