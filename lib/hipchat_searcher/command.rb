class HipchatSearcher
  class Command
    def initialize(pattern, options)
      @pattern = pattern
      @options = options
      @config  = Config.new
    end

    def run
      rooms = if @options.room?
                @options.room
              else
                room = Room.new(@config.token, @options)
                room.names
              end

      message  = Message.new(@config.token, @options)

      rooms.inject([]) do |result, room|
        hist = message.history(room)
        Searcher.search(@pattern, hist)
      end
    end
  end
end
