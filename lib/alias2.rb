# frozen_string_literal: true

module Alias2
  VERSION = "0.1.0".freeze

  class << self
    def alias(namespace, aliases = nil)
      raise ArgumentError, "you must provide an alias or a block" if aliases.nil? && !block_given?

      namespace = constant(namespace)
      aliases = find_names(namespace) if aliases.nil? || aliases == "*"

      if aliases.is_a?(String)
        set(namespace, aliases)
        return
      end

      aliases.each do |target, alias_as|
        klass = namespace.const_get(target)
        if block_given?
          keep_or_alias = yield klass
          next unless keep_or_alias
          # Block returned a new alias
          alias_as = keep_or_alias if keep_or_alias != true
        end

        set(klass, (alias_as || target).to_s)
      end

      nil
    end

    private

    def constant(namespace)
      return namespace if namespace.is_a?(Module)
      Object.const_get(namespace)
    end

    def find_names(namespace)
      names = []
      namespace.constants.each do |name|
        const = namespace.const_get(name)
        names << name if const.is_a?(Module)
      end

      names
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
  def alias2(target, alias_as = nil, &block)
    Alias2.alias(target, alias_as, &block)
  end
end
