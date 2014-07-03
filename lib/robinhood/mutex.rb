require 'redis-semaphore'

module Robinhood
  class Mutex
    def initialize(name)
      @name = name
    end

    def lock
      semaphore.lock
    end

    def unlock
      semaphore.unlock
    end

    private

    def semaphore
      @semaphore ||= Redis::Semaphore.new(@name,
                                          redis: self.class.redis,
                                          stale_client_timeout: self.class.lock_timeout)
    end

    class << self
      attr_writer :redis, :lock_timeout

      def redis
        @redis ||= Redis.new
      end

      def lock_timeout
        @lock_timeout ||= 3600
      end
    end
  end
end
