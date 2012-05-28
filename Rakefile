require "coffee-script"
require "bundler/gem_helper"

task :default => [:spec]

desc "Run jasmine specs"
task :spec do
  sh %[bundle exec jasmine-headless-webkit -cq]
end

desc "Release gem to private github account"
task :release do
  # This is kind of messy because I had to override and hack the 'release' task for
  # bundler so that it wouldn't publically push this out to Rubygems.
  bundler {
    guard_clean
    guard_already_tagged
    tag_version
    git_push
  }
end

desc "Install locally"
task :install do
  bundler { install_gem }
end

desc "Build the gem"
task :build do
  bundler { build_gem }
end

def bundler(&block)
  # I have to do an instane eval because all of these are protected methods.
  @bundler ||= Bundler::GemHelper.new(File.dirname(__FILE__)).instance_eval(&block)
end
