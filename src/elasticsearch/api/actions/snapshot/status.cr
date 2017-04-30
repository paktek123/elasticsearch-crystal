module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Return information about a running snapshot
        #
        # @example Return information about all currently running snapshots
        #
        #     client.snapshot.status repository: 'my-backups', human: true
        #
        # @example Return information about a specific snapshot
        #
        #     client.snapshot.status repository: 'my-backups', human: true
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [List] :snapshot A comma-separated list of snapshot names
        # @option arguments [Boolean] :ignore_unavailable Whether to ignore unavailable snapshots, defaults to #                                                 false which means a SnapshotMissingException is thrown
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Number,List] :ignore The list of HTTP errors to ignore
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html#_snapshot_status
        #
        def status(arguments={} of Symbol => String)
          valid_params = [
            :ignore_unavailable,
            :master_timeout ]

          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot)
          ignore = arguments.delete(:ignore) || ""

          method = "GET"

          path   = Utils.__pathify( "_snapshot", Utils.__escape(repository.as(String)), Utils.__escape(snapshot.as(String)), "_status")
          arguments = Utils.__sort_booleans(arguments)
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          if ignore.includes?("404")
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
