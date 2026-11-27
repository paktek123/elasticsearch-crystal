require "http/client"
require "json"
require "../../errors"

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
        def initialize(@settings : Hash(Symbol, String | Int32)) 
        end

        def perform_request(method, path, params={} of String => String, body={} of String => String | Nil) 

          # normalize params to string
          new_params = {} of String => String
          ignore = [] of Int32
          params.each do |k,v|
            # client side option, never sent to Elasticsearch
            if k.to_s == "ignore"
              ignore = parse_ignore(v)
              next
            end
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
           
          if method == "GET"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.get(endpoint, body: post_data, headers: HTTP::Headers{"Content-Type" => "application/json"})
          elsif method == "POST"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.post(url: endpoint, body: post_data)
          elsif method == "PUT"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.put(url: endpoint, body: post_data)
          elsif method == "DELETE"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.delete(url: endpoint)
          elsif method == "HEAD"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.head(url: endpoint)
          end

          result = response.as(HTTP::Client::Response)
         
          if result.headers["Content-Type"].includes?("application/json") && method != "HEAD"
            final_response = JsonResponse.new result.status_code, JSON.parse(result.body), result.headers
          else
            final_response = Response.new result.status_code, result.body.as(String), result.headers
          end
          
          raise_on_error(final_response, ignore)

          final_response
        rescue e : IO::TimeoutError
          raise Elasticsearch::ConnectionTimeout.new(e.message, e)
        rescue e : IO::Error
          raise Elasticsearch::ConnectionError.new(e.message, e)
        end

        # Raises a typed Elasticsearch::ApiError for 4xx/5xx responses,
        # unless the status is listed in `ignore`.
        def raise_on_error(response, ignore = [] of Int32)
          status = response.status
          return if status < 400 || ignore.includes?(status)

          body = response.body
          error_type = nil
          reason = nil
          if body.is_a?(JSON::Any) && (error = body["error"]?)
            if error.as_h?
              error_type = error["type"]?.try &.as_s?
              reason = error["reason"]?.try &.as_s?
            else
              reason = error.as_s?
            end
          end

          case status
          when 400 then raise Elasticsearch::BadRequestError.new(status, body, error_type, reason)
          when 401 then raise Elasticsearch::AuthenticationError.new(status, body, error_type, reason)
          when 403 then raise Elasticsearch::AuthorizationError.new(status, body, error_type, reason)
          when 404 then raise Elasticsearch::NotFoundError.new(status, body, error_type, reason)
          when 409 then raise Elasticsearch::ConflictError.new(status, body, error_type, reason)
          else          raise Elasticsearch::ApiError.new(status, body, error_type, reason)
          end
        end

        # Normalizes the `ignore` option (404, "404", [404, 409]) to a list of statuses.
        def parse_ignore(value) : Array(Int32)
          case value
          when Int      then [value.to_i]
          when String   then value.split(',').compact_map(&.strip.to_i?)
          when Array    then value.flat_map { |v| parse_ignore(v) }
          else               [] of Int32
          end
        end
      end
    end
  end
end
