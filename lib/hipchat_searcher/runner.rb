module HipchatSearcher
  class Runner
    def initialize(pattern, room, options)
      @pattern = pattern
      @room    = room
      @options = options
      @message = Message.new(@options.config.token, @options.message_options)
    end

    def self.run(pattern, room, options)
      new(pattern, room, options).run
    end

    def run
      result = @message.history(@room)
      search(result)
    end

    def search(result)
      Searcher.search(@pattern, result, @options.search_options)
    end
  end
end
