require 'hipchat'

class HipchatSearcher
  class Message
    def initialize(token, options={})
      @token   = token
      @options = options
      @client  = ::HipChat::Client.new(@token, api_version: 'v2')
    end

    def get_history(room)
      @client[room].history(@options)
    end

    def histroy(room)
      h = get_history(room)
      Result.new(h).tap {|r| r.room = room }
    end
  end
end
