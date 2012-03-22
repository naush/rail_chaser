require 'spec_helper'
require 'rail_chaser'

describe RailChaser do
  describe "self.on" do
    it "initializes a new example collection" do
      RailChaser.on
      RailChaser.collection.should_not be_nil
    end

    it "configures RSpec before and after suite" do
      RailChaser.on
      RSpec.configure do |config|
        config.hooks[:before][:suite].should_not be_empty
        config.hooks[:after][:suite].should_not be_empty
      end
    end
  end
end
