#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/lib/ms_translate/*_spec.rb']
  t.verbose = true
end

task :default => :test
