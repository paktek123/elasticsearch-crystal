require "../spec_helper"

def stub_response(status : Int32, body : String = "")
  http = HTTP::Client::Response.new(status, body, HTTP::Headers{"Content-Type" => "application/json"})
  if http.headers["Content-Type"].includes?("application/json") && !body.empty?
    Elasticsearch::API::Common::JsonResponse.new http.status_code, JSON.parse(http.body), http.headers
  else
    Elasticsearch::API::Common::Response.new http.status_code, http.body, http.headers
  end
end

ES_ERROR = %({"error":{"type":"index_not_found_exception","reason":"no such index"},"status":404})

describe "Elasticsearch errors" do
  client = Elasticsearch::Test::Client.new({:host => "localhost", :port => 9200})

  {
    400 => Elasticsearch::BadRequestError,
    401 => Elasticsearch::AuthenticationError,
    403 => Elasticsearch::AuthorizationError,
    404 => Elasticsearch::NotFoundError,
    409 => Elasticsearch::ConflictError,
    418 => Elasticsearch::ApiError,
    500 => Elasticsearch::ApiError,
    503 => Elasticsearch::ApiError,
  }.each do |status, klass|
    it "raises #{klass} for #{status}" do
      error = expect_raises(Elasticsearch::ApiError) do
        client.raise_on_error(stub_response(status, ES_ERROR), [] of Int32)
      end
      error.class.should eq(klass)
      error.status.should eq(status)
      error.error_type.should eq("index_not_found_exception")
      error.reason.should eq("no such index")
      error.body.as(JSON::Any)["status"].as_i.should eq(404)
    end
  end

  it "does not raise for 2xx and 3xx" do
    client.raise_on_error(stub_response(200, "{}"))
    client.raise_on_error(stub_response(301))
  end

  it "handles non JSON and string error bodies" do
    error = expect_raises(Elasticsearch::NotFoundError) { client.raise_on_error(stub_response(404)) }
    error.error_type.should be_nil
    error = expect_raises(Elasticsearch::ApiError) { client.raise_on_error(stub_response(500, %({"error":"boom"}))) }
    error.reason.should eq("boom")
  end

  it "has a common base class" do
    Elasticsearch::NotFoundError.new(404).should be_a(Elasticsearch::Error)
    Elasticsearch::ConnectionTimeout.new.should be_a(Elasticsearch::ConnectionError)
  end

  describe "ignore" do
    it "suppresses a single status" do
      client.raise_on_error(stub_response(404, ES_ERROR), client.parse_ignore(404))
    end

    it "suppresses a list of statuses" do
      client.raise_on_error(stub_response(409, ES_ERROR), client.parse_ignore([404, 409]))
    end

    it "still raises for statuses that are not ignored" do
      expect_raises(Elasticsearch::BadRequestError) do
        client.raise_on_error(stub_response(400, ES_ERROR), client.parse_ignore([404, 409]))
      end
    end

    it "normalizes values" do
      client.parse_ignore(404).should eq([404])
      client.parse_ignore("404,409").should eq([404, 409])
      client.parse_ignore([404, 409]).should eq([404, 409])
      client.parse_ignore(nil).should eq([] of Int32)
    end
  end
end
