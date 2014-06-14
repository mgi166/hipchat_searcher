class HipchatSearcher
  class Searcher
    def initialize(result)
      @result = result
    end

    def self.search(pattern, result)
      new(result).search(pattern)
    end

    def search(pattern)
      pattern = Regexp.new(pattern)
      @result.messages.grep(pattern)
    end
  end
end
