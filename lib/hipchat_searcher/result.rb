require 'json'

class HipchatSearcher
  class Result
    def initialize(response)
      @response = response
    end

    def room_list
      @response['items'].map { |item| item['name'] }
    end

    def message_list
    end
  end
end
