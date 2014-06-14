require 'json'

class HipchatSearcher
  class Result
    class InvalidResponse < StandardError; end

    attr_accessor :room

    def initialize(response)
      @response = response
      valid!
    end

    def parse_room_name
      @response['items'].map {|i| i['name'] }
    end

    def messages
      @messages = JSON.parse(@response)['items'].map {|i| i['message']}
    end

    def valid!
      case @response
      when String
        if @response.empty?
          raise InvalidResponse, "`#{@response}' is invalid response as hipchat. expect String size is over than 0"
        end
      when Hash
        if !@response.has_key?('items')
          raise InvalidResponse, "`#{@response}' is invalid response as hipchat. expect Hash key has 'items'"
        end
      else
        raise InvalidResponse, "`#{@response}' is invalid response as hipchat. expect String or Hash"
      end
    end
  end
end
