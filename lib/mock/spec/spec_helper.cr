require "spec"
require "../src/mock"

class MyClass
  def a_method
    "result"
  end
end

class MyOtherClass
  def a_method_with_arguments(argument)
    argument.a_method
  end

  def a_method_with_restricted_arguments(argument : MyClass)
    argument.a_method
  end
end
