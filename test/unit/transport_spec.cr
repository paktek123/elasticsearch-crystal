require "spec"
require "../../src/elasticsearch/api"

alias TransportClient = Elasticsearch::API::Common::Client

describe "Elasticsearch::API::Common::Client request building" do
  describe ".build_query" do
    it "returns an empty string for empty params" do
      TransportClient.build_query({} of String => String).should eq ""
    end

    it "encodes true as true and false as false" do
      params = {:pretty => true, :refresh => false}
      TransportClient.build_query(params).should eq "pretty=true&refresh=false"
    end

    it "url-encodes values" do
      TransportClient.build_query({"q" => "a b&c"}).should eq "q=a+b%26c"
    end

    it "keeps nil as an empty value (existing behaviour)" do
      TransportClient.build_query({"q" => nil}).should eq "q="
    end

    it "stringifies numbers and mixed value types" do
      params = {:size => 10, :q => "x"} of Symbol => (Int32 | String)
      TransportClient.build_query(params).should eq "size=10&q=x"
    end
  end

  describe ".build_url" do
    # The query string is built independent of the HTTP method.
    ["GET", "POST", "PUT", "HEAD", "DELETE"].each do |method|
      it "appends the query string for #{method}" do
        TransportClient.build_url("idx/_doc/1", {:refresh => false}).should eq "idx/_doc/1?refresh=false"
      end
    end

    it "adds no trailing ? when params are empty" do
      TransportClient.build_url("_cluster/health", {} of String => String).should eq "_cluster/health"
    end
  end

  describe ".parse_response" do
    it "does not raise when Content-Type is missing" do
      res = TransportClient.parse_response(HTTP::Client::Response.new(200, body: "pong"))
      res.should be_a(Elasticsearch::API::Common::Response)
      res.body.should eq "pong"
    end

    it "parses JSON when Content-Type is application/json" do
      headers = HTTP::Headers{"Content-Type" => "application/json; charset=UTF-8"}
      res = TransportClient.parse_response(HTTP::Client::Response.new(200, body: %({"a":1}), headers: headers))
      res.should be_a(Elasticsearch::API::Common::JsonResponse)
      res.status.should eq 200
    end

    it "returns a plain response for HEAD even with JSON content type" do
      headers = HTTP::Headers{"Content-Type" => "application/json"}
      res = TransportClient.parse_response(HTTP::Client::Response.new(404, body: "", headers: headers), "HEAD")
      res.should be_a(Elasticsearch::API::Common::Response)
      res.status.should eq 404
    end
  end
end
