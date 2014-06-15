require 'colorize'

class HipchatSearcher
  class Searcher
    def initialize(result, options={})
      @result  = result
      @options = options
    end

    def self.search(pattern, result, options)
      new(result, options).search(pattern)
    end

    def search(pattern)
      pattern = Regexp.new(pattern)

      @result.messages.grep(pattern) do |matched|
        puts display(pattern, matched)
      end

      nil
    end

    def display(pattern, string)
      string.gsub(pattern) do |matched|
        matched.underline
      end
    end
  end
end
