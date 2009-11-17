# we have two ways of creating a class:
class A 
end
# the former is just syntatic sugar for the latter
B = Class.new

# we have do ways of defining class methods:

# the first two are the same as for any other object
def A.baz
  "baz!"
end
A.instance_eval do
   def frog
     "frog!"
   end
end

# the others are in the class context, which is slightly different
class A
  def self.marco
    "polo!"
  end
  # since A == self in here, this is the same as the last one.
  def A.red_light
    "green light!"
  end

  # unlike instance_eval, class context is special in that methods that
  # aren't attached to a specific object are taken as instance methods for instances
  # of the class
  def example
     "I'm an instance of A, not A itself"
  end
end
# class_eval opens up the class context in the same way
A.class_eval do
  def self.telegram
    "not a land shark"
  end
end

