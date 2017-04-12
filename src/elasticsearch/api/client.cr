#equire "./api/version"
#equire "./api/namespace/common"
#equire "./api/utils"

#require "./api/actions/**/*.cr"
#equire "./api/actions/cat/**"
#require "./api/namespace/**/*.cr"
#equire "./api/namespace/**"

#odule Elasticsearch
# module API
#   class Client
#     DEFAULT_SERIALIZER = JSON

#     COMMON_PARAMS = [
#       :ignore,                        # Client specific parameters
#       :index, :type, :id,             # :index/:type/:id
#       :body,                          # Request body
#       :node_id,                       # Cluster
#       :name,                          # Alias, template, settings, warmer, ...
#       :field                          # Get field mapping
#     ]
# 
#     COMMON_QUERY_PARAMS = [
#       :ignore,                        # Client specific parameters
#       :format,                        # Search, Cat, ...
#       :pretty,                        # Pretty-print the response
#       :human,                         # Return numeric values in human readable format
#       :filter_path                    # Filter the JSON response
#     ]

#     HTTP_GET          = "GET"
#     HTTP_HEAD         = "HEAD"
#     HTTP_POST         = "POST"
#     HTTP_PUT          = "PUT"
#     HTTP_DELETE       = "DELETE"
#     UNDERSCORE_SEARCH = "_search"
#     UNDERSCORE_ALL    = "_all"

#     include Elasticsearch::API::Common
#     include Elasticsearch::API::Actions
#     include Elasticsearch::API::Cluster
#     include Elasticsearch::API::Nodes
#     include Elasticsearch::API::Indices
#     include Elasticsearch::API::Ingest
#     include Elasticsearch::API::Snapshot
#     include Elasticsearch::API::Tasks
#     include Elasticsearch::API::Cat

#     def initialize(settings={} of Symbol => String)
#       @settings = settings
#     end

#     # The serializer class
#     #
#     def serializer
#       settings[:serializer] || DEFAULT_SERIALIZER
#     end

      #@host = "localhost"
      #@port = 9200
#
      #def initialize(host=@host, port=@port)
      #  @@host = host
      #  @@port = port
      #end
  #
      #def perform_request(method, path, params={} of Char => Char, body={} of Char => Char) 
      #  puts "I made it here"
      #  # normalize params to string
      #  new_params = {} of String => String
      #  params.each do |k,v|
      #    new_params.merge({k.to_s => v.to_s})
      #  end
  #
      #  if method == "GET"
      #    puts "http://#{@@host}:#{@@port}/#{path}"
      #    response = Cossack.get("http://#{@host}:#{@port}/#{path}") #, params=new_params)
      #  elsif method == "POST"
      #    response = Cossack.post("http://#{@host}:#{@port}/#{path}", body=body.to_s)
      #  elsif method == "PUT"
      #    response = Cossack.put("http://#{@host}:#{@port}/#{path}", body=body.to_s)
      #  elsif method == "DELETE"
      #    response = Cossack.delete("http://#{@host}:#{@port}/#{path}", params=new_params)
      #  end
  #
      #  response
      #end
#    end
#  end
#end
