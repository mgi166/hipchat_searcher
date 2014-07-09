require 'colorize'

module HipchatSearcher
  class SearchProxy
    class Simple
      def initialize(pattern, result, options={})
        @result     = result
        @options    = options
        @pattern    = Regexp.new(pattern, Regexp::IGNORECASE)
      end

      attr_reader :pattern

      def self.search(pattern, result, options)
        new(pattern, result, options).search
      end

      def items
        @items ||= @result.items.reverse
      end

      def puts_search_result(item)
        if option_user?
          if @options[:user] == item.mention_name
            puts_contents(item)
          end
        else
          puts_contents(item)
        end
      end

      def search
        items.each_with_index do |item, idx|
          if @pattern =~ item.message
            ext = item.extend(HipchatSearcher::ItemExtention)
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

      def print_room?
        !!@print_room
      end

      def puts_room
        @print_room = true
        puts room.underline
      end

      def puts_contents(item)
        print_room? ? nil : puts_room
        puts item.contents
      end

      def room
        @result.room
      end
    end
  end
end
