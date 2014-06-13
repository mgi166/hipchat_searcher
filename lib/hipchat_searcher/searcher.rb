class HipchatSearcher
  class Searcher
    def initialize(result)
      @result = result
    end

    def search(pattern)
      pattern = Regexp.new(pattern)
      @result.messages.grep(pattern)
    end
  end
end
