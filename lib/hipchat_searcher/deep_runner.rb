module HipchatSearcher
  class DeepRunner < Runner
    def run
      result = @message.history(@room)
      i = 1
      while result.continue?
        if i == 1
          i += 1
          search(result)
        else
          option = { date: result.oldest_date }
          result = @message.history(@room, option)
          search(result)
        end
      end
    end
  end
end