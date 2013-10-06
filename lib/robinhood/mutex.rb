require 'redis-mutex'

Redis::Classy.db ||= Redis.new

module Robinhood
  class Mutex < Redis::Mutex; end;
end
