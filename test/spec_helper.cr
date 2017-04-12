#require "spec"
require "../src/elasticsearch/api"
require "spec"
#require "spec2-mocks"
require "cossack"


module Elasticsearch
  module Test
    class FakeClient
      include Elasticsearch::API

      def perform_request(method, path, params, body)
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body}"
        FakeResponse.new(200, "FAKE", {} of Char => Char)
      end
    end

    class FakeResponse
      getter :status, :body, :headers

      def initialize(status=200, body="{}", headers={} of Char => Char)
        @status = status
        @body = body
        @headers = headers
      end
    end

    class NotFound < Exception; end
  end
end

class Response
  getter :status, :body, :headers

  def initialize(@status=200, @body="{}", @headers={} of Char => Char)
  end
end

module Elasticsearch
  class Client
    def initialize(@host="localhost", @port=9200)
    end

    #def change_hash_into_http_params(params)
    #  param_string = ""
    #  params.each |k,v| do
    #    param_string += "#{k}=#{v}"
    #  param_string

    def perform_request(method, path, params={} of Char => Char, body={} of Char => Char) 
      #transform_params = change_hash_into_http_params(params)

      if method == "GET"
        response = Cossack.get("http://#{@host}:#{port}/#{path}", params=params)
      elsif method == "POST"
        response = Cossack.post("http://#{@host}:#{port}/#{path}", body=JSON.parse(body))
      elsif method == "PUT"
        response = Cossack.put("http://#{@host}:#{port}/#{path}", body=JSON.parse(body))
      elsif method == "DELETE"
        response = Cossack.delete("http://#{@host}:#{port}/#{path}", params=params)
      end

      response
    end
  end
end


        
        
