module HipchatSearcher
  class Command
    def initialize(pattern, options)
      @pattern = pattern
      @options = options
      @options.config = Config.new

      config_valid!
    end

    def self.run(pattern, options)
      new(pattern, options).run
    end

    def run
      if @options.deep?
        deep_run
      else
        simple_run
      end
    end

    def deep_run
      rooms.each do |room|
        DeepRunner.run(@pattern, room, @options)
      end
    end

    def simple_run
      rooms.each do |room|
        Runner.run(@pattern, room, @options)
      end
    end

    private

    def all_room
      Room.new(@options.config.token, @options.room_options).all_room
    end

    def rooms
      if @options.room?
        room_names = @options.room.split(',')
        all_room.select do |r|
          room_names.include?(r.name)
        end
      else
        all_room
      end
    end
  end
end
