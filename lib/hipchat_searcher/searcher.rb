class HipchatSearcher
  class Searcher
    SEPARATOR = '|%*%|'

    def initialize(result)
      @result = result
    end

    def search(pattern)
      pattern = Regexp.new(pattern)
    end

    def join
    end

    def pattern
    end
  end
end
