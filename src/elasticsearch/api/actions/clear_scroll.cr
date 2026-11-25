module Elasticsearch
  module API
    module Actions
      # Abort a particular scroll search and clear all the resources associated with it.
      #
      # The preferred form sends the IDs in the request body (`DELETE /_search/scroll`); the
      # path form (`DELETE /_search/scroll/{scroll_id}`) is deprecated since Elasticsearch 7.0
      # but is still used when only `:scroll_id` is given.
      #
      # @example Clear scrolls using the request body
      #
      #     client.clear_scroll({:body => {"scroll_id" => ["id1", "id2"]}})
      #
      # @example Clear all scroll search contexts
      #
      #     client.clear_scroll({:scroll_id => "_all"})
      #
      # @option arguments [Hash] :body The request body, e.g. `{"scroll_id" => ["id1", "id2"]}`
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear;
      #                                     use `_all` clear all scroll search contexts.
      #                                     Required unless a `:body` is given.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/clear-scroll-api.html
      #
      def clear_scroll(arguments = {} of Symbol => String)
        if !arguments.has_key?(:scroll_id) && !arguments.has_key?(:body)
          raise ArgumentError.new("Required argument 'scroll_id' or 'body' missing")
        end

        scroll_id = arguments.delete(:scroll_id)

        method = "DELETE"
        if scroll_id.nil?
          path = "_search/scroll"
        else
          path = Utils.__pathify "_search/scroll", Utils.__listify(scroll_id.to_s)
        end
        params = {} of String => String
        body = arguments.has_key?(:body) ? arguments[:body] : nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
