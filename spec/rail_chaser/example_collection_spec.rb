require 'spec_helper'
require 'rail_chaser/example_collection'

describe RailChaser::ExampleCollection do
  describe "add_example"

  describe "ruby_core?" do
    it "matches any file in the ruby core directory" do
      collection = RailChaser::ExampleCollection.new
      collection.ruby_core?("#{ENV['MY_RUBY_HOME']}/file.rb").should be_true
    end

    it "does not match lib file" do
      collection = RailChaser::ExampleCollection.new
      collection.ruby_core?("/lib/file.rb").should be_false
    end
  end

  describe "spec?" do
    it "matches any file ending with _spec.rb" do
      collection = RailChaser::ExampleCollection.new
      collection.spec?("/spec/rail_chaser/example_collection_spec.rb").should be_true
    end

    it "matches files inside /spec/ directory" do
      collection = RailChaser::ExampleCollection.new
      collection.spec?("/spec/rail_chaser/example_collection_spec.rb").should be_true
    end

    it "does not match lib file" do
      collection = RailChaser::ExampleCollection.new
      collection.spec?("/lib/rail_chaser.rb").should be_false
    end
  end

  describe "initialize" do
    it "initializes a hash defaults to arrays" do
      collection = RailChaser::ExampleCollection.new
      collection.examples["spec"].should == []
    end

    it "inherits options" do
      collection = RailChaser::ExampleCollection.new({
        :skip_gem => true
      })
      collection.options[:skip_gem].should be_true
    end
  end

  describe "add_class" do
    it "returns false if file is spec and skip_spec is true" do
      collection = RailChaser::ExampleCollection.new(:skip_spec => true)
      collection.add_class?('/spec/spec.rb', []).should be_false
    end

    it "returns false if file is spec and skip_spec is false" do
      collection = RailChaser::ExampleCollection.new(:skip_spec => false)
      collection.add_class?('/spec/spec.rb', []).should be_true
    end

    it "does not add duplicated class" do
      collection = RailChaser::ExampleCollection.new
      collection.add_class?('class_a', ['class_a']).should be_false
    end
  end

  describe "classes" do
    it "has all classes" do
      collection = RailChaser::ExampleCollection.new
      examples = collection.examples
      examples["spec1"] = ["/path/a.rb"]
      examples["spec2"] = ["/path/b.rb"]
      collection.classes.should include("/path/a.rb")
      collection.classes.should include("/path/b.rb")
    end

    it "has unique classes" do
      collection = RailChaser::ExampleCollection.new
      examples = collection.examples
      examples["spec1"] = ["/path/a.rb"]
      examples["spec2"] = ["/path/a.rb"]
      class_names = collection.classes
      class_names.size.should == 1
      class_names.should == ["/path/a.rb"]
    end
  end
end
