module Alias2
  VERSION = "0.0.1".freeze

  class << self
    def alias(namespace, aliases)
      namespace = constant(namespace)
      if aliases.is_a?(String)
        set(namespace, aliases)
      else
        aliases.each { |target, alias_as| set(namespace.const_get(target), (alias_as || target).to_s) }
      end

      nil
    end

    private

    def constant(namespace)
      return namespace if namespace.is_a?(Module)
      Object.const_get(namespace)
    end

    # Stolen from class2: https://github.com/sshaw/class2
    def find_and_or_create_namespace(str)
      parts = str.split("::")
      namespace = parts[0..-2].inject(Object) do |parent, child|
        # empty? to handle "::Namespace"
        child.empty? ? parent : parent.const_defined?(child) ?
                                  # With 2.1 we can just say Object.const_defined?(str) but keep this around for now.
                                  parent.const_get(child) : parent.const_set(child, Module.new)
      end

      [ namespace, parts[-1] ]
    end

    def set(target, alias_as)
      namespace = Object

      if alias_as.include?("::")
        namespace, alias_as = find_and_or_create_namespace(alias_as)
      end

      if namespace.const_defined?(alias_as)
        const = namespace != Object ? "#{namespace}::#{alias_as}" : alias_as
        raise NameError, "constant #{const} is already defined"
      end

      namespace.const_set(alias_as, target)
    end
  end
end

unless %w[true 1].include?(ENV["ALIAS2_NO_EXPORT"])
  def alias2(target, alias_as)
    Alias2.alias(target, alias_as)
  end
end
