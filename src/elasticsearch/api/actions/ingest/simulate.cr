module Elasticsearch
  module API
    module Ingest
      module Actions

        # Execute a specific pipeline against the set of documents provided in the body of the request
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Hash] :body The pipeline definition (*Required*)
        # @option arguments [Boolean] :verbose Verbose mode. Display data output for each processor
        #                                                    in executed pipeline
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/simulate-pipeline-api.html
        #
        def simulate(arguments={} of Symbol => String)
          if !arguments.has_key?(:body)
            raise ArgumentError.new("Required argument 'body' missing")
          end
          valid_params = [
            :verbose ]
          method = "GET"
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id].as(String)), "_simulate"
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
