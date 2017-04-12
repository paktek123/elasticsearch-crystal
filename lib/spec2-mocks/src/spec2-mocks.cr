require "spec2"
require "mocks"

module ::Spec2::Mocks
  class Expectation(T)
    def initialize(@actual : T, @delayed : Array(->)?)
      @negative = false
    end

    def to(m : ::Spec2::Matcher)
      ::Spec2::Expectation.new(@actual).to m
    end

    def not_to(m : ::Spec2::Matcher)
      ::Spec2::Expectation.new(@actual).not_to m
    end

    def to(m : ::Mocks::Message)
      ::Mocks::Allow.new(@actual).to m
      delayed_have_received(to, m.receive)
    end

    def to(m : ::Mocks::Receive)
      delayed_have_received(to, m)
    end

    def not_to(m : ::Mocks::Receive)
      delayed_have_received(not_to, m)
    end

    macro delayed_have_received(marker, matcher)
      @delayed.not_nil! << -> do
        ::Spec2::Expectation.new(@actual)
          .{{marker.id}} HaveReceived.new({{matcher}})
      end
    end
  end

  class HaveReceived(T)
    include ::Spec2::Matcher

    getter unwrap
    getter failure_message
    getter failure_message_when_negated

    def initialize(receive : ::Mocks::Receive(T))
      @unwrap = ::Mocks::HaveReceivedExpectation(T).new(receive)
      @failure_message = ""
      @failure_message_when_negated = ""
    end

    def match(value)
      result = unwrap.match(value)

      @failure_message = unwrap.failure_message(value)
      @failure_message_when_negated = unwrap.negative_failure_message(value)

      result
    end

    def description
      "(have received #{receive.method_name}#{receive.args.inspect})"
    end
  end
end

module ::Spec2::DSL
  macro expect(target)
    ::Spec2::Mocks::Expectation.new({{target}}, __spec2_delayed)
  end

  include ::Mocks::Macro::GlobalDSL

  macro have_received(method)
    ::Spec2::Mocks::HaveReceived.new(receive({{method}}))
  end
end

::Spec2::DSL.global_before do
  ::Mocks.reset
end
