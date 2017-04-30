module Elasticsearch
  module API
    module Cat
      module Actions

        # Shows all snapshots that belong to a specific repository
        #
        # @example Return snapshots for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository'
        #
        # @example Return id, status and start_epoch for 'my_repository'
        #
        #     client.cat.snapshots repository: 'my_repository', h: 'id,status,start_epoch'
        #
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-snapshots.html
        #
        def snapshots(arguments={} of Symbol => String)
          if !arguments.has_key?(:repository)
            raise ArgumentError.new("Required argument 'repository' missing") 
          end

          valid_params = [
            :master_timeout,
            :h,
            :help,
            :v,
            :s ]

          repository = arguments.delete(:repository) || ""

          method = "GET"
          arguments = Utils.__sort_booleans(arguments)
          path   = Utils.__pathify "_cat/snapshots", Utils.__escape(repository.as(String))
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end

