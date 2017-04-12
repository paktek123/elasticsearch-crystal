require "./spec_helper"

class Greeting
  def say(what)
    what
  end

  def foo
    "hello world"
  end
end

Mocks.create_mock Greeting do
  mock say(what)
  mock foo
end

Spec2.describe "Spec2::Mocks" do
  it "works" do
    p = Greeting.new
    p.say("hi John")
    expect(p).to have_received(say("hi John"))
    expect(p).not_to have_received(say("hello world"))
    expect {
      expect(p).to have_received(say("hello world"))
    }.to raise_error(Spec2::ExpectationNotMet, "expected: say[\"hello world\"]\n     got: say[\"hi John\"]")
  end

  it "works with delayed expectation (and_return)" do
    p = Greeting.new
    expect(p).to receive(say("hi John")).and_return("hello John")
    expect(p.say("hi John")).to eq("hello John")
  end

  it "works with delayed expectation (just receive)" do
    p = Greeting.new
    expect(p).to receive(say("hi John"))
    expect(p.say("hi John")).to eq("hi John")
  end

  it "works with delayed expectation (not_to)" do
    p = Greeting.new
    expect(p).not_to receive(say("hi John"))
    expect(p.say("hi Bruce")).to eq("hi Bruce")
  end

  it "works without args" do
    p = Greeting.new
    expect(p).to receive(foo).and_return("")
    expect(p.foo).to eq("")
  end

  it "doesn't break normal expect(...).[not_]to ..." do
    expect(true).to eq(true)
    expect {
      expect(true).to eq(false)
    }.to raise_error(::Spec2::ExpectationNotMet)

    expect(false).not_to eq(true)
    expect {
      expect(true).not_to eq(true)
    }.to raise_error(::Spec2::ExpectationNotMet)
  end
end
