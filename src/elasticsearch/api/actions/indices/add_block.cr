module Elasticsearch
  module API
    module Indices
      module Actions

        # Add an index block (`metadata`, `read`, `read_only` or `write`) to an index
        #
        # @option arguments [String] :index The name of the index to add the block to (*Required*)
        # @option arguments [String] :block The block to add: metadata, read, read_only or write (*Required*)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard expression resolves to no indices
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expressions to concrete indices
        #                                              (options: open, closed, hidden, none, all)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored
        #                                                 when unavailable (missing or closed)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules-blocks.html
        #
        def add_block(arguments={} of Symbol => String)
          if !arguments.has_key?(:index) || !arguments.has_key?(:block)
            raise ArgumentError.new("Required argument 'index' or 'block' missing")
          end

          valid_params = [
            :allow_no_indices,
            :expand_wildcards,
            :ignore_unavailable,
            :timeout,
            :master_timeout
          ]

          index = arguments.delete(:index)
          block = arguments.delete(:block)

          method = "PUT"
          path   = Utils.__pathify(Utils.__listify(index.as(String)), "_block", Utils.__escape(block.as(String)))
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
