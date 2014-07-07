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
      rooms.each do |room|
        Runner.run(@pattern, room, @options)
      end
    end

    private

    def all_room
      Room.new(@options.config.token, @options.room_options).all_room
    end

    def config_valid!
      unless @options.config.valid?
        print_no_authorization_token
        exit 1
      end
    end

    def print_no_authorization_token
      puts <<-EOS
Authorization token required.

* To create config file, run this command
`echo {auth_token} > ~/.hps`

* To get new auth_token, visit and sign in.
https://www.hipchat.com/
      EOS
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
