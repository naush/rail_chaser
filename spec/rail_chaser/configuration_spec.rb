require 'spec_helper'
require 'rail_chaser/configuration'

describe RailChaser::Configuration do
  describe "options" do
    it "default to true" do
      RailChaser::Configuration.new.skip_gem.should be_true
    end

    it "defaults skip_ruby_code to true" do
      RailChaser::Configuration.new.skip_ruby_core.should be_true
    end

    it "defaults skip_spec to true" do
      RailChaser::Configuration.new.skip_spec.should be_true
    end

    it "defaults db_path to 'spec.db'" do
      RailChaser::Configuration.new.db_path.should == 'spec.db'
    end
  end

  describe "example_collection_options" do
    it "has options for example_collection" do
      config = RailChaser::Configuration.new
      options = config.example_collection_options
      options.has_key?(:skip_gem).should be_true
      options.has_key?(:skip_ruby_core).should be_true
      options.has_key?(:skip_spec).should be_true
    end
  end

  describe "storage_options" do
    it "has options for storage" do
      config = RailChaser::Configuration.new
      options = config.storage_options
      options.has_key?(:db_path).should be_true
    end
  end
end

