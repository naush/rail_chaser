require 'rail_chaser/storage'
require 'rail_chaser/example_collection'

module RailChaser
  class << self
    attr_accessor :collection

    def on
      @collection = ExampleCollection.create

      RSpec.configure do |config|
        config.before(:suite) { start }
        config.after(:suite) { finish }
      end
    end

    def start
      set_trace_func proc { |event, file, line, method, binding, klass|
        @collection.add_example(file)
      }
    end

    def finish
      set_trace_func(nil)
      @collection.save!
    end
  end
end
