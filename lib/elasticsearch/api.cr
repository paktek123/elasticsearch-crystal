#require "cgi" # ---> does not exist in crystal, we have html instead
require "html"
require "json" #----> JSON parsing library instead of multijson

require "./api/version"
require "./api/namespace/common"
require "./api/utils"

require "./api/actions/**/*.cr"
require "./api/namespace/**/*.cr"

module Elasticsearch
  module API
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

    HTTP_GET          = "GET".freeze
    HTTP_HEAD         = "HEAD".freeze
    HTTP_POST         = "POST".freeze
    HTTP_PUT          = "PUT".freeze
    HTTP_DELETE       = "DELETE".freeze
    UNDERSCORE_SEARCH = "_search".freeze
    UNDERSCORE_ALL    = "_all".freeze

    # Auto-include all namespaces in the receiver
    #
    def self.included(base)
      base.send :include,
                Elasticsearch::API::Common,
                Elasticsearch::API::Actions,
                Elasticsearch::API::Cluster,
                Elasticsearch::API::Nodes,
                Elasticsearch::API::Indices,
                Elasticsearch::API::Ingest,
                Elasticsearch::API::Snapshot,
                Elasticsearch::API::Tasks,
                Elasticsearch::API::Cat
    end

    # The serializer class
    #
    def self.serializer
      settings[:serializer] || DEFAULT_SERIALIZER
    end

    # Access the module settings
    #
    def self.settings
      @settings ||= {} of Symbol => String
    end
  end
end
