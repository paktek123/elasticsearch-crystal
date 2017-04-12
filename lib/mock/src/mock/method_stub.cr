module Mock
  class MethodStub
    getter :method_name, :arguments, :value

    def initialize(@method_name)
    end

    def with(arguments : Arguments)
      @arguments = arguments
      self
    end

    def with(*args)
      @arguments = if args.empty?
        Arguments.empty
      else
        Arguments.new(args)
      end

      self
    end

    def and_return(@value)
      self
    end
  end

  class MethodStubCollection
    def initialize
      @stubs = [] of MethodStub
    end

    delegate :<<, @stubs

    def each
      @stubs.each { |s| yield s }
    end

    def find(stub : MethodStub)
      find(stub.method_name, stub.arguments)
    end

    def find(method_name, arguments)
      @stubs.find do |stub|
        method_name == stub.method_name && (stub.arguments.nil? || arguments.nil? || arguments == stub.arguments)
      end
    end
  end
end
