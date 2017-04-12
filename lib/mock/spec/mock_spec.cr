require "./spec_helper"

describe Mock do
  it "works" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).and_return("stubbed result")

    my_instance.a_method.should eq("stubbed result")
  end

  it "works with parameters" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).with(123).and_return("stubbed result")

    my_instance.a_method(123).should eq("stubbed result")

    expect_raises(Mock::UnexpectedCall) do
      my_instance.a_method(456)
    end

    expect_raises(Mock::UnexpectedCall) do
      my_instance.a_method
    end
  end

  it "stubbed without parameters matches always" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).and_return("stubbed result")

    my_instance.a_method.should eq("stubbed result")
    my_instance.a_method(123).should eq("stubbed result")
    my_instance.a_method(456).should eq("stubbed result")
  end

  it "stubbed explicitly without parameters matches only without parameters" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).with.and_return("stubbed result")

    my_instance.a_method.should eq("stubbed result")

    expect_raises(Mock::UnexpectedCall) do
      my_instance.a_method(456)
    end
  end

  it "can be passed as argument" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).and_return("stubbed result")

    my_other_instance = MyOtherClass.new

    my_other_instance.a_method_with_arguments(my_instance).should eq("stubbed result")
  end

  pending "can be passed as argument (restricted)" do
    my_instance = Mock::Double.new
    my_instance.stub(:a_method).and_return("stubbed result")

    my_other_instance = MyOtherClass.new

    # this doesn't compile, need to find a workaround:
    my_other_instance.a_method_with_restricted_arguments(my_instance).should eq("stubbed result")
  end

  it "allows asserting method calls" do
    my_instance = Mock::Double.new

    # TODO: should[_not] receive would be better than should[_not]_receive but it's not possible to implement the way
    # should[_not] are implemnted in crystal. Maybe find workaround?
    my_instance.should_receive(:a_method).and_return("whatever")
    my_instance.should_not_receive(:another_method)

    my_instance.a_method.should eq("whatever")

    expect_raises(Mock::UnexpectedCall) do
      my_instance.another_method
    end

    expect_raises(Spec::AssertionFailed) do
      my_instance.stub(:another_method)
      my_instance.another_method
      my_instance.check_expectations # trick: this is what will be called later but we want to check here
    end

    Mock.reset # so it doesn't fail there
  end

  it "asserting method calls is sensitive to arguments" do
    my_instance = Mock::Double.new

    my_instance.should_receive(:a_method_with_arguments).with("hello").and_return("world")
    my_instance.should_not_receive(:a_method_with_arguments).with("bye")

    my_instance.a_method_with_arguments("hello").should eq("world")

    expect_raises(Spec::AssertionFailed) do
      my_instance.stub(:a_method_with_arguments)
      my_instance.a_method_with_arguments("bye")
      my_instance.check_expectations # trick: this is what will be called later but we want to check here
    end

    Mock.reset # so it doesn't fail there
  end

  it "asserting method calls is sensitive to arguments (trickier example)" do
    my_instance = Mock::Double.new

    my_instance.stub(:a_method_with_arguments).and_return("whatever argument")
    my_instance.should_receive(:a_method_with_arguments)
    my_instance.should_not_receive(:a_method_with_arguments).with("bye")

    expect_raises(Spec::AssertionFailed) do
      my_instance.a_method_with_arguments("bye").should eq("whatever argument")
      my_instance.check_expectations # trick: this is what will be called later but we want to check here
    end

    Mock.reset # so it doesn't fail there
  end
end
