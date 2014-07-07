require 'hipchat'

module HipchatSearcher
  class Message
    def initialize(token, options={})
      @token   = token
      @options = options
      @client  = ::HipChat::Client.new(@token, api_version: 'v2')
    end

    def get_history(id, options)
      option = @options.merge(options)
      @client[id].history(option)
    end

    def history(room, options={})
      id        = room.id   rescue room
      room_name = room.name rescue room

      h = get_history(id, options)
      Result.new(h).tap {|r| r.room = room_name }
    end
  end
end
