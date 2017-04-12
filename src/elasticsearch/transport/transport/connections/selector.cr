module Elasticsearch
  module Transport
    module Transport
      module Connections
        module Selector

          # @abstract Common functionality for connection selector implementations.
          #
          module Base
            getter :connections

            # @option arguments [Connections::Collection] :connections Collection with connections.
            #
            def initialize(arguments={} of Symbol => Char)
              @connections = arguments[:connections]
            end

            # @abstract Selector strategies implement this method to
            #           select and return a connection from the pool.
            #
            # @return [Connection]
            #
            def select(options={} of Char => Char)
              raise NoMethodError, "Implement this method in the selector implementation."
            end
          end

          # "Random connection" selector strategy.
          #
          class Random
            include Base

            # Returns a random connection from the collection.
            #
            # @return [Connections::Connection]
            #
            def select(options={} of Char => Char)
              connections.to_a.send( defined?(RUBY_VERSION) && RUBY_VERSION > '1.9' ? :sample : :choice)
            end
          end

          # "Round-robin" selector strategy (default).
          #
          class RoundRobin
            include Base

            # Returns the next connection from the collection, rotating them in round-robin fashion.
            #
            # @return [Connections::Connection]
            #
            def select(options={} of Char => Char)
              # On Ruby 1.9, Array#rotate could be used instead
              @current = !defined?(@current) || @current.nil? ? 0 : @current+1
              @current = 0 if @current >= connections.size
              connections[@current]
            end
          end

        end
      end
    end
  end
end
