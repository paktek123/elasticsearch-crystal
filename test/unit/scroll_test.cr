require "../spec_helper"
require "http/server"

# Unit specs that need no Elasticsearch: a local HTTP::Server records what the client sends.
module Elasticsearch
  module Test
    class RecordedRequest
      property method = "", resource = "", body = "", content_type = ""
    end

    def self.with_recording_server(&)
      recorded = RecordedRequest.new
      server = HTTP::Server.new do |context|
        recorded.method = context.request.method
        recorded.resource = context.request.resource
        recorded.body = context.request.body.try(&.gets_to_end) || ""
        recorded.content_type = context.request.headers["Content-Type"]? || ""
        context.response.content_type = "application/json"
        context.response.print %({"acknowledged":true})
      end
      address = server.bind_tcp "127.0.0.1", 0
      spawn { server.listen }
      Fiber.yield
      begin
        yield Elasticsearch::Test::Client.new({:host => "127.0.0.1", :port => address.port}), recorded
      ensure
        server.close
      end
    end

    describe "Scroll API (request shape)" do
      it "scroll sends POST /_search/scroll with scroll_id and scroll in the body" do
        with_recording_server do |client, req|
          client.scroll({:scroll_id => "abc123==", :scroll => "1m"})
          req.method.should eq "POST"
          req.resource.should eq "/_search/scroll"
          req.content_type.should eq "application/json"
          JSON.parse(req.body).as_h.should eq({"scroll_id" => JSON::Any.new("abc123=="), "scroll" => JSON::Any.new("1m")})
        end
      end

      it "scroll forwards rest_total_hits_as_int as a query param, not in the body" do
        with_recording_server do |client, req|
          client.scroll({:scroll_id => "abc", :scroll => "1m", :rest_total_hits_as_int => "true"})
          req.method.should eq "POST"
          req.resource.should eq "/_search/scroll?rest_total_hits_as_int=true"
          JSON.parse(req.body).as_h.keys.should eq ["scroll_id", "scroll"]
        end
      end

      it "scroll does not put a very long scroll_id in the URL" do
        with_recording_server do |client, req|
          long_id = "x" * 20_000
          client.scroll({:scroll_id => long_id})
          req.resource.should eq "/_search/scroll"
          JSON.parse(req.body)["scroll_id"].as_s.should eq long_id
        end
      end

      it "scroll requires scroll_id" do
        with_recording_server do |client, _|
          expect_raises(ArgumentError) { client.scroll({:scroll => "1m"}) }
        end
      end

      it "clear_scroll with a body sends DELETE /_search/scroll with the body" do
        with_recording_server do |client, req|
          client.clear_scroll({:body => {"scroll_id" => ["id1", "id2"]}})
          req.method.should eq "DELETE"
          req.resource.should eq "/_search/scroll"
          JSON.parse(req.body)["scroll_id"].as_a.map(&.as_s).should eq ["id1", "id2"]
        end
      end

      it "clear_scroll with scroll_id _all sends DELETE /_search/scroll/_all" do
        with_recording_server do |client, req|
          client.clear_scroll({:scroll_id => "_all"})
          req.method.should eq "DELETE"
          req.resource.should eq "/_search/scroll/_all"
          req.body.should eq ""
        end
      end

      it "clear_scroll requires scroll_id or body" do
        with_recording_server do |client, _|
          expect_raises(ArgumentError) { client.clear_scroll }
        end
      end
    end
  end
end
