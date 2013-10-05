require 'celluloid'
require 'redis-mutex'
require 'benchmark'

module Robinhood
  class Process
    attr_reader :name, :options

    include Celluloid
    include Celluloid::Logger

    def initialize(name, options, block)
      @name = name
      @options = options
      @block = block
      async.run
    end

    def run
      mutex.lock

      time = Benchmark.realtime{ @block.call }

      if difference = throttle - time
        sleep(difference)
      end
    ensure
      mutex.unlock
      async.run
    end

    def lock_name
      "robinhood:#{name}:lock"
    end

    def throttle
      if (throttle = options[:throttle]) != nil
        throttle
      else
        0.1
      end
    end

    def mutex
      @mutex ||= Redis::Mutex.new(lock_name, block: 1, sleep: 0.1, expire: 300)
    end
  end
end
