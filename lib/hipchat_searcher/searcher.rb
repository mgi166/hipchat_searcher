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

    def puts_search_result(pattern, item)
      msg = item.message.gsub(pattern) do |matched|
        matched.underline
      end

      date = "  Date: #{item.date}"
      name = item.from.mention_name rescue item.from
      msg  = "  @#{name}" + ': ' + msg

      if option_user?
        if @options[:user] == name
          print_room? ? nil : puts_room
          puts "%s\n%s\n\n" % [date, msg]
        else
          nil
        end
      else
        print_room? ? nil : puts_room
        puts "%s\n%s\n\n" % [date, msg]
      end
    end

    def search(pattern)
      pattern = Regexp.new(pattern)

      @result.items.each do |item|
        if pattern =~ item.message
          puts_search_result(pattern, item)
        end
      end

      nil
    end

    private

    def option_user?
      !!@options[:user]
    end

    def print_room?
      !!@print_room
    end

    def puts_room
      @print_room = true
      puts room
    end

    def room
      @result.room
    end
  end
end
