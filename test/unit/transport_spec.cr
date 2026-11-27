require "../spec_helper"
require "http/server"

describe "Elasticsearch transport errors" do
  server = HTTP::Server.new do |ctx|
    ctx.response.content_type = "application/json"
    if ctx.request.path == "/missing"
      ctx.response.status_code = 404
      ctx.response.print %({"error":{"type":"index_not_found_exception","reason":"nope"},"status":404})
    elsif ctx.request.path.starts_with?("/missing_doc/") && ctx.request.method == "HEAD"
      ctx.response.status_code = 404
    else
      ctx.response.print %({"ok":true,"query":"#{ctx.request.query}"})
    end
  end
  address = server.bind_tcp("127.0.0.1", 0)
  spawn { server.listen }
  Fiber.yield

  client = Elasticsearch::Test::Client.new({:host => "127.0.0.1", :port => address.port})

  it "raises NotFoundError from perform_request" do
    expect_raises(Elasticsearch::NotFoundError, /index_not_found_exception/) do
      client.perform_request("GET", "missing", {} of Symbol => String, nil)
    end
  end

  it "returns the body for ignored statuses and does not send ignore upstream" do
    response = client.perform_request("GET", "missing", {:ignore => 404}, nil)
    response.status.should eq(404)
    ok = client.perform_request("GET", "ok", {:ignore => "404", :pretty => "true"}, nil)
    ok.body.as(JSON::Any)["query"].as_s.should_not contain("ignore")
  end

  it "exists returns false on 404 without raising" do
    client.exists({:index => "missing_doc", :type => "t", :id => "1"}).should be_false
  end

  it "raises ConnectionError when the server is unreachable" do
    dead = Elasticsearch::Test::Client.new({:host => "127.0.0.1", :port => 1})
    expect_raises(Elasticsearch::ConnectionError) do
      dead.perform_request("GET", "x", {} of Symbol => String, nil)
    end
    dead.ping.should be_false
  end
end
