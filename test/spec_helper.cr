require "spec"
require "../lib/elasticsearch/api"

module Elasticsearch
  module Test
    class FakeClient
      include Elasticsearch::API

      def perform_request(method, path, params, body)
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body}"
        FakeResponse.new(200, "FAKE", {} of String => String)
      end
    end

    FakeResponse = Struct.new(:status, :body, :headers) do
      def status
        values[0] || 200
      end
      def body
        values[1] || "{}"
      end
      def headers
        values[2] || {} of String => String
      end
    end

    class NotFound < StandardError; end
  end
end
