module Mock
  class Double
    def initialize(@name = :double, stubs = nil)
      @stubs = MethodStubCollection.new
      @expectations = MethodStubCollection.new
      @negative_expectations = MethodStubCollection.new
      @calls = MethodStubCollection.new
      Mock.register self
      add_stubs(stubs) if stubs
    end

    private def add_stubs(stubs)
      stubs.each do |method_name, value|
        stub(method_name).and_return(value)
      end
    end

    def stub(method_name)
      MethodStub.new(method_name).tap do |stub|
        @stubs << stub
      end
    end

    def should_receive(method_name)
      stub(method_name).tap do |stub|
        @expectations << stub
      end
    end

    def should_not_receive(method_name)
      MethodStub.new(method_name).tap do |stub|
        @negative_expectations << stub
      end
    end

    def check_expectations
      @expectations.each do |expectation|
        @calls.should HaveCalledExpectation.new(expectation)
      end
      @negative_expectations.each do |expectation|
        @calls.should_not HaveCalledExpectation.new(expectation)
      end
    end

    macro method_missing(name, args, block)
      {% if args.empty? %}
        arguments = Arguments.empty
      {% else %}
        arguments = Arguments.new({{args}})
      {% end %}

      if stub = @stubs.find(:{{name}}, arguments)
        @calls << MethodStub.new(:{{name}}).with(arguments)
        stub.value
      else
        raise UnexpectedCall.new("Unexpected call to #{{{name}}} on double #{@name.inspect}")
      end
    end
  end

  class HaveCalledExpectation
    def initialize(@expectation)
    end

    def match(calls)
      calls.find(@expectation)
    end

    def failure_message
      "expected #{@expectation.method_name} to be called with arguments #{@expectation.arguments.to_s}, but wasn't"
    end

    def negative_failure_message
      "expected #{@expectation.method_name} to not be called with arguments #{@expectation.arguments.to_s}, but was"
    end
  end
end
