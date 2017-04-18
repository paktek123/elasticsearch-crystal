module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Script ID (*Required*)
      # @option arguments [String] :lang Script language (*Required*)
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-scripting.html#_indexed_scripts
      #
      def get_script(arguments={} of Symbol => String)
        if !arguments.has_key?(:id) || !arguments.has_key?(:lang)
          raise ArgumentError.new("Required argument 'id' or 'lang' missing")
        end
        method = "GET"
        path   = "_scripts/#{arguments[:lang]}/#{arguments[:id]}"
        params = {} of String => String
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
