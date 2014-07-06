module HipchatSearcher
  class SearchProxy
    def initialize(proxy)
      @proxy = proxy
    end

    def search(pattern, result, options)
      klass = self.class.const_get(@proxy.to_s.capitalize)
      klass.search(pattern, result, options)
    end
  end
end
