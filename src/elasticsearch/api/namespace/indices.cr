module Elasticsearch
  module API
    module Indices
      module Actions; end

      # Client for the "indices" namespace (includes the {Indices::Actions} methods)
      #
      class IndicesClient < Common::Client
        include Indices::Actions
      end
    end
  end
end
