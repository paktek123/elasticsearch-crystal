require "./spec_helper"

describe Mock do
  it "stubs a method's return value" do
    my_instance = double()
    my_instance.stub(:a_method).and_return("stubbed result")

    my_instance.a_method.should eq("stubbed result")
  end

  it "stubs a method's return value (short version)" do
    my_instance = double(:my_object, { :a_method => "stubbed result" })

    my_instance.a_method.should eq("stubbed result")
  end

  it "filters by arguments" do
    my_instance = double()
    my_instance.stub(:a_method).with(123).and_return("123")
    my_instance.stub(:a_method).with(456).and_return("456")

    my_instance.a_method(123).should eq("123")
    my_instance.a_method(456).should eq("456")
  end

  it "arguments can be ignored" do
    my_instance = double()
    my_instance.stub(:a_method).and_return("whatever")

    my_instance.a_method.should eq("whatever")
    my_instance.a_method(123).should eq("whatever")
    my_instance.a_method(456).should eq("whatever")
  end

  it "stubbed explicitly without arguments matches only without arguments" do
    my_instance = double()
    my_instance.stub(:a_method).with().and_return("hello")

    my_instance.a_method.should eq("hello")

    # this would fail:
    # my_instance.a_method(456)
  end

  it "expectations can be set" do
    my_instance = double()

    my_instance.should_receive(:a_method).and_return("whatever")

    # test would fail if we removed this line:
    my_instance.a_method.should eq("whatever")
  end

  it "filtering by arguments affect expectations too" do
    my_instance = double()

    my_instance.should_receive(:a_method_with_arguments).with("hello").and_return("world")

    my_instance.a_method_with_arguments("hello").should eq("world")

    # this would fail:
    # my_instance.a_method_with_arguments("bye")
  end
end
