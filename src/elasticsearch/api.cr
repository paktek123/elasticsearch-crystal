#require "cgi" # ---> does not exist in crystal, we have html instead
require "html"
require "json" #----> JSON parsing library instead of multijson

require "./api/version"
require "./api/namespace/common"
require "./api/utils"

require "./api/actions/**"
#require "./api/actions/cat/**"
#require "./api/actions/indices/**"
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

      #@settings : Hash(Symbol, String | Int32)

      property :settings

      def initialize(@settings : Hash(Symbol, String | Int32))
        #@settings = settings
      end

      # The serializer class
      #
      def serializer
        @settings[:serializer] || Elasticsearch::API::Common::Constants::DEFAULT_SERIALIZER
      end

      def cat
        @cat ||= Elasticsearch::API::Cat::CatClient.new @settings
      end

      def cluster
        @cluster ||= Elasticsearch::API::Cluster::ClusterClient.new @settings
      end

      def indices
        @indices ||= Elasticsearch::API::Indices::IndicesClient.new @settings
      end

      def ingest
        @ingest ||= Elasticsearch::API::Ingest::IngestClient.new @settings
      end

      def nodes
        @nodes ||= Elasticsearch::API::Nodes::NodesClient.new @settings
      end

      def snapshot
        @snapshot ||= Elasticsearch::API::Snapshot::SnapshotClient.new @settings
      end

      def tasks
        @tasks ||= Elasticsearch::API::Tasks::TasksClient.new @settings
      end

      #def settings
      #  @settings || {} of Symbol => String | Int32
      #end
    end
  end
end
