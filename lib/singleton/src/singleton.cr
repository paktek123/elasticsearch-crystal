class Singleton
  abstract class Producer
    abstract def produce
  end

  class GenericProducer(T) < Producer
    getter produce : T
    def initialize(@produce) end
  end

  @@instances = {} of String => Producer

  def self.reset
    @@instances.clear
  end

  def self.instances
    @@instances
  end

  class Of(T)
    def self.instance : T
      unless Singleton.instances.has_key?(T.name)
        Singleton.instances[T.name] = GenericProducer(T).new(T.new)
      end

      Singleton.instances[T.name].produce.as(T)
    end
  end
end
