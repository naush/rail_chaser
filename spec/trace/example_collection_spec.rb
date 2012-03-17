require 'spec_helper'
require 'trace/example_collection'

describe Trace::ExampleCollection do
  describe "add_example"

  describe "ruby_core?" do
    it "matches any file in the ruby core directory" do
      collection = Trace::ExampleCollection.new
      collection.ruby_core?("#{ENV['MY_RUBY_HOME']}/file.rb").should be_true
    end

    it "does not match lib file" do
      collection = Trace::ExampleCollection.new
      collection.ruby_core?("/lib/file.rb").should be_false
    end
  end

  describe "spec?" do
    it "matches any file ending with _spec.rb" do
      collection = Trace::ExampleCollection.new
      collection.spec?("/spec/trace/example_collection_spec.rb").should be_true
    end

    it "matches files inside /spec/ directory" do
      collection = Trace::ExampleCollection.new
      collection.spec?("/spec/trace/example_collection_spec.rb").should be_true
    end

    it "does not match spec_helper" do
      collection = Trace::ExampleCollection.new
      collection.spec?("/spec/spec_helper.rb").should be_false
    end

    it "does not match lib file" do
      collection = Trace::ExampleCollection.new
      collection.spec?("/lib/trace.rb").should be_false
    end
  end


  describe "initialize" do
    it "creates a new storage" do
      collection = Trace::ExampleCollection.new
      collection.storage.should_not be_nil
    end

    it "initializes a hash defaults to arrays" do
      collection = Trace::ExampleCollection.new
      collection.examples["spec"].should == []
    end
  end

  describe "classes" do
    it "has all classes" do
      collection = Trace::ExampleCollection.new
      examples = collection.examples
      examples["spec1"] = ["/path/a.rb"]
      examples["spec2"] = ["/path/b.rb"]
      collection.classes.should include("/path/a.rb")
      collection.classes.should include("/path/b.rb")
    end

    it "has unique classes" do
      collection = Trace::ExampleCollection.new
      examples = collection.examples
      examples["spec1"] = ["/path/a.rb"]
      examples["spec2"] = ["/path/a.rb"]
      class_names = collection.classes
      class_names.size.should == 1
      class_names.should == ["/path/a.rb"]
    end
  end
end
