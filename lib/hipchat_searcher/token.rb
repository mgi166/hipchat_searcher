module HipchatSearcher
  class Token
    attr_reader :token

    def self.token
      new.token
    end

    def initialize
      print_not_exist! unless ENV['HPS_HIPCHAT_TOKEN']
      @token = ENV['HPS_HIPCHAT_TOKEN']
    end

    def print_not_exist!
      puts <<-EOS
`HPS_HIPCHAT_TOKEN` is not exsited.

* Set environment variable HPS_HIPCHAT_TOKEN
`export HPS_HIPCHAT_TOKEN={auth_token}`

* To get new auth_token, visit and sign in.
https://www.hipchat.com/
      EOS

      exit 1
    end
  end
end
