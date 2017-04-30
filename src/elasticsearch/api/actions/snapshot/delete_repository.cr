module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Delete a specific repository or repositories
        #
        # @example Delete the `my-backups` repository
        #
        #     client.snapshot.delete_repository repository: 'my-backups'
        #
        # @option arguments [List] :repository A comma-separated list of repository names (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Number,List] :ignore The list of HTTP errors to ignore
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def delete_repository(arguments={} of Symbol => String)
          if !arguments.has_key?(:repository)
            raise ArgumentError.new("Required argument 'repository' missing")
          end

          valid_params = [
            :master_timeout,
            :timeout ]

          repository = arguments.delete(:repository) || ""
          ignore = arguments.delete(:ignore) || ""

          method = "DELETE"
          path   = Utils.__pathify( "_snapshot", Utils.__listify(repository.as(String)) )

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
