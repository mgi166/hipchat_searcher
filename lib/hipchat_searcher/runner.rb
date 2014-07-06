module HipchatSearcher
  class Runner
    def initialize(pattern, room, config, options)
      @pattern = pattern
      @room    = room
      @message = Message.new(@config.token, @options.message_options)
      @options = options
    end

    def run
      result = @message.history(@room)
      Searcher.search(@pattern, result, @options.search_options)
    end
  end
end
