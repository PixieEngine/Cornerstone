#!/usr/bin/env rake
require "bundler/gem_tasks"

desc ""
task :test do
  sh "cat mocha/setup.coffee source/*.coffee test/*.coffee > mocha/test/test.coffee"
  sh "cd mocha && mocha -u qunit --compilers coffee:coffee-script"
end
