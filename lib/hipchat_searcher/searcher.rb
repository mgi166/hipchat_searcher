require 'colorize'

module HipchatSearcher
  class Searcher
    def initialize(pattern, result, options={})
      @result     = result
      @options    = options
      @pattern    = Regexp.new(pattern)
      @print_room = false
      @print_item = {}
    end

    def self.search(pattern, result, options)
      new(pattern, result, options).search
    end

    def extended_items(index)
      items[range(index)].map do |itm|
        itm.extend(ItemExtention).tap do |i|
          i.pattern = @pattern
        end
      end
    end

    def items
      @items ||= @result.items
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
        next unless @pattern =~ item.message

        if option_search?
          extended_items(idx).each do |itm|
            puts_search_result(itm)
          end
        else
          ext = item.extend(ItemExtention)
          ext.pattern = @pattern
          puts_search_result(ext)
        end
      end

      nil
    end

    private

    def option_after?
      !!@options[:after_context]
    end

    def option_before?
      !!@options[:before_context]
    end

    def option_context?
      !!@options[:context]
    end

    def option_search?
      option_after? || option_before? || option_context?
    end

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
      puts item.contents unless print_item?(item.id)
    end

    def range(index)
      case
      when option_before?
        _i = index - @options[:before_context].to_i
        Range.new(_i, index)
      when option_after?
        _i = index + @options[:after_context].to_i
        Range.new(index, _i)
      when option_context?
        _i = index - @options[:context].to_i
        _j = index + @options[:context].to_i
        Range.new(_i, _j)
      end
    end

    def room
      @result.room
    end

    def print_item?(id)
      if @print_item.key?(id)
        true
      else
        @print_item[id] = 1
        false
      end
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
