require 'json'

class HipchatSearcher
  class Result
    def initialize(response)
      @response = response
    end

    def room_list
      JSON.parse(@response)
    end
  end
end
