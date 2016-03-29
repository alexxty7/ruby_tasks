class Module
  def attribute attr, &block
    
    attr, default = attr.to_a.first if attr.is_a?(Hash)

    define_method "#{attr}=" do |value|
      instance_variable_set("@#{attr}", value)
    end

    define_method attr do
      if instance_variable_defined?("@#{attr}")
        instance_variable_get("@#{attr}")
      else
        default ||= instance_eval(&block)
        instance_variable_set("@#{attr}", default)
      end
    end

    define_method "#{attr}?" do 
      !instance_variable_get("@#{attr}").nil?
    end
  end
end
