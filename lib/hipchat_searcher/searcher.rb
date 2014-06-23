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
      contents = contents(pattern, item)
      if option_user?
        if @options[:user] == user_name(item)
          puts_contents(contents)
        end
      else
        puts_contents(contents)
      end
    end

    def search(pattern)
      pattern = Regexp.new(pattern, Regexp::IGNORECASE)

      @result.items.each do |item|
        if pattern =~ item.message
          puts_search_result(pattern, item)
        end
      end

      nil
    end

    private

    def contents(pattern, item)
      date    = date(item)
      message = message(pattern, item)

      "%s\n%s\n\n" % [date, message]
    end

    def date(item)
      "  Date: #{item.date}"
    end

    def message(pattern, item)
      msg = item.message.gsub(pattern) do |matched|
        matched.underline
      end

      name = user_name(item)
      "  @#{name}" + ': ' + msg
    end

    def user_name(item)
      item.from.mention_name rescue item.from
    end

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

    def puts_contents(contents)
      print_room? ? nil : puts_room
      puts contents
    end

    def room
      @result.room
    end
  end
end
