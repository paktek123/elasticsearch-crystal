module Elasticsearch
  module API
    module Nodes
      module Actions; end

      # Client for the "nodes" namespace (includes the {Nodes::Actions} methods)
      #
      class NodesClient < Common::Client
        include Nodes::Actions
      end
    end
  end
end
