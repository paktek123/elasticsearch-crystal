require "http/client"
require "json"
require "../errors"

module Elasticsearch
  module API
    module Common
      module Actions; end

      module Constants
        DEFAULT_SERIALIZER = JSON
  
        COMMON_PARAMS = [
          :ignore,                        # Client specific parameters
          :index, :type, :id,             # :index/:type/:id
          :body,                          # Request body
          :node_id,                       # Cluster
          :name,                          # Alias, template, settings, warmer, ...
          :field                          # Get field mapping
        ]
    
        COMMON_QUERY_PARAMS = [
          :ignore,                        # Client specific parameters
          :format,                        # Search, Cat, ...
          :pretty,                        # Pretty-print the response
          :human,                         # Return numeric values in human readable format
          :filter_path                    # Filter the JSON response
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
        @product_verified = false

        def initialize(@settings : Hash(Symbol, String | Int32))
        end

        def perform_request(method, path, params={} of String => String, body={} of String => String | Nil, ndjson = false)

          # normalize params to string
          new_params = {} of String => String
          params.each do |k,v|
            if !!v == v
              new_params[k.to_s] = ""
            else
              new_params[k.to_s] = v.to_s
            end
          end
          
          final_params = HTTP::Params.encode(new_params)

          if !body.nil?
            post_data = body.to_json
          else
            post_data = nil
          end
           
          headers = build_headers(method, !post_data.nil?, ndjson)

          if method == "GET"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.get(endpoint, body: post_data, headers: headers)
          elsif method == "POST"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.post(url: endpoint, body: post_data, headers: headers)
          elsif method == "PUT"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.put(url: endpoint, body: post_data, headers: headers)
          elsif method == "DELETE"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.delete(url: endpoint, headers: headers)
          elsif method == "HEAD"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.head(url: endpoint, headers: headers)
          end

          result = response.as(HTTP::Client::Response)

          verify_product(result)

          content_type = result.headers["Content-Type"]? || ""
          if (content_type.includes?("application/json") || content_type.includes?("application/vnd.elasticsearch+json")) && method != "HEAD"
            final_response = JsonResponse.new result.status_code, JSON.parse(result.body), result.headers
          else
            final_response = Response.new result.status_code, result.body.as(String), result.headers
          end
          
          final_response

        end

        # Request headers. With `:compatibility_version` set, `Accept` and (when
        # there is a body) `Content-Type` use the versioned vendor media types.
        private def build_headers(method, has_body : Bool, ndjson : Bool)
          headers = HTTP::Headers.new
          version = @settings[:compatibility_version]?

          if version
            kind = ndjson ? "x-ndjson" : "json"
            media_type = "application/vnd.elasticsearch+#{kind}; compatible-with=#{version}"
            headers["Accept"] = media_type
            headers["Content-Type"] = media_type if has_body && {"GET", "POST", "PUT"}.includes?(method)
          elsif method == "GET"
            headers["Content-Type"] = "application/json"
          end

          headers
        end

        # Checks `X-Elastic-Product` on the first successful response. Enabled when
        # `:compatibility_version` is set, or with `:verify_product => 1`; disable
        # with `:verify_product => 0`.
        private def verify_product(result : HTTP::Client::Response)
          return if @product_verified || !(200..299).includes?(result.status_code)

          setting = @settings[:verify_product]?
          enabled = setting.nil? ? !@settings[:compatibility_version]?.nil? : !{0, "0", "false"}.includes?(setting)

          if enabled && result.headers["X-Elastic-Product"]? != "Elasticsearch"
            raise Elasticsearch::UnsupportedProductError.new
          end

          @product_verified = true
        end
      end
    end
  end
end
