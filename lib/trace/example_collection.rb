module Trace
  class ExampleCollection
    attr_accessor :examples

    def initialize
      @examples = Hash.new { |h, description| h[description] = [] }
      @storage = Trace::Storage.new
    end

    def each_description_and_classes
      if block_given?
        @examples.each_pair do |description, classes|
          yield description, classes
        end
      end
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
        @description = describe(example)
      end

      if @description
        classes = @examples[@description]
        classes << class_name unless classes.include?(class_name)
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
