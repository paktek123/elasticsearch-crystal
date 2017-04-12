module Elasticsearch
  module Transport
    module Transport
      module Serializer

        # An abstract class for implementing serializer implementations
        #
        module Base
          # @param transport [Object] The instance of transport which uses this serializer
          #
          def initialize(transport=nil)
            @transport = transport
          end
        end

        # A default JSON serializer (using [MultiJSON](http://rubygems.org/gems/multi_json))
        #
        class JSON
          include Base

          # De-serialize a Hash from JSON string
          #
          def load(string, options={} of Char => Char)
            JSON.parse(string)
          end

          # Serialize a Hash to JSON string
          #
          def dump(object, options={} of Char => Char)
            object.to_json
          end
        end
      end
    end
  end
end
