require 'spec_helper'
require 'rail_chaser/configuration'

describe RailChaser::Configuration do
  describe "[]" do
    it "has quick access to options" do
      config = RailChaser::Configuration.new
      config[:skip_gem].should be_true
    end
  end

  describe "[]=" do
    it "can set options" do
      config = RailChaser::Configuration.new
      config[:skip_gem] = false
      config[:skip_gem].should be_false
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

  describe "options" do
    it "defaults options[:skip_gem] to true" do
      RailChaser::Configuration.new.options[:skip_gem].should be_true
    end

    it "defaults options[:skip_ruby_code] to true" do
      RailChaser::Configuration.new.options[:skip_ruby_core].should be_true
    end

    it "defaults options[:skip_spec] to true" do
      RailChaser::Configuration.new.options[:skip_spec].should be_true
    end

    it "default options[:db_path] to 'spec.db'" do
      RailChaser::Configuration.new.options[:db_path].should == 'spec.db'
    end
  end
end

