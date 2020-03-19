# typed: true

require_relative "typechecker"

# define your classes here
class A
  extend T::Sig

  sig { returns(T.nilable(String)) }
  def foo
    message = [false,true].sample ? "I return half the time a string" : nil
    return message
  end
end

class B < A
  sig { returns(String) }
  def foo
    "I always return a string"
  end
end

# run your code here
Typechecker.run_checks_on do
  puts A.new.foo
  puts B.new.foo
end