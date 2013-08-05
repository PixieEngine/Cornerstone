#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Run mocha tests"
task :test do
  sh "mkdir -p mocha/test"
  sh "cat mocha/setup.coffee source/*.coffee test/*.coffee > mocha/test/test.coffee"
  sh "cd mocha && mocha -u qunit --compilers coffee:coffee-script --reporter spec"
end

namespace :npm do
  desc "Compile source folder to build"
  task :build do
    sh "./node_modules/.bin/coffee -cj dist/cornerstone.js source/"
  end

  desc "Publish for npm"
  task :publish do
    sh "npm publish ."
  end
end
