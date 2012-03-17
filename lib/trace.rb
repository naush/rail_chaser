require 'trace/storage'
require 'trace/example_collection'

module Trace
  class << self
    attr_accessor :collection

    def on
      @collection = ExampleCollection.new

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
