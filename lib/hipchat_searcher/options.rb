require 'hashie/mash'

module HipchatSearcher
  class Options < Hashie::Mash
    def deep?
      !!self['deep'] || !!self['date']
    end

    def message_options
      {}
    end

    def room_options
      archived? ? { 'include-archived' => true } : {}
    end

    def search_options
      {}.tap do |o|
        o.merge!(user: user)                     if user?
        o.merge!(after_context:  after_context)  if after_context?
        o.merge!(before_context: before_context) if before_context?
        o.merge!(context: context)               if context?
        o.merge!(date: date)                     if date?
      end
    end

    def grep_options?
      !!before_context || !!after_context || !!context
    end

    class << self

      # [shortname, longname, description]
      def with_value
        [
         ['r=', 'room=',           'Search only the log of the room that you specified'],
         ['u=', 'user=',           'Search only the log that specified user talk'],
         ['d=', 'date=',           'Search the log until the day of latest from the date you specified'],
         ['A=', 'after_context=',  'Search the log that trails context after each match'],
         ['B=', 'before_context=', 'Search the log that trails context before each match'],
         ['C=', 'context=',        'Search the log that trails context surround each match'],
        ]
      end

      # [shortname, longname, description]
      def with_boolean
        [
         ['a', 'archived', 'Include in the search of the room that have been archived'],
         ['e', 'deep',     'Search older than comment of 75 recently']
        ]
      end
    end
  end
end
