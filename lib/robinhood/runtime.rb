require "celluloid"
require "robinhood/process"
require 'robinhood/mutex'

module Robinhood
  # A Runtime is responsible of kickstarting a Robinhood's execution, spawning
  # all the processes and configuring the environment.
  class Runtime
    attr_accessor :redis

    # Public: Initializes a Runtime.
    def initialize
      @processes = []
    end

    # Public: Schedules a process to be run in this Runtime.
    #
    # name    - A String identifying this process.
    # options - A Hash of options that will be passed to the underlying
    #           Process.
    # block   - The block that will be evaluated in this Process.
    #
    # Returns nil.
    def add_process(name, options, block)
      @processes << [name, options, block]
      nil
    end

    # Public: Starts the Runtime.
    #
    # options - A hash of options to configure this Runtime's execution.
    #           (default: {background: false})
    #           :background - True if it runs on the background (doesn't block
    #                         the main thread), False otherwise.
    #
    # Returns the Runtime.
    def run(options = {})
      Celluloid.start

      setup_supervision_group
      Robinhood::Mutex.redis = redis

      Robinhood.log :info, "Starting Robin Hood: Robbing from the rich and giving to the poor.."

      @actor = options[:background] ? supervision_group.run! : supervision_group.run
      self
    end

    # Public: Stops this Runtime.
    #
    # Returns nil.
    def stop
      @actor.finalize if @actor
      nil
    end

    private

    def redis
      @redis ||= Redis.new
    end

    def supervision_group
      @supervision_group ||= Class.new(Celluloid::SupervisionGroup)
    end

    def setup_supervision_group
      @processes.each do |process|
        name, options, block = process

        supervision_group.supervise Process,
          as: "robinhood_#{name}",
          args: [name, options, block]
      end

      @processes = []
    end
  end
end
