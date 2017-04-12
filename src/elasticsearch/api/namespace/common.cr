require "http/client"

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

      module Client
        def perform_request(method, path, params={} of Char => Char, body={} of Char => Char) 

          settings = {:host => "localhost", :port => 9250}
          # normalize params to string
          new_params = {} of String => String
          params.each do |k,v|
            if !!v == v
              new_params[k.to_s] = ""
            else
              new_params[k.to_s] = v.to_s
            end
          end
          puts new_params
          final_params = HTTP::Params.from_hash(new_params)
          endpoint = "http://#{settings[:host]}:#{settings[:port]}/#{path}?#{final_params}"
           
          puts endpoint 
          if method == "GET"
            response = HTTP::Client.get(endpoint)
          elsif method == "POST"
            puts "hello"
            #response = Cossack.post(endpoint, body=body.to_s)
          elsif method == "PUT"
            puts "hello"
            #response = Cossack.put(endpoint, body=body.to_s)
          elsif method == "DELETE"
            #response = Cossack.delete(endpoint)
            puts "hello"
          end
          # return as HTTP::Client::Response otherwise it return Nil
          response.as(HTTP::Client::Response)
        end
      end
    end
  end
end
