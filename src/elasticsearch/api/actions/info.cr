module Elasticsearch
  module API
    module Actions

      # Return simple information about the cluster (name, version).
      #
      # @see http://elasticsearch.org/guide/
      #
      def info(arguments={} of Symbol => String)
        method = "GET"
        path   = ""
        params = {} of String => String
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
