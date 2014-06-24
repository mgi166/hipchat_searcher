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

    def help?
      !!self['h'] || !!self['help']
    end

    def message_options
      date? ? { date: date } : {}
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
      user? ? { user: user } : {}
    end

    class << self
      def short_names
        'a:d:h:r:u:'
      end

      def long_names
        ['room' 'user', 'date', 'archived', 'help']
      end

      def help
        <<-EOS
Usage: hps [searchword] [options]

  -r, --room : Search only the log of the room that you specified
  -r, --user : Search only the log that specified user talk
  -a, --archived : Include in the search of the room that have been archived
  -d, --date : Search the log since specified date

  -h, --help : Show this message
        EOS
      end
    end
  end
end
