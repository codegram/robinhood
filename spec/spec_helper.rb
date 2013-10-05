require "pry"
require "pry-nav"

RSpec.configure do |config|
  config.color = true

  unless ENV["TRAVIS"]
    config.formatter = :documentation
  end

  config.before(:all) do
    Celluloid.logger = nil
  end

  config.before(:each) do
    Robinhood.reset!
    Redis.new.flushdb
  end
end
