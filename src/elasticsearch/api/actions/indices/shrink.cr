module Elasticsearch
  module API
    module Indices
      module Actions

        # Copy an existing index into a new index with a fewer number of primary shards
        #
        # @option arguments [String] :index The name of the source index to shrink (*Required*)
        # @option arguments [String] :target The name of the target index to shrink into (*Required*)
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        # @option arguments [Number] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [Boolean] :wait_for_no_relocating_shards Whether to wait until there are no relocating
        #                                                            shards in the cluster
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-shrink-index.html
        #
        def shrink(arguments={} of Symbol => String)
          if !arguments.has_key?(:index) || !arguments.has_key?(:target)
            raise ArgumentError.new("Required argument 'index' or 'target' missing")
          end

          valid_params = [
            :wait_for_active_shards,
            :wait_for_no_relocating_shards,
            :timeout,
            :master_timeout
          ]

          source = arguments.delete(:index)
          target = arguments.delete(:target)

          if arguments.has_key? :body
            arg_body = arguments.delete(:body)
          else
            arg_body = nil
          end

          method = "PUT"
          path   = Utils.__pathify(source.as(String), "_shrink", target.as(String))
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arg_body

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
