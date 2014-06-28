require 'colorize'

module HipchatSearcher
  class Searcher
    def initialize(pattern, result, options={})
      @result     = result
      @options    = options
      @pattern    = Regexp.new(pattern)
      @print_room = false
    end

    def self.search(pattern, result, options)
      new(pattern, result, options).search
    end

    def puts_search_result(item)
      if option_user?
        if @options[:user] == item.mention_name
          puts_contents(item.contents)
        end
      else
        puts_contents(item.contents)
      end
    end

    def search
      @result.items.each do |item|
        if @pattern =~ item.message
          ext = item.extend(ItemExtention)
          ext.pattern = @pattern
          puts_search_result(ext)
        end
      end

      nil
    end

    private

    def option_user?
      !!@options[:user]
    end

    def option_after?
      !!@options[:after_context]
    end

    def option_before?
      !!@options[:before_context]
    end

    def option_context?
      !!@options[:context]
    end

    def print_room?
      !!@print_room
    end

    def puts_room
      @print_room = true
      puts room.underline
    end

    def puts_contents(contents)
      print_room? ? nil : puts_room
      puts contents
    end

    def room
      @result.room
    end

    module ItemExtention
      attr_accessor :pattern

      def contents
        "%s\n%s\n\n" % [_date, _message]
      end

      def mention_name
        self.from.mention_name rescue self.from
      end

      def _date
        "  Date: %s" % self.date
      end

      def _message
        msg = self.message.gsub(pattern) do |matched|
          matched.colorize(:red)
        end

        "  @%s: %s" % [mention_name, msg]
      end
    end
  end
end
