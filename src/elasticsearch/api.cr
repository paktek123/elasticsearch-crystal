#require "cgi" # ---> does not exist in crystal, we have html instead
require "html"
require "json" #----> JSON parsing library instead of multijson

require "./api/version"
require "./api/namespace/common"
require "./api/utils"

#require "./api/actions/**/*.cr"
require "./api/actions/cat/**"
#require "./api/namespace/**/*.cr"
require "./api/namespace/**"

module Elasticsearch
  module API
    class Client
      
      include Elasticsearch::API::Common
      #include Elasticsearch::API::Actions
      include Elasticsearch::API::Cluster
      include Elasticsearch::API::Nodes
      include Elasticsearch::API::Indices
      include Elasticsearch::API::Ingest
      include Elasticsearch::API::Snapshot
      include Elasticsearch::API::Tasks
      include Elasticsearch::API::Cat

      def initialize(settings={} of Symbol => String)
        @settings = settings
      end

      # The serializer class
      #
      def serializer
        settings[:serializer] || Elasticsearch::API::Common::Constants::DEFAULT_SERIALIZER
      end
    end
  end
end
