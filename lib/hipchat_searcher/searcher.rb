require 'colorize'

module HipchatSearcher
  class Searcher
    def initialize(result, options={})
      @result     = result
      @options    = options
      @print_room = false
    end

    def self.search(pattern, result, options)
      new(result, options).search(pattern)
    end

    def search(pattern)
      pattern = Regexp.new(pattern)

      @result.items.each do |item|
        if pattern =~ item.message
          @print_room ? nil : puts_room
          puts_search_result(pattern, item)
        end
      end

      nil
    end

    def room
      @result.room
    end

    def puts_room
      @print_room = true
      puts room
    end

    def puts_search_result(pattern, item)
      msg = item.message.gsub(pattern) do |matched|
        matched.underline
      end

      date = "  Date: #{item.date}"
      name = item.from.mention_name rescue item.from
      msg  = "  @#{name}" + ': ' + msg
      puts "%s\n%s\n\n" % [date, msg]
    end
  end
end
