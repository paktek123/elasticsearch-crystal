module Elasticsearch
  module API
    module Cat
      module Actions; end

      # Client for the "cat" namespace (includes the {Cat::Actions} methods)
      #
      class CatClient < Common::Client
        include Cat::Actions
      end
    end
  end
end
