module RailChaser
  class Configuration
    attr_accessor :skip_gem, :skip_ruby_core, :skip_spec, :db_path

    def initialize
      @skip_gem = true
      @skip_ruby_core = true
      @skip_spec = true
      @db_path = 'spec.db'
    end

    def example_collection_options
      {
        :skip_gem => @skip_gem,
        :skip_ruby_core => @skip_ruby_core,
        :skip_spec => @skip_spec
      }
    end

    def storage_options
      {
        :db_path => @db_path
      }
    end
  end
end
