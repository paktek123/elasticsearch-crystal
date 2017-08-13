module Elasticsearch
  module API
    module Snapshot
      module Actions

        # Explicitly perform the verification of a repository
        #
        # @option arguments [String] :repository A repository name (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-snapshots.html
        #
        def verify_repository(arguments={} of Symbol => String)
          if !arguments.has_key?(:repository)
            raise ArgumentError.new("Required argument 'repository' missing")
          end
          valid_params = [
            :repository,
            :master_timeout,
            :timeout ]

          repository = arguments.delete(:repository) 
          method = "POST"
          path   = Utils.__pathify( "_snapshot", Utils.__escape(repository.as(String)), "_verify" )
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
