require "celluloid"
require 'logger'

module Robinhood
  # The DSL provides syntax suger on top of Robinhood's runtime. It allows us
  # to define processes in a natural language for the programmer's convenience.
  #
  class DSL
    # Public: Initializes the DSL.
    #
    # runtime - A runtime that will be configured using the DSL.
    def initialize(runtime)
      @runtime = runtime
    end

    # Public: Adds a process to the runtime.
    #
    # name    - The name of the process to be run. Will be used to identify the
    #           mutex name across System Processes.
    # options - A set of options that will be passed to the Process.
    # block   - A block that will be called each execution of this process.
    #
    # Returns nil.
    def process(name, options = {}, &block)
      @runtime.add_process(name, options, block)
      nil
    end

    # Public: Allows a redis instance to be used to provide the locking.
    #
    # Example:
    #
    # Robinhood.define do
    #   redis{ Redis.new(host: 'foo') }
    # end
    #
    # block - A mandatory block whose result will be assigned to the runtime's
    #         redis client.
    #
    # Returns nil.
    def redis
      @runtime.redis = yield
      nil
    end
  end
end
