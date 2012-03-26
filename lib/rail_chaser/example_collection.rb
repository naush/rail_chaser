require 'rail_chaser/storage'

module RailChaser
  class ExampleCollection
    attr_accessor :examples, :storage

    def self.create
      example = ExampleCollection.new
      example.initialize_storage
      example
    end

    def initialize
      @examples = Hash.new { |h, spec| h[spec] = [] }
    end

    def initialize_storage
      @storage = RailChaser::Storage.create
    end

    def gem_path_pattern
      @gem_path_pattern ||= Regexp.compile ENV['GEM_HOME'].gsub(':', '|')
    end

    def gem?(file)
      file =~ gem_path_pattern
    end

    def ruby_core?(file)
      file =~ /#{ENV['MY_RUBY_HOME']}/
    end

    def spec?(file)
      file =~ /\/spec\//
    end

    def add_class?(file, classes)
      return false if spec?(file)
      return false if gem?(file)
      return false if ruby_core?(file)
      return false if classes.include?(file)
      return true
    end

    def add_example(file)
      @spec = file if spec?(file)

      if @spec
        classes = @examples[@spec]
        classes << file if add_class?(file, classes)
      end
    end

    def each_spec_and_classes
      if block_given?
        @examples.each_pair do |spec, classes|
          yield spec, classes
        end
      end
    end

    def classes
      @examples.values.flatten.uniq
    end

    def save!
      @storage.save!(self)
    end
  end
end
