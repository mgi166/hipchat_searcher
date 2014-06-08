require 'hipchat'

class HipchatSearcher
  class Message
    def initialize(token, room, options={})
      @token   = token
      @room    = room
      @options = options
      @client  = ::HipChat::Client.new(@token, api_version: 'v2')
    end

    def get_message
      @client[@room].history(@options)
    end
  end
end
