module HipchatSearcher
  class Command
    def initialize(pattern, options)
      @pattern = pattern
      @options = options
      @config  = Config.new
    end

    def self.run(pattern, options)
      new(pattern, options).run
    end

    def run
      rooms = if @options.room?
                [@options.room]
              else
                room = Room.new(@config.token, @options.room_options)
                room.room
              end

      message = Message.new(@config.token, @options.message_options)

      rooms.inject([]) do |result, room|
        hist = message.history(room)
        Searcher.search(@pattern, hist, @options.search_options)
      end
    end
  end
end
