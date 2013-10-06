require 'celluloid'
require 'redis-mutex'
require 'benchmark'

module Robinhood
  class Process
    attr_reader :name, :options

    include Celluloid
    include Celluloid::Logger

    finalizer :unlock

    def initialize(name, options, block)
      @name = name
      @options = options
      @block = block
      async.run
    end

    def run
      return unless lock

      begin
        time = Benchmark.realtime{ @block.call }
        if difference = throttle - time
          sleep(difference)
        end
      ensure
        unlock
      end
    ensure
      async.run
    end

    def lock
      mutex.lock
    end

    def unlock
      mutex.unlock
    end

    def lock_name
      "robinhood:#{name}:lock"
    end

    def throttle
      if (throttle = options[:throttle]) != nil
        throttle
      else
        0.05
      end
    end

    def timeout
      options[:timeout] || 300
    end

    def mutex
      @mutex ||= Redis::Mutex.new(lock_name, block: 1, sleep: 0.1, expire: timeout)
    end
  end
end
