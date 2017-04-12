require "./spec_helper"

describe Mock::Arguments do
  describe ".empty" do
    it "is equal to other empty arguments" do
      Mock::Arguments.empty.should eq(Mock::Arguments.empty)
    end

    it "is not equal to other non empty arguments" do
      Mock::Arguments.empty.should_not eq(Mock::Arguments.new(Array(Int32).new))
      Mock::Arguments.empty.should_not eq(Mock::Arguments.new([1]))
      Mock::Arguments.empty.should_not eq(Mock::Arguments.new(["a", "b"]))
    end
  end
end
