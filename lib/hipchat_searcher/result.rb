require 'json'

class HipchatSearcher
  class Result
    class InvalidResponse < StandardError; end

    def initialize(response)
      @response = response
    end

    def room_list
      @response['items'].map { |item| item['name'] }
    end

    def message_list
      JSON.parse(@response)['items'].map{|i| i['message']}
    end

    def valid!
      if @response.to_s.empty? || !@response.has_key?('items')
        raise InvalidResponse, "`#{@response}' is invalid response as hipchat"
      end
    end
  end
end
