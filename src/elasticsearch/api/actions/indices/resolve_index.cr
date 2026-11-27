module Elasticsearch
  module API
    module Indices
      module Actions

        # Resolve the names and types of indices, aliases and data streams matching a name or wildcard expression
        #
        # @option arguments [String] :name Comma-separated names or wildcard expressions to resolve (*Required*)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expressions to concrete indices
        #                                              (options: open, closed, hidden, none, all)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-resolve-index-api.html
        #
        def resolve_index(arguments={} of Symbol => String)
          if !arguments.has_key?(:name)
            raise ArgumentError.new("Required argument 'name' missing")
          end

          valid_params = [
            :expand_wildcards
          ]

          name = arguments.delete(:name)

          method = "GET"
          path   = Utils.__pathify("_resolve", "index", Utils.__listify(name.as(String)))
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
