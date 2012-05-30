#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'jasmine-headless-webkit'

task :build => [:compile]

task :compile do
  `middleman build`
end

Jasmine::Headless::Task.new('jasmine:headless') do |t|
  t.colors = true
  t.keep_on_error = true
  t.jasmine_config = 'spec/javascripts/support/jasmine.yml'
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
