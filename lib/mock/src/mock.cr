require "./mock/*"

module Mock
  class UnexpectedCall < Exception
  end

  alias DoublesRegistry = Array(Mock::Double)

  @@registry = DoublesRegistry.new

  def self.register(double)
    @@registry << double
  end

  def self.reset
    @@registry.clear
  end

  def self.registry
    @@registry
  end
end

module Spec::DSL
  def double(*args)
    Mock::Double.new(*args)
  end

  def it(description, file = __FILE__, line = __LINE__)
    Mock.reset
    previous_def
    Mock.registry.each &.check_expectations
  end
end
