module Elasticsearch
  module API
    module Snapshot
      module Actions; end

      # Client for the "snapshot" namespace (includes the {Snapshot::Actions} methods)
      #
      class SnapshotClient < Common::Client
        include Snapshot::Actions
      end
    end
  end
end
