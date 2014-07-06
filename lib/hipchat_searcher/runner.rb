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
      if @options.grep_options?
        proxy = SearchProxy.new('grep')
        proxy.search(@pattern, result, @options.search_options)
      else
        proxy = SearchProxy.new('simple')
        proxy.search(@pattern, result, @options.search_options)
      end
    end
  end
end
