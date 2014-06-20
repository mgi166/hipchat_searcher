require 'hashie/mash'

module HipchatSearcher
  class Options < Hashie::Mash
    def archived
      self['a'] || self['archived']
    end

    def archived?
      !!self['a'] || !!self['archived']
    end

    def date
      self['d'] || self['date']
    end

    def date?
      !!self['d'] || !!self['date']
    end

    def message_options
       date? ? { 'date' => date } : {}
    end

    def room_options
      archived? ? { 'include-archived' => true } : {}
    end

    def room
      self['r'] || self['room']
    end

    def room?
      !!self['r'] || !!self['room']
    end

    def user
      self['u'] || self['user']
    end

    def user?
      !!self['u'] || !!self['user']
    end

    def search_options
      user? ? { 'user' => user } : {}
    end

    class << self
      def short_names
        'f:h:r:u'
      end

      def long_names
        ['room' 'user', 'date', 'archived', 'help']
      end
    end
  end
end
