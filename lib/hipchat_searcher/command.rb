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
      room = Room.new(@config.token, @options.room_options)

      rooms = if @options.room?
                room_names = @options.room.split(',')
                room.room.select do |r|
                  room_names.include?(r.name)
                end
              else
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
