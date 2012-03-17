require 'spec_helper'
require 'trace'

describe Trace do
  describe "self.on" do
    it "initializes a new example collection" do
      Trace.on
      Trace.collection.should_not be_nil
    end

    it "configures RSpec before and after suite" do
      Trace.on
      RSpec.configure do |config|
        config.hooks[:before][:suite].should_not be_empty
        config.hooks[:after][:suite].should_not be_empty
      end
    end
  end
end
