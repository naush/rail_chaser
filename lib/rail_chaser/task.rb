require 'rake'
require 'rake/tasklib'
require 'rail_chaser/storage'

module RailChaser
  class Task < Rake::TaskLib
    include Rake::DSL

    def initialize(name = :min)
      define(name)
    end

    def define(name)
      desc 'Runs minimum set of specs'
      namespace :spec do
        task name do
          diff_files = `git diff --name-only`.split("\n")
          staged_files = `git diff --staged --name-only`.split("\n")

          storage = RailChaser::Storage.new
          storage.load!

          puts "# Changed files:\n"
          specs = []
          (diff_files + staged_files).each do |file|
            puts "# - #{file}"
            specs << storage.find_specs_by_class(file)
          end

          puts "#\n# Specs to run:\n"
          specs = specs.flatten.compact.uniq
          specs.each do |spec|
            puts "# - #{spec}"
          end

          rspec_command = "rspec #{specs.join(' ')}"
          result = `#{rspec_command}`
          puts "\n#{result}"
        end
      end
    end
  end
end
