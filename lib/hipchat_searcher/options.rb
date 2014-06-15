require 'hashie/mash'

class HipchatSearcher
  class Options < Hashie::Mash
    def room?
      !!self['r'] || !!self['room']
    end

    def user?
      !!self['u'] || !!self['user']
    end

    def date?
      !!self['d'] || !!self['date']
    end

    class << self
      def short_names
        'fhruABC'
      end

      def long_names
        ['room' 'user', 'from', 'help']
      end

      def room
        self['r'] || self['room']
      end

      def user
        self['u'] || self['user']
      end

      def date
        self['d'] || self['date']
      end
    end
  end
end
