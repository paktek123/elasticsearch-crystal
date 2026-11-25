require "../../spec_helper"

# Integration test against a secured cluster (ES 8.x/9.x default install).
#
# Skipped unless ELASTIC_PASSWORD is set. Optional environment variables:
#   ES_SECURE_HOST (default localhost), ES_SECURE_PORT (default 9200),
#   ES_CA_FILE (path to http_ca.crt; when unset certificate verification is disabled)
#
#   docker run -d -p 9200:9200 -e ELASTIC_PASSWORD=changeme -e discovery.type=single-node \
#     docker.elastic.co/elasticsearch/elasticsearch:8.19.0
describe "Secured cluster" do
  password = ENV["ELASTIC_PASSWORD"]?

  if password.nil?
    pending "connects over https with basic auth (ELASTIC_PASSWORD not set)" { }
  else
    settings = Elasticsearch::API::Common::Settings{
      :scheme   => "https",
      :host     => ENV.fetch("ES_SECURE_HOST", "localhost"),
      :port     => ENV.fetch("ES_SECURE_PORT", "9200").to_i,
      :user     => "elastic",
      :password => password,
    }
    if ca = ENV["ES_CA_FILE"]?
      settings[:ca_file] = ca
    else
      settings[:verify] = false
    end
    subject = Elasticsearch::Test::Client.new(settings)

    it "connects over https with basic auth" do
      subject.perform_request("GET", "").status.should eq 200
      subject.info.as(JSON::Any)["tagline"].as_s.should eq "You Know, for Search"
    end

    it "is rejected with wrong credentials" do
      bad = Elasticsearch::Test::Client.new(settings.merge({:password => "wrong"}))
      bad.perform_request("GET", "").status.should eq 401
    end
  end
end
