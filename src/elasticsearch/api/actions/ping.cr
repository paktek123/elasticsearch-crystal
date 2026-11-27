module Elasticsearch
  module API
    module Actions

      # Returns true if the cluster returns a successful HTTP response, false otherwise.
      #
      # @example
      #
      #     client.ping
      #
      # @see http://elasticsearch.org/guide/
      #
      def ping(arguments={} of Symbol => String)
        method = "HEAD"
        path   = ""
        params = {} of String => String
        body   = nil

        begin
          perform_request(method, path, params, body).status == 200 ? true : false
        rescue Elasticsearch::NotFoundError | Elasticsearch::ConnectionError
          false
        end
      end
    end
  end
end
