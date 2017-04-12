module Elasticsearch
  module Transport
    module Transport
      module HTTP

        # The default transport implementation, using the [_Cossack_](https://github.com/greyblake/crystal-cossack)
        # library for abstracting the HTTP client.
        #
        # @see Transport::Base
        #
        class Cossack
          include Base

          # Performs the request by invoking {Transport::Base#perform_request} with a block.
          #
          # @return [Response]
          # @see    Transport::Base#perform_request
          #
          def perform_request(method, path, params={} of Char => Char, body=nil)
            super do |connection, url|
              headers = connection.connection.headers

              response = connection.connection.run_request \
                method.downcase.to_sym,
                url,
                ( body ? __convert_to_json(body) : nil ),
                headers

              Response.new response.status, response.body, response.headers
            end
          end

          # Builds and returns a connection
          #
          # @return [Connections::Connection]
          #
          def __build_connection(host, options={} of Char => Char, block=nil)
            client = Cossack::Client.new(__full_url(host), options, &block)
            Connections::Connection.new :host => host, :connection => client
          end

          # Returns an array of implementation specific connection errors.
          #
          # @return [Array]
          #
          def host_unreachable_exceptions
            [Cossack::Error, Cossack::TimeoutError]
          end

          # Shameless ripoff of Faraday::Utils::ParamsHash
          # hash with stringified keys
          class ParamsHash < Hash
            def [](key)
              super(convert_key(key))
            end
      
            def []=(key, value)
              super(convert_key(key), value)
            end
      
            def delete(key)
              super(convert_key(key))
            end
      
            def include?(key)
              super(convert_key(key))
            end
      
            alias_method :has_key?, :include?
            alias_method :member?, :include?
            alias_method :key?, :include?
      
            def update(params)
              params.each do |key, value|
                self[key] = value
              end
              self
            end
            alias_method :merge!, :update
      
            def merge(params)
              dup.update(params)
            end
      
            def replace(other)
              clear
              update(other)
            end
      
            def merge_query(query, encoder = nil)
              if query && !query.empty?
                update((encoder || Utils.default_params_encoder).decode(query))
              end
              self
            end
      
            def to_query(encoder = nil)
              (encoder || Utils.default_params_encoder).encode(self)
            end

            private def convert_key(key)
              key.to_s
            end
          end
        end
      end
    end
  end
end
