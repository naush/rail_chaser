require 'rail_chaser/storage'
require 'rake'
require 'rake/tasklib'

module RailChaser
  class Task < Rake::TaskLib
    include Rake::DSL

    def initialize(name = :min)
      define(name)
    end

    def define(name)
      namespace :spec do
        desc 'Run minimum set of specs'
        task name do
          diff_files = `git diff HEAD --name-only`.split("\n")

          # ToDo: possibly add new spec files to specs
          # new_files = `git ls-files --exclude-standard --others`.split("\n")
          # new_files.select { |file| file =~ /(\/spec\/(.*)?)?\_spec\.rb/ }

          storage = RailChaser::Storage.new
          storage.load!

          puts "# Changed files:\n"
          specs = []
          diff_files.each do |file|
            puts "# - #{file}"
            specs << storage.find_specs_by_class(file)
          end

          puts "#\n# Specs to run:\n"
          specs = specs.flatten.compact.uniq
          specs.each do |spec|
            puts "# - #{spec}"
          end

          unless specs.empty?
            rspec_command = "rspec #{specs.join(' ')}"
            result = `#{rspec_command}`
            puts "\n#{result}"
          end
        end
      end
    end
  end
end
