module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Delete a snapshot from the repository
        #
        # @note Will also abort a currently running snapshot.
        #
        # @example Delete the `snapshot-1` snapshot
        #
        #     client.snapshot.delete repository: 'my-backups', snapshot: 'snapshot-1'
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [String] :snapshot A snapshot name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Number,List] :ignore The list of HTTP errors to ignore
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def delete(arguments={} of Symbol => String)
          if !arguments.has_key?(:repository) || !arguments.has_key?(:snapshot)
            raise ArgumentError.new("Required argument 'snapshot' or 'repository' missing")
          end
          valid_params = [
            :master_timeout ]

          repository = arguments.delete(:repository)
          snapshot   = arguments.delete(:snapshot) 
          ignore = arguments.delete(:ignore) || ""

          method = "DELETE"
          path   = Utils.__pathify( "_snapshot", Utils.__escape(repository.as(String)), Utils.__listify(snapshot.as(String)) )

          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil
          
          perform_request(method, path, params, body).body
  
        end
      end
    end
  end
end
