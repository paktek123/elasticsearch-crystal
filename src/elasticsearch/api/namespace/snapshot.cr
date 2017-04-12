module Elasticsearch
  module API
    module Snapshot
      module Actions; end

      # Client for the "snapshot" namespace (includes the {Snapshot::Actions} methods)
      #
      class SnapshotClient
        include Common::Client
        #include Common::Client::Base
        include Snapshot::Actions
      end

      # Proxy method for {SnapshotClient}, available in the receiving object
      #
      def snapshot
        @snapshot ||= SnapshotClient.new(self)
      end

    end
  end
end
