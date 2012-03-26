require 'spec_helper'
require 'rail_chaser/storage'
require 'rail_chaser/example_collection'

describe RailChaser::Storage do
  describe "save!" do
    before(:all) do
      @storage = RailChaser::Storage.new(:db_path => 'test.db')
      @storage.destroy!
      @storage.create!
    end

    after(:all) do
      @storage.destroy!
    end

    def test_example_collection
      collection = RailChaser::ExampleCollection.new
      examples = collection.examples
      examples["/a_spec.rb"] = ["/a.rb"]
      examples["/b_spec.rb"] = ["/b.rb"]
      collection
    end

    it "saves a new example collection" do
      @storage.save!(test_example_collection)

      classes = @storage.list_classes
      classes.should include('/a.rb')
      classes.should include('/b.rb')

      specs = @storage.list_specs
      specs.should include('/a_spec.rb')
      specs.should include('/b_spec.rb')
    end
  end

  describe "initialize" do
    it "has default options" do
      storage = RailChaser::Storage.new
      storage.db_path.should == 'spec.db'
    end

    it "inherits options" do
      storage = RailChaser::Storage.new(:db_path => 'custom.db')
      storage.db_path.should == 'custom.db'
    end
  end

  describe "self.create" do
    it "destroys previous database file"
    it "creates new database file"
  end

  describe "destroy!" do
    it "deletes the generated db file"
  end
end
