module Elasticsearch
  module Transport
    module Transport

      # Wraps the response from Elasticsearch.
      #
      class Response
        getter :status, :body, :headers

        # @param status  [Integer] Response status code
        # @param body    [String]  Response body
        # @param headers [Hash]    Response headers
        def initialize(status, body, headers={} of Char => Char)
          @status, @body, @headers = status, body, headers
          @body = body.force_encoding('UTF-8') if body.respond_to?(:force_encoding)
        end
      end

    end
  end
end
