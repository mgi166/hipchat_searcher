require 'hipchat'

class HipchatSearcher
  class Message
    def initialize(token, options={})
      @token   = token
      @options = options
      @client  = ::HipChat::Client.new(@token, api_version: 'v2')
    end

    def get_history(id)
      @client[id].history(@options)
    end

    def history(room)
      id        = room.id   rescue room
      room_name = room.name rescue room

      h = get_history(id)
      Result.new(h).tap {|r| r.room = room_name }
    end
  end
end
