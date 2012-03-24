require File.expand_path('../../lib/prime_factor', __FILE__)

require 'rail_chaser'
RailChaser.on

describe PrimeFactor do
  def test_factor(number, expected_factors)
    factors = PrimeFactor.new(number)
    expected_factors.each do |factor|
      factors.next.should == factor
    end
  end

  it "factors 1" do
    test_factor(1, [])
  end

  it "factors 2" do
    test_factor(2, [2])
  end

  it "factors 3" do
    test_factor(3, [3])
  end

  it "factors 4" do
    test_factor(4, [2, 2])
  end

  it "factors 5" do
    test_factor(5, [5])
  end

  it "factors 6" do
    test_factor(6, [2, 3])
  end

  it "factors 7" do
    test_factor(7, [7])
  end

  it "factors 8" do
    test_factor(8, [2, 2, 2])
  end

  it "factors 9" do
    test_factor(9, [3, 3])
  end
end
