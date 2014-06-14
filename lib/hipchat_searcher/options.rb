require 'hashie/mash'

class HipchatSearcher
  class Options < Hashie::Mash
    def room?
      !!self['r'] || !!self['room']
    end

    def user?
      !!self['u'] || !!self['user']
    end

    def from?
      !!self['f'] || !!self['from']
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

      def from
        self['f'] || self['from']
      end
    end
  end
end
