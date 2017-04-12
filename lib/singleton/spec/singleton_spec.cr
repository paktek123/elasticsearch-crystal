require "./spec_helper"

class Example
end

class OtherExample
end

class StatefulExample
  getter value : Int32
  @value = 42

  def inc
    @value += 1
  end
end

class GenericExample(T)
  property value : T?

  def self.instance
    Singleton::Of(self).instance
  end
end

Spec.before_each do
  Singleton.reset
end

describe Singleton do
  describe "::Of(T).instance" do
    it "can be fetched" do
      example = Singleton::Of(Example).instance
      example.should be_a(Example)
      typeof(example).should eq(Example)
    end

    it "is the same when fetched again" do
      example = Singleton::Of(Example).instance
      again_example = Singleton::Of(Example).instance
      example.should be(again_example)
      typeof(again_example).should eq(Example)
    end

    it "is of correct type when other type" do
      other_example = Singleton::Of(OtherExample).instance
      other_example.should be_a(OtherExample)
      typeof(other_example).should eq(OtherExample)
    end

    it "works with generics" do
      example = Singleton::Of(GenericExample(String)).instance
      example.value = "hello world"
      again_example = Singleton::Of(GenericExample(String)).instance
      again_example.value.should eq("hello world")
    end

    it "works with generics using class 'self'" do
      example = GenericExample(String).instance
      example.value = "hello world"
      again_example = GenericExample(String).instance
      again_example.value.should eq("hello world")
    end
  end

  describe ".reset" do
    it "resets all instances correctly" do
      stateful_example = Singleton::Of(StatefulExample).instance
      stateful_example.inc
      stateful_example.value.should eq(43)

      Singleton.reset

      stateful_example = Singleton::Of(StatefulExample).instance
      stateful_example.value.should eq(42)
    end
  end
end
