module Trace
  class ExampleCollection
    attr_accessor :examples

    def initialize
      @examples = {}
      @storage = Trace::Storage.new
    end

    def each_description_and_classes
      if block_given?
        @examples.each_pair do |description, data|
          yield description, data[:classes]
        end
      end
    end

    def gem_paths_pattern
      @gem_paths ||= Regexp.compile(ENV['GEM_PATH'].gsub(':', '|'))
    end

    def gem?(file)
      file =~ gem_paths_pattern
    end

    def gem(file)
      file.gsub(gem_paths_pattern, '').split('/')[2]
    end

    def describe(example)
      return unless example
      example.metadata[:example_group][:full_description].split.first
    end

    def has_example?(class_name, binding)
      class_name == 'RSpec::Core::ExampleGroup' && eval('local_variables', binding).include?(:example)
    end

    def add_example(class_name, binding, file, id)
      if has_example?(class_name, binding)
        example = eval('example', binding)
        @current_description = describe(example)
        @examples[@current_description] ||= new_description
      end

      if @current_description
        classes = @examples[@current_description][:classes]
        classes << class_name unless classes.include?(class_name)
        @examples[@current_description][:gems] << gem(file) if gem?(file)
        @examples[@current_description][:methods] << id
      end
    end

    def new_description
      {
        :gems    => [],
        :classes => [],
        :methods => []
      }
    end

    def classes
      @examples.collect do |description, data|
        data[:classes]
      end.flatten.uniq
    end

    def save!
      @storage.save!(self)
    end
  end
end
