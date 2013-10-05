require "pry"
require "pry-nav"

RSpec.configure do |config|
  config.color = true

  unless ENV["TRAVIS"]
    config.formatter = :documentation
  end

  config.before(:each) do
    Celluloid.logger = nil
    redis = Redis.new
    redis.flushdb
  end

  config.after(:each) do
    Robinhood.reset!
  end
end
