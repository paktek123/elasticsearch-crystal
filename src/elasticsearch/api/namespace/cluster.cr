module Elasticsearch
  module API
    module Cluster
      module Actions; end

      # Client for the "cluster" namespace (includes the {Cluster::Actions} methods)
      #
      class ClusterClient < Common::Client
        include Cluster::Actions
      end
    end
  end
end
