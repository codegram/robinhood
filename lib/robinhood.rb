require "robinhood/version"
require "robinhood/dsl"
require "robinhood/runtime"

module Robinhood
  # Public: The starting point for Robinhood's DSL.
  #
  # Example:
  #
  #   Robinhood.define do
  #     redis{ Redis.new(host: 'foobar') }
  #
  #     process :ed, timeout: 100 do
  #       Balls.process!
  #     end
  #
  #     process :sweeper, throttle: 5 do
  #       Sweeper.sweep!
  #     end
  #   end
  def self.define(&block)
    dsl.instance_eval(&block) if block
  end

  # Public: Runs a previously configured Robinhood instance.
  #
  # options - A hash of options to configure the execution.
  #           (default: {background: false})
  #           :background - True if it has to be run on the background (doesn't
  #                         block the main thread), False otherwise.
  #
  # Returns nil.
  def self.run(options = {})
    runtime.run(options)
    nil
  end

  # Public: Stops Robinhood's execution, if it was run on the background.
  #
  # Returns nil.
  def self.stop
    runtime.stop if runtime
    nil
  end

  # Public: Assigns a Logger to Robinhood where it will output info, debug and
  # error messages.
  #
  # Returns the Logger.
  def self.logger=(logger)
    @logger = logger
  end

  # Private: Logs messages to the logger.
  #
  # loglevel - The message's log level: :info, :error or :debug
  # message  - A String with the message to be logged
  #
  # Returns nil.
  def self.log(loglevel, message)
    logger.send loglevel, message if logger
    nil
  end

  # Semi-public: Resets robinhood to a clean state. Mostly used on testing.
  #
  # Returns nil.
  def self.reset!
    stop
    @runtime = nil
  end

  def self.logger
    return @logger if defined?(@logger)
    @logger = Logger.new(STDOUT)
  end
  private_class_method :logger

  def self.runtime
    @runtime ||= Runtime.new
  end
  private_class_method :runtime

  def self.dsl
    @dsl ||= DSL.new(runtime)
  end
  private_class_method :dsl
end
