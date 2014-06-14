require 'hashie/mash'

class HipchatSearcher
  class Options < Hashie::Mash
    def room?
      !!self['r'] || !!self['room']
    end
  end
end
