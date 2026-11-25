require "../spec_helper"
require "http/server"

# Unit specs for the bulk NDJSON serialisation; no Elasticsearch required.
module BulkNdjsonSpec
  class Capture
    property method = ""
    property path = ""
    property body = ""
    property content_type = ""
  end

  def self.with_server(&)
    capture = Capture.new
    server = HTTP::Server.new do |context|
      capture.method = context.request.method
      capture.path = context.request.resource
      capture.content_type = context.request.headers["Content-Type"]? || ""
      capture.body = context.request.body.try(&.gets_to_end) || ""
      context.response.content_type = "application/json"
      context.response.print %({"took":1,"errors":false,"items":[]})
    end
    address = server.bind_tcp "127.0.0.1", 0
    spawn { server.listen }
    Fiber.yield
    begin
      client = Elasticsearch::Test::Client.new({:host => "127.0.0.1", :port => address.port})
      yield client, capture
    ensure
      server.close
    end
  end
end

describe "Bulk NDJSON" do
  describe "Utils.__bulkify" do
    it "serialises an array of action/source hashes, one JSON document per line" do
      body = [
        {"index" => {"_index" => "test", "_id" => "1"}},
        {"title" => "foo"},
        {"delete" => {"_index" => "test", "_id" => "2"}},
      ]
      Elasticsearch::API::Utils.__bulkify(body).should eq(
        %({"index":{"_index":"test","_id":"1"}}\n{"title":"foo"}\n{"delete":{"_index":"test","_id":"2"}}\n)
      )
    end

    it "accepts JSON::Any items" do
      body = [JSON.parse(%({"index":{"_id":"1"}})), JSON.parse(%({"a":1}))]
      Elasticsearch::API::Utils.__bulkify(body).should eq(%({"index":{"_id":"1"}}\n{"a":1}\n))
    end

    it "splits the combined format with a data key onto two lines" do
      body = [
        {"index" => {"_index" => "test", "_id" => "1", "data" => {"title" => "foo"}}},
        {"update" => {"_id" => "2", "data" => {"doc" => {"title" => "bar"}}}},
        {"delete" => {"_id" => "3"}},
      ]
      Elasticsearch::API::Utils.__bulkify(body).should eq(
        %({"index":{"_index":"test","_id":"1"}}\n{"title":"foo"}\n) +
        %({"update":{"_id":"2"}}\n{"doc":{"title":"bar"}}\n) +
        %({"delete":{"_id":"3"}}\n)
      )
    end

    it "sends a pre-serialised string unchanged, appending a trailing newline if missing" do
      with_nl = %({"index":{"_id":"1"}}\n{"a":1}\n)
      Elasticsearch::API::Utils.__bulkify(with_nl).should eq(with_nl)
      Elasticsearch::API::Utils.__bulkify(with_nl.chomp).should eq(with_nl)
    end

    it "uses string items in an array as-is" do
      Elasticsearch::API::Utils.__bulkify([%({"index":{"_id":"1"}}), %({"a":1})]).should eq(%({"index":{"_id":"1"}}\n{"a":1}\n))
    end
  end

  describe "Client#bulk" do
    it "sends an array body as NDJSON with the x-ndjson content type" do
      BulkNdjsonSpec.with_server do |client, capture|
        client.bulk({:index => "test", :body => [
          {"index" => {"_id" => "1"}},
          {"title" => "foo"},
          {"delete" => {"_id" => "2"}},
        ]})
        capture.method.should eq("POST")
        capture.path.should eq("/test/_bulk")
        capture.content_type.should eq("application/x-ndjson")
        capture.body.should eq(%({"index":{"_id":"1"}}\n{"title":"foo"}\n{"delete":{"_id":"2"}}\n))
      end
    end

    it "sends the combined format as NDJSON" do
      BulkNdjsonSpec.with_server do |client, capture|
        client.bulk({:body => [{"index" => {"_index" => "test", "data" => {"title" => "foo"}}}]})
        capture.path.should eq("/_bulk")
        capture.content_type.should eq("application/x-ndjson")
        capture.body.should eq(%({"index":{"_index":"test"}}\n{"title":"foo"}\n))
      end
    end

    it "sends a string body unchanged (not re-encoded as a JSON string)" do
      BulkNdjsonSpec.with_server do |client, capture|
        client.bulk({:body => %({"index":{"_index":"test"}}\n{"title":"foo"})})
        capture.content_type.should eq("application/x-ndjson")
        capture.body.should eq(%({"index":{"_index":"test"}}\n{"title":"foo"}\n))
      end
    end
  end
end
