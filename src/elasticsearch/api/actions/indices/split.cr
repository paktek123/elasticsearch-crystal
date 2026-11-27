module Elasticsearch
  module API
    module Indices
      module Actions

        # Resize an existing index into a new index via the split API
        #
        # The source index must be read-only (`index.blocks.write: true`), see `add_block`.
        #
        # @option arguments [String] :index The name of the source index to split (*Required*)
        # @option arguments [String] :target The name of the target index to split into (*Required*)
        # @option arguments [Hash] :body The configuration for the target index (`settings` and `aliases`)
        # @option arguments [Number] :wait_for_active_shards Wait until the specified number of shards is active
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-split-index.html
        #
        def split(arguments={} of Symbol => String)
          if !arguments.has_key?(:index) || !arguments.has_key?(:target)
            raise ArgumentError.new("Required argument 'index' or 'target' missing")
          end

          valid_params = [
            :wait_for_active_shards,
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
          path   = Utils.__pathify(Utils.__escape(source.as(String)), "_split", Utils.__escape(target.as(String)))
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = arg_body

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
