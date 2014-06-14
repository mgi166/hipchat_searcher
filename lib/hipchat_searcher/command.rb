class HipchatSearcher
  class Command
    def initialize
      @config  = Config.new
      @options = Options.new
    end

    def run
      rooms = if @options.room?
                @options.room
              else
                room = Room.new(@config.token, @options.option)
                room.names
              end

      message  = Message.new(@config.token, @options.option)

      rooms.inject([]) do |result, room|
        hist = message.history(room)
        Searcher.search(pattern, hist)
      end
    end
  end
end
