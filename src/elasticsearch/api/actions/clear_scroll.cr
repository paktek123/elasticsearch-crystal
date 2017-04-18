module Elasticsearch
  module API
    module Actions

      # Abort a particular scroll search and clear all the resources associated with it.
      #
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear;
      #                                     use `_all` clear all scroll search contexts
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-search-type.html#clear-scroll
      #
      def clear_scroll(arguments={} of Symbol => String)
        if !arguments.has_key?(:scroll_id)
          raise ArgumentError.new("Required argument 'scroll_id' missing")
        end

        method = "DELETE"
        path   = Utils.__pathify "_search/scroll", Utils.__listify(arguments.delete(:scroll_id))
        params = {} of Char => Char
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
