require "http/client"
require "json"

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

      class Client
        #@settings : Hash(Symbol, String | Int32)
        def initialize(@settings : Hash(Symbol, String | Int32)) 
        end

        def perform_request(method, path, params={} of String => String, body={} of String => String | Nil) 

          #@settings = {:host => "localhost", :port => 9250}

          # normalize params to string
          new_params = {} of String => String
          params.each do |k,v|
            if !!v == v
              new_params[k.to_s] = ""
            else
              new_params[k.to_s] = v.to_s
            end
          end
          #puts new_params
          final_params = HTTP::Params.from_hash(new_params)
          #endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"

          #puts "THE BODY IS #{body}"

          if !body.nil?
            post_data = body.to_json
            #puts "hi"
          else
            post_data = nil
          end
           
          if method == "GET"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.get(endpoint)
          elsif method == "POST"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.post(url: endpoint, body: post_data)
          elsif method == "PUT"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}"
            response = HTTP::Client.put(url: endpoint, body: post_data)
          elsif method == "DELETE"
            endpoint = "http://#{@settings[:host]}:#{@settings[:port]}/#{path}?#{final_params}"
            response = HTTP::Client.delete(url: endpoint)
          end

          #puts "#{method} #{endpoint} #{params} #{new_params} #{post_data}" 
          # return as HTTP::Client::Response otherwise it return Nil
          response.as(HTTP::Client::Response)
        end
      end
    end
  end
end
