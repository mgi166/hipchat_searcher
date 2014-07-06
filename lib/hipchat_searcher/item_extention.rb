module HipchatSearcher
  module ItemExtention
    attr_accessor :pattern

    def contents
      "%s\n%s\n\n" % [_date, _message]
    end

    def mention_name
      self.from.mention_name rescue self.from
    end

    def _date
      "  Date: %s" % self.date
    end

    def _message
      msg = self.message.gsub(pattern) do |matched|
        matched.colorize(:red)
      end

      "  @%s: %s" % [mention_name, msg]
    end
  end
end
