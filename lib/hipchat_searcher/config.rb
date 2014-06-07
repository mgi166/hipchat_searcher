class HipchatSearcher
  class Config
    def initialize
      print_not_exist! if File.exist?(config_path)
      @config = File.read(config_path)
    end

    def valid?
    end

    def print_not_exist
      puts <<-EOS
Config file is not exsited.

* To create config file, run this command
`echo {auth_token} > .hps`

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
