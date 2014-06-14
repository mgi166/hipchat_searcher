class HipchatSearcher
  class Config
    attr_reader :token
    def initialize
      print_not_exist! unless File.exist?(config_path)
      @token = File.read(config_path).chomp
    end

    def valid?
      !!@token
    end

    def print_not_exist
      puts <<-EOS
Config file is not exsited.

* To create config file, run this command
`echo {auth_token} > ~/.hps`

* To get new auth_token, visit and sign in.
https://www.hipchat.com/
      EOS
    end

    def print_not_exist!
      print_not_exist
      exit 1
    end

    def config_path
      File.expand_path(File.join('.', '.hps'))
    end
  end
end
