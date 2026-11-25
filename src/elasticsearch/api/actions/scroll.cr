module Elasticsearch
  module API
    module Actions
      # Retrieve the next batch of results for a scrolling search.
      #
      # The `scroll_id` and `scroll` values are sent in the request body (`POST /_search/scroll`),
      # not in the URL, since scroll IDs can exceed URL length limits.
      #
      # @example Page through the results of a scrolling search
      #
      #     response = client.search({:index => "myindex", :scroll => "1m", :size => 100}).as(JSON::Any)
      #     scroll_id = response["_scroll_id"].as_s
      #     response = client.scroll({:scroll_id => scroll_id, :scroll => "1m"}).as(JSON::Any)
      #
      # @option arguments [String] :scroll_id The scroll ID returned by the previous search or scroll request (required)
      # @option arguments [Duration] :scroll Specify how long a consistent view of the index should be maintained
      #                                      for scrolled search (e.g. `"1m"`)
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer
      #                                                      or an object in the rest search response
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/scroll-api.html
      #
      def scroll(arguments = {} of Symbol => String)
        if !arguments.has_key?(:scroll_id)
          raise ArgumentError.new("Required argument 'scroll_id' missing")
        end

        valid_params = [
          :rest_total_hits_as_int,
        ]

        method = "POST"
        path = "_search/scroll"

        scroll_body = {} of String => String
        scroll_body["scroll_id"] = arguments[:scroll_id].as(String)
        scroll_body["scroll"] = arguments[:scroll].as(String) if arguments.has_key?(:scroll)

        # `scroll_id` and `scroll` travel in the body, not as query parameters
        arguments.delete(:scroll_id)
        arguments.delete(:scroll)

        params = Utils.__validate_and_extract_params arguments, valid_params

        perform_request(method, path, params, scroll_body).body
      end
    end
  end
end
