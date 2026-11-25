require "http/client"
require "json"
require "./config"

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
        @settings : Settings
        @config : Config?

        def initialize(settings : Hash(Symbol, _))
          @settings = Config.normalize(settings)
        end

        # Connection configuration derived from the settings
        def config : Config
          @config ||= Config.new(@settings)
        end

        # Never print the settings hash, it may contain credentials
        def inspect(io : IO) : Nil
          io << "#<" << self.class.name << " " << config.base_url << ">"
        end

        def to_s(io : IO) : Nil
          inspect(io)
        end

        def perform_request(method, path, params={} of String => String, body={} of String => String | Nil) 

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
           
          # GET and DELETE carry the params in the query string
          target = "/#{path}"
          target += "?#{final_params}" if method == "GET" || method == "DELETE"

          headers = HTTP::Headers{"Content-Type" => "application/json"}
          if auth = config.authorization_header
            headers["Authorization"] = auth
          end

          # Only GET, POST and PUT send a body
          request_body = (method == "GET" || method == "POST" || method == "PUT") ? post_data : nil

          http = HTTP::Client.new(config.host, config.port, tls: config.tls_context)
          begin
            result = http.exec(method, target, headers: headers, body: request_body)
          ensure
            http.close
          end
         
          if result.headers["Content-Type"].includes?("application/json") && method != "HEAD"
            final_response = JsonResponse.new result.status_code, JSON.parse(result.body), result.headers
          else
            final_response = Response.new result.status_code, result.body.as(String), result.headers
          end
          
          final_response
          
        end
      end
    end
  end
end
