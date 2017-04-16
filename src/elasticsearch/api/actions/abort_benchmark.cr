module Elasticsearch
  module API
    module Actions

      # Abort a running benchmark
      #
      # @example
      #
      #     client.abort_benchmark name: 'my_benchmark'
      #
      # @option arguments [String] :name A benchmark name
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-benchmark.html
      #
      def abort_benchmark(arguments={} of Symbol => String)
        method = "POST"
        path   = "_bench/abort/#{arguments[:name]}"
        params = {} of String => String
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
