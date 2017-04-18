module Elasticsearch
  module API
    module Actions

      # Store a template for the search definition in Elasticsearch,
      # to be later used with the `search_template` method
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document (*Required*)
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def put_template(arguments={} of Symbol => String)
        if !arguments.has_key?(:body) || !arguments.has_key?(:id)
          raise ArgumentError.new("Required argument 'body' or 'id' missing")
        end
        method = "PUT"
        path   = "_search/template/#{arguments[:id]}"
        params = {} of String => String
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
