require "../spec_helper"
require "http/server"

alias Config = Elasticsearch::API::Common::Config
alias Settings = Elasticsearch::API::Common::Settings

describe "Elasticsearch::API::Common::Config" do
  it "defaults to http://localhost:9200 without auth" do
    config = Config.new(Settings.new)
    config.base_url.should eq "http://localhost:9200"
    config.https?.should be_false
    config.verify?.should be_true
    config.authorization_header.should be_nil
    config.tls_context.should be_nil
  end

  it "keeps backwards compatible host/port settings" do
    config = Config.new(Settings{:host => "example.com", :port => 9250})
    config.base_url.should eq "http://example.com:9250"
  end

  it "accepts plain String | Int32 settings hashes for existing callers" do
    client = Elasticsearch::API::Client.new({:host => "localhost", :port => 9250})
    client.config.base_url.should eq "http://localhost:9250"
    Elasticsearch::API::Client.new({:host => "localhost"}).config.port.should eq 9200
  end

  it "builds an https url from scheme" do
    config = Config.new(Settings{:scheme => "https", :host => "es.local", :port => 9200})
    config.base_url.should eq "https://es.local:9200"
    config.https?.should be_true
    config.tls_context.should_not be_nil
  end

  it "builds a basic authorization header" do
    config = Config.new(Settings{:user => "elastic", :password => "changeme"})
    config.authorization_header.should eq "Basic ZWxhc3RpYzpjaGFuZ2VtZQ=="
  end

  it "parses a full url with credentials" do
    config = Config.new(Settings{:url => "https://elastic:p%40ss@es.local:9243"})
    config.scheme.should eq "https"
    config.host.should eq "es.local"
    config.port.should eq 9243
    config.user.should eq "elastic"
    config.authorization_header.should eq "Basic #{Base64.strict_encode("elastic:p@ss")}"
    config.base_url.should eq "https://es.local:9243"
  end

  it "lets explicit settings override the url" do
    config = Config.new(Settings{:url => "https://a:b@es.local:9243", :user => "x", :password => "y", :port => 9200})
    config.user.should eq "x"
    config.port.should eq 9200
    config.authorization_header.should eq "Basic #{Base64.strict_encode("x:y")}"
  end

  it "defaults the port to 9200 for a url without one" do
    Config.new(Settings{:url => "https://es.local"}).port.should eq 9200
  end

  it "reads verify and ca_file" do
    config = Config.new(Settings{:scheme => "https", :verify => false, :ca_file => "/tmp/ca.crt"})
    config.verify?.should be_false
    config.ca_file.should eq "/tmp/ca.crt"
    Config.new(Settings{:verify => "false"}).verify?.should be_false
    Config.new(Settings{:verify => true}).verify?.should be_true
  end

  it "rejects unsupported schemes without leaking credentials" do
    error = expect_raises(ArgumentError) do
      Config.new(Settings{:scheme => "ftp", :user => "elastic", :password => "s3cret"})
    end
    error.message.to_s.should_not contain("s3cret")
  end

  it "does not leak the password through inspect or to_s" do
    config = Config.new(Settings{:user => "elastic", :password => "s3cret", :host => "h"})
    config.inspect.should_not contain("s3cret")
    config.to_s.should_not contain("s3cret")
    config.inspect.should contain("[REDACTED]")
    config.inspect.should_not contain(Base64.strict_encode("elastic:s3cret"))

    client = Elasticsearch::Test::Client.new(Settings{:user => "elastic", :password => "s3cret"})
    client.inspect.should_not contain("s3cret")
    client.to_s.should_not contain("s3cret")
    client.cluster.inspect.should_not contain("s3cret")
  end

  it "sends the Authorization header on requests" do
    seen = Channel(String?).new(1)
    server = HTTP::Server.new do |context|
      seen.send context.request.headers["Authorization"]?
      context.response.content_type = "application/json"
      context.response.print %({"ok":true})
    end
    address = server.bind_tcp "127.0.0.1", 0
    spawn { server.listen }
    Fiber.yield

    client = Elasticsearch::Test::Client.new(Settings{:host => "127.0.0.1", :port => address.port, :user => "elastic", :password => "changeme"})
    client.perform_request("GET", "")
    seen.receive.should eq "Basic ZWxhc3RpYzpjaGFuZ2VtZQ=="

    anonymous = Elasticsearch::Test::Client.new(Settings{:host => "127.0.0.1", :port => address.port})
    anonymous.perform_request("GET", "")
    seen.receive.should be_nil
    server.close
  end
end
