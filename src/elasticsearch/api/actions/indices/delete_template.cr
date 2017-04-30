module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete an index template.
        #
        # @example Delete a template named _mytemplate_
        #
        #     client.indices.delete_template name: 'mytemplate'
        #
        # @example Delete all templates
        #
        #     client.indices.delete_template name: '*'
        #
        # @option arguments [String] :name The name of the template (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-templates/
        #
        def delete_template(arguments={} of Symbol => String)
          if !arguments.has_key?(:name)
            raise ArgumentError.new("Required argument 'name' missing")
          end
          valid_params = [ :timeout ]

          method = "DELETE"
          path   = Utils.__pathify "_template", Utils.__escape(arguments[:name].as(String))

          #params = Utils.__validate_and_extract_params arguments, valid_params
          body = nil

          perform_request(method, path, {} of String => String, body).body
        end
      end
    end
  end
end
