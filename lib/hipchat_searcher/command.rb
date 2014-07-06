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
      all_room = Room.new(@config.token, @options.room_options).all_room

      rooms = if @options.room?
                room_names = @options.room.split(',')
                all_room.select do |r|
                  room_names.include?(r.name)
                end
              else
                all_room
              end

      rooms.each do |room|
        Runner.run(@pattern, room, @config, @options)
      end
    end
  end
end
