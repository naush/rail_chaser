module RailChaser
  class Configuration
    attr_accessor :options

    EXAMPLE_COLLECTION_OPTIONS = [:skip_gem, :skip_ruby_core, :skip_spec]
    STORAGE_OPTIONS = [:db_path]

    def initialize
      @options = {}
      @options[:skip_gem] = true
      @options[:skip_ruby_core] = true
      @options[:skip_spec] = true
      @options[:db_path] = 'spec.db'
    end

    def example_collection_options
      EXAMPLE_COLLECTION_OPTIONS.inject({}) do |options, key|
        options[key] = @options[key]
        options
      end
    end

    def storage_options
      STORAGE_OPTIONS.inject({}) do |options, key|
        options[key] = @options[key]
        options
      end
    end

    def [](key)
      @options[key]
    end

    def []=(key, value)
      @options[key] = value
    end
  end
end
