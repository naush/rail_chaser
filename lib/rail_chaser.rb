require 'rail_chaser/configuration'
require 'rail_chaser/example_collection'
require 'rail_chaser/storage'

module RailChaser
  class << self
    attr_accessor :config, :collection, :storage

    def on
      @config = Configuration.new
      yield @config if block_given?

      @collection = ExampleCollection.new(@config.example_collection_options)
      @storage = Storage.create(@config)

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
      @storage.save!(@collection)
    end
  end
end
