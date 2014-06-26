require 'hashie/mash'

module HipchatSearcher
  class Options < Hashie::Mash
    def message_options
      date? ? { date: date } : {}
    end

    def room_options
      archived? ? { 'include-archived' => true } : {}
    end

    def search_options
      user? ? { user: user } : {}
    end

    class << self

      # [shortname, longname, description]
      def with_value
        [
         ['r=', 'room=',           'Search only the log of the room that you specified'],
         ['u=', 'user=',           'Search only the log that specified user talk'],
         ['d=', 'date=',           'Search the log since specified date'],
         ['A=', 'after_context=',  'Search the log that trails context after each match'],
         ['B=', 'before_context=', 'Search the log that trails context before each match'],
         ['C=', 'context=',        'Search the log that trails context surround each match'],
        ]
      end

      # [shortname, longname, description]
      def with_boolean
        [
         ['a', 'archived', 'Include in the search of the room that have been archived']
        ]
      end
    end
  end
end
