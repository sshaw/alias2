module Alias2
  VERSION = "0.0.1".freeze

  class << self
    def alias(namespace, aliases)
      namespace = constant(namespace)
      aliases = namespace.constants if aliases == "*".freeze

      if aliases.is_a?(String)
        set(namespace, aliases)
      else
        aliases.each { |target, alias_as| set(namespace.const_get(target), alias_as || target) }
      end
    end

    private

    def constant(namespace)
      return namespace if namespace.is_a?(Module)
      # "A::B::C" will only work with later version of Ruby. Check which ones!
      Object.const_get(namespace)
    end

    def set(target, alias_as)
      Object.const_set(alias_as, target)
    end

  end
end

def alias2(target, alias_as)
  Alias2.alias(target, alias_as)
end
