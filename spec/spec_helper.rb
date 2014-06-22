require 'coveralls'
Coveralls.wear!

require 'hipchat_searcher'

RSpec.configure do |config|
  config.order = :random
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
