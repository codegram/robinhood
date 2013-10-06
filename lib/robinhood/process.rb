require 'celluloid'
require 'benchmark'
require 'robinhood/mutex'

module Robinhood
  # This class wraps a previously defined process. It's responsible to prevent
  # the same process to be run at the sime time on different System Processes.
  #
  # A Process leverages a Celluloid Actor, so it will spawned in a different
  # thread and communicate with the rest of the system with messages.
  class Process
    attr_reader :name, :options

    include Celluloid
    include Celluloid::Logger

    finalizer :unlock

    # Public: Initializes a Process
    #
    # name    - A String that will be used as a global identifier. It's
    #           important that it is unique, since the locking will be
    #           performed this name as scope.
    # options - A Hash of options that configure this Process.
    #           :throttle - An Integer that represents the minimum number of
    #                       seconds that this process will take. In other
    #                       words, if its execution takes less than that, we'll
    #                       wait a little bit until it hits the next execution.
    #           :timeout  - An Integer representing the period of time after
    #                       which this process' execution will be considered as
    #                       'hung' and another execution will take place.
    # block   - The block that will be evaluated each time this Process gets
    #           executed.
    def initialize(name, options, block)
      @name = name
      @options = options
      @block = block
      async.run
    end

    private

    def run
      return unless lock

      begin
        time = Benchmark.realtime{ instance_eval(&@block) }
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
      @mutex ||= Mutex.new(lock_name, block: 1, sleep: 0.1, expire: timeout)
    end
  end
end
