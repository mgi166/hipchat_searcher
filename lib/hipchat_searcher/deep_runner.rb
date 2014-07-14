module HipchatSearcher
  class DeepRunner < Runner
    def run
      result = @message.history(@room)
      i = 1
      while result.items.size == limit
        break if @options.end?

        if i == 1
          i += 1
          search(result)
        else
          option = { date: result.oldest_date }
          result = @message.history(@room, option)
          @limit_flag = true
          search(result)
        end
      end
    end

    private

    def limit
      @limit_flag ? 100 : 75
    end
  end
end
