module Mock
  class Arguments
    def initialize(arguments)
      @arguments = arguments.to_a
    end

    def_equals @arguments

    def to_s
      @arguments.inspect
    end

    def self.empty
      Empty.new
    end

    class Empty < Arguments
      def initialize
      end

      def ==(other)
        false
      end

      def ==(other : Empty)
        true
      end
    end
  end
end
