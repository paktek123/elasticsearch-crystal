module Elasticsearch
  module API
    module Ingest
      module Actions; end

      # Client for the "ingest" namespace (includes the {Ingest::Actions} methods)
      #
      class IngestClient < Common::Client
        include Ingest::Actions
      end
    end
  end
end
