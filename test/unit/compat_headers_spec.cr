require "../spec_helper"
require "http/server"

COMPAT_JSON   = "application/vnd.elasticsearch+json; compatible-with=8"
COMPAT_NDJSON = "application/vnd.elasticsearch+x-ndjson; compatible-with=8"

# Starts a local server that records request headers and replies with the
# given response headers, then yields the port and the recorded requests.
def with_stub_server(response_headers : Hash(String, String), &)
  requests = [] of HTTP::Headers
  server = HTTP::Server.new do |context|
    requests << context.request.headers.dup
    response_headers.each { |k, v| context.response.headers[k] = v }
    context.response.print %({"ok":true})
  end
  address = server.bind_tcp "127.0.0.1", 0
  spawn { server.listen }
  Fiber.yield
  begin
    yield address.port, requests
  ensure
    server.close
  end
end

def build_client(port, extra = {} of Symbol => String | Int32)
  settings = {:host => "127.0.0.1", :port => port} of Symbol => String | Int32
  settings.merge!(extra)
  Elasticsearch::API::Client.new(settings)
end

describe "compatibility media types and product check" do
  it "sends Accept and Content-Type compat headers on GET, POST and PUT" do
    headers = {"Content-Type" => COMPAT_JSON, "X-Elastic-Product" => "Elasticsearch"}
    with_stub_server(headers) do |port, requests|
      client = build_client(port, {:compatibility_version => 8})
      client.perform_request("GET", "_search", {} of String => String, {"a" => "b"})
      client.perform_request("POST", "_search", {} of String => String, {"a" => "b"})
      client.perform_request("PUT", "idx", {} of String => String, {"a" => "b"})

      requests.size.should eq 3
      requests.each do |req|
        req["Accept"].should eq COMPAT_JSON
        req["Content-Type"].should eq COMPAT_JSON
      end
    end
  end

  it "sends only Accept on bodiless methods (DELETE, HEAD)" do
    headers = {"Content-Type" => COMPAT_JSON, "X-Elastic-Product" => "Elasticsearch"}
    with_stub_server(headers) do |port, requests|
      client = build_client(port, {:compatibility_version => 9})
      client.perform_request("DELETE", "idx")
      client.perform_request("HEAD", "idx")

      requests.each do |req|
        req["Accept"].should eq "application/vnd.elasticsearch+json; compatible-with=9"
        req["Content-Type"]?.should be_nil
      end
    end
  end

  it "uses the x-ndjson media type for bulk" do
    headers = {"Content-Type" => COMPAT_JSON, "X-Elastic-Product" => "Elasticsearch"}
    with_stub_server(headers) do |port, requests|
      client = build_client(port, {:compatibility_version => 8})
      client.bulk({:body => "{}"})

      requests.first["Accept"].should eq COMPAT_NDJSON
      requests.first["Content-Type"].should eq COMPAT_NDJSON
    end
  end

  it "keeps legacy headers when compatibility_version is unset" do
    with_stub_server({"Content-Type" => "application/json"}) do |port, requests|
      client = build_client(port)
      client.perform_request("GET", "_search", {} of String => String, {"a" => "b"})
      client.perform_request("POST", "_search", {} of String => String, {"a" => "b"})

      requests[0]["Content-Type"].should eq "application/json"
      requests[0]["Accept"]?.should be_nil
      requests[1]["Accept"]?.should be_nil
    end
  end

  it "parses application/vnd.elasticsearch+json responses as JSON" do
    headers = {"Content-Type" => COMPAT_JSON, "X-Elastic-Product" => "Elasticsearch"}
    with_stub_server(headers) do |port, _|
      client = build_client(port, {:compatibility_version => 8})
      response = client.perform_request("GET", "")
      response.should be_a(Elasticsearch::API::Common::JsonResponse)
      response.as(Elasticsearch::API::Common::JsonResponse).body["ok"].as_bool.should be_true
    end
  end

  it "raises UnsupportedProductError when X-Elastic-Product is missing" do
    with_stub_server({"Content-Type" => COMPAT_JSON}) do |port, _|
      client = build_client(port, {:compatibility_version => 8})
      expect_raises(Elasticsearch::UnsupportedProductError) do
        client.perform_request("GET", "")
      end
    end
  end

  it "does not raise when the product check is disabled" do
    with_stub_server({"Content-Type" => COMPAT_JSON}) do |port, _|
      client = build_client(port, {:compatibility_version => 8, :verify_product => 0})
      client.perform_request("GET", "").status.should eq 200
    end
  end

  it "does not check the product header unless enabled" do
    with_stub_server({"Content-Type" => "application/json"}) do |port, _|
      client = build_client(port)
      client.perform_request("GET", "").status.should eq 200
    end
  end

  it "can verify the product without compat mode" do
    with_stub_server({"Content-Type" => "application/json"}) do |port, _|
      client = build_client(port, {:verify_product => 1})
      expect_raises(Elasticsearch::UnsupportedProductError) do
        client.perform_request("GET", "")
      end
    end
  end
end
