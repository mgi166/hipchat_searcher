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
      search_proxy.search(@pattern, result, @options.search_options)
    end

    private

    def search_proxy
      if @options.grep_options?
        SearchProxy.new('grep')
      else
        SearchProxy.new('simple')
      end
    end
  end
end
