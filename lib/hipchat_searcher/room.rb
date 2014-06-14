require 'hipchat'
require 'httparty'

class HipchatSearcher
  class Room
    include HTTParty

    def initialize(token, options={})
      @token = token
      default_options = { api_version: 'v2', server_url: 'https://api.hipchat.com' }
      @option = default_options.merge(options)
      @api = ::HipChat::ApiVersion::Room.new(@option)
      self.class.base_uri(@api.base_uri)
    end

    def get_all_room
      response = self.class.get(
        '',
        query: {auth_token: @token},
        header: @api.headers
      )

      case response.code
      when 200
        response.parsed_response
      when 404
        raise ::HipChat::UnknownRoom, 'Unknown room'
      when 401
        raise ::HipChat::Unauthorized, 'Access denied to room'
      else
        raise ::HipChat::UnknownResponseCode, "Unexpected #{response.code} for room"
      end
    end

    def names
      result = Result.new(get_all_room)
      result.room_list
    end
  end
end
