require 'colorize'
require 'date'
require 'forwardable'

module HipchatSearcher
  class SearchProxy
    class Grep
      extend Forwardable

      def initialize(pattern, result, options={})
        @simple     = Simple.new(pattern, result, options)
        @options    = options
        @print_room = false
        @print_item = {}
      end

      def_delegators :@simple, :before?, :items, :option_user?, :option_date?, :option_date, :pattern, :print_room?, :puts_room, :room

      def self.search(pattern, result, options)
        new(pattern, result, options).search
      end

      def around_items(index)
        items[range(index)].map do |itm|
          itm.extend(HipchatSearcher::ItemExtention).tap do |i|
            i.pattern = pattern
          end
        end
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
          if before?(item.date)
            @options[:end] = true
            break
          end

          if pattern =~ item.message
            around_items(idx).each do |itm|
              puts_search_result(itm)
            end
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

      def printed?(id)
        if @print_item.key?(id)
          true
        else
          @print_item[id] = 1
          false
        end
      end

      def range(index)
        param = []

        case
        when option_before?
          _i = index - @options[:before_context].to_i
          param = _i < 0 ? [0, index] : [_i, index]
        when option_after?
          _i = index + @options[:after_context].to_i
          param = [index, _i]
        when option_context?
          _i = index - @options[:context].to_i
          _j = index + @options[:context].to_i
          param = _i < 0 ? [0, _j] : [_i, _j]
        end

        Range.new(*param)
      end

      def puts_contents(item)
        print_room? ? nil : puts_room
        puts item.contents unless printed?(item.id)
      end
    end
  end
end
