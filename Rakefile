require 'bundler/setup'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

task :default => ['spec']

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--backtrace']
end
