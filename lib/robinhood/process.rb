require 'celluloid'
require 'redis-mutex'

module Robinhood
  class Process
    attr_reader :name

    include Celluloid

    def initialize(name, options, block)
      @name = name
      @options = options
      @block = block
      async.run
    end

    def run
      Redis::Mutex.with_lock(lock_name) do
        @block.call
      end
      async.run
    end

    def lock_name
      "robinhood:#{name}:lock"
    end
  end
end
