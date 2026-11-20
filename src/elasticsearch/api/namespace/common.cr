require "http/client"
require "json"

module Elasticsearch
  module API
    module Common
      module Actions; end

      module Constants
        DEFAULT_SERIALIZER = JSON

        COMMON_PARAMS = [
          :ignore,            # Client specific parameters
          :index, :type, :id, # :index/:type/:id
          :body,              # Request body
          :node_id,           # Cluster
          :name,              # Alias, template, settings, warmer, ...
          :field,             # Get field mapping
        ]

        COMMON_QUERY_PARAMS = [
          :ignore,      # Client specific parameters
          :format,      # Search, Cat, ...
          :pretty,      # Pretty-print the response
          :human,       # Return numeric values in human readable format
          :filter_path, # Filter the JSON response
        ]

        HTTP_GET          = "GET"
        HTTP_HEAD         = "HEAD"
        HTTP_POST         = "POST"
        HTTP_PUT          = "PUT"
        HTTP_DELETE       = "DELETE"
        UNDERSCORE_SEARCH = "_search"
        UNDERSCORE_ALL    = "_all"
      end

      class Response
        getter :status, :body, :headers

        def initialize(@status : Int32, @body : String, @headers : HTTP::Headers)
        end
      end

      class JsonResponse
        getter :status, :body, :headers

        def initialize(@status : Int32, @body : JSON::Any, @headers : HTTP::Headers)
        end
      end

      class Client
        def initialize(@settings : Hash(Symbol, String | Int32))
        end

        # Normalizes params to a URL-encoded query string. Booleans become
        # "true"/"false"; nil becomes an empty value.
        def self.build_query(params) : String
          new_params = {} of String => String
          params.each do |k, v|
            new_params[k.to_s] = v.to_s
          end

          HTTP::Params.encode(new_params)
        end

        # Builds "path" or "path?query" (no trailing "?" when params are empty).
        def self.build_url(path, params) : String
          query = build_query(params)
          query.empty? ? path.to_s : "#{path}?#{query}"
        end

        # Wraps an HTTP response; a missing Content-Type is treated as non-JSON.
        def self.parse_response(result : HTTP::Client::Response, method = "GET")
          content_type = result.headers["Content-Type"]?
          if content_type && content_type.includes?("application/json") && method != "HEAD"
            JsonResponse.new result.status_code, JSON.parse(result.body), result.headers
          else
            Response.new result.status_code, result.body.to_s, result.headers
          end
        end

        def perform_request(method, path, params = {} of String => String, body = {} of String => String | Nil)
          post_data = body.nil? ? nil : body.to_json
          url = "http://#{@settings[:host]}:#{@settings[:port]}/#{Client.build_url(path, params)}"

          case method
          when "GET"
            response = HTTP::Client.exec("GET", url, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: post_data)
          when "POST", "PUT"
            response = HTTP::Client.exec(method, url, body: post_data)
          else
            response = HTTP::Client.exec(method, url)
          end

          Client.parse_response(response, method)
        end
      end
    end
  end
end
