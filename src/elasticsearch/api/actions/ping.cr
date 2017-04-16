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
        method = HTTP_HEAD
        path   = ""
        params = {} of String => String
        body   = nil

        begin
          perform_request(method, path, params, body).status == 200 ? true : false
        rescue e : Exception
          if e.class.to_s =~ /NotFound|ConnectionFailed/ || e.message =~ /Not\s*Found|404|ConnectionFailed/i
            false
          else
            raise e
          end
        end
      end
    end
  end
end
