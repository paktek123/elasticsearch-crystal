require "./spec_helper"

describe Mock::MethodStub do
  describe "#method_name" do
    it "returns method name" do
      stub = Mock::MethodStub.new(:my_method)
      stub.method_name.should eq(:my_method)
    end
  end

  describe "#with" do
    it "has no arguments before being called" do
      stub = Mock::MethodStub.new(:my_method)
      stub.arguments.should be_nil
    end

    it "sets arguments and returns itself" do
      stub = Mock::MethodStub.new(:my_method)
      stub.with("arg1", "arg2").should eq(stub)
      stub.arguments.should eq(Mock::Arguments.new(["arg1", "arg2"]))
    end

    it "sets empty arguments" do
      stub = Mock::MethodStub.new(:my_method)
      stub.with().should eq(stub)
      stub.arguments.should eq(Mock::Arguments.empty)
    end

    it "accepts an Arguments" do
      arguments = Mock::Arguments.new(["arg"])
      stub = Mock::MethodStub.new(:my_method).with(arguments)
      stub.arguments.should eq(arguments)
    end
  end

  describe "#and_return" do
    it "defaults to nil" do
      Mock::MethodStub.new(:my_method).value.should be_nil
    end

    it "sets value and returns itself" do
      stub = Mock::MethodStub.new(:my_method)
      stub.and_return("value").should eq(stub)
      stub.value.should eq("value")
    end
  end
end

describe Mock::MethodStubCollection do
  describe "#find" do
    it "finds when name and args are equal (value is ignored)" do
      coll = Mock::MethodStubCollection.new
      stub1 = Mock::MethodStub.new(:my_method).with("arg").and_return("value1")
      stub2 = Mock::MethodStub.new(:my_method).with("arg").and_return("value2")
      coll << stub1
      coll.find(stub2).should eq(stub1)
      coll.find(:my_method, Mock::Arguments.new(["arg"])).should eq(stub1)
    end

    it "doesn't find when names are different" do
      coll = Mock::MethodStubCollection.new
      stub1 = Mock::MethodStub.new(:my_method1).with("arg").and_return("value")
      stub2 = Mock::MethodStub.new(:my_method2).with("arg").and_return("value")
      coll << stub1
      coll.find(stub2).should be_nil
      coll.find(:my_method2, Mock::Arguments.new(["arg"])).should be_nil
    end

    it "doesn't find when arguments are different" do
      coll = Mock::MethodStubCollection.new
      stub1 = Mock::MethodStub.new(:my_method).with("arg1").and_return("value")
      stub2 = Mock::MethodStub.new(:my_method).with("arg2").and_return("value")
      coll << stub1
      coll.find(stub2).should be_nil
      coll.find(:my_method, Mock::Arguments.new(["arg2"])).should be_nil
    end

    it "no arguments == match always" do
      coll = Mock::MethodStubCollection.new
      stub1 = Mock::MethodStub.new(:my_method)
      stub2 = Mock::MethodStub.new(:my_method).with("arg")
      coll << stub1
      coll.find(stub2).should eq(stub1)
      coll.find(:my_method, Mock::Arguments.new(["arg"])).should eq(stub1)
    end

    it "no arguments == match always" do
      coll = Mock::MethodStubCollection.new
      stub1 = Mock::MethodStub.new(:my_method).with("arg")
      stub2 = Mock::MethodStub.new(:my_method)
      coll << stub1
      coll.find(stub2).should eq(stub1)
      coll.find(:my_method, Mock::Arguments.new(["arg"])).should eq(stub1)
    end
  end
end
