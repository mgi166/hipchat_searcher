class HipchatSearcher
  class Command
    def initialize
      @config  = Config.new
    end

    def run
      rooms = if @config.has_room?
                @config.room
              else
                room = Room.new(@config.token, @config.option)
                room.names
              end

      message  = Message.new(@config.token, @config.option)

      rooms.inject([]) do |result, room|
        hist = message.history(room)
        Searcher.search(pattern, hist)
      end
    end
  end
end
