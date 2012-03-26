require 'rail_chaser/example_collection'
require 'rail_chaser/storage'

module RailChaser
  class << self
    attr_accessor :collection, :storage

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
      storage = Storage.create
      storage.save!(@collection)
    end
  end
end
