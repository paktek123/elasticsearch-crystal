module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete all documents and mapping for a specific document type.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` for all indices (*Required*)
        # @option arguments [String] :type The name of the document type to delete (*Required*)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-delete-mapping/
        #
        def delete_mapping(arguments={} of Symbol => String)
          if !arguments.has_key?(:index) || !arguments.has_key?(:type)
            raise ArgumentError.new("Required argument 'index' and 'type' missing")
          end
          method = "DELETE"
          path   = Utils.__pathify Utils.__listify(arguments[:index].as(String)), Utils.__escape(arguments[:type].as(String))
          params = {} of String => String
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
