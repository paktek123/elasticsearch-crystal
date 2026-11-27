require "../spec_helper"

describe "Indices resize and block APIs: argument validation" do
  client = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9250})

  it "split requires index and target" do
    expect_raises(ArgumentError) { client.indices.split({:index => "test"}) }
    expect_raises(ArgumentError) { client.indices.split({:target => "test2"}) }
  end

  it "clone requires index and target" do
    expect_raises(ArgumentError) { client.indices.clone({:index => "test"}) }
    expect_raises(ArgumentError) { client.indices.clone({:target => "test2"}) }
  end

  it "add_block requires index and block" do
    expect_raises(ArgumentError) { client.indices.add_block({:index => "test"}) }
    expect_raises(ArgumentError) { client.indices.add_block({:block => "write"}) }
  end

  it "resolve_index requires name" do
    expect_raises(ArgumentError) { client.indices.resolve_index }
  end
end
