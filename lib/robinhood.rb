require "robinhood/version"
require "robinhood/dsl"
require "celluloid/autostart"

module Robinhood
  def self.define(&block)
    dsl.instance_eval(&block) if block
  end

  def self.start(options = {})
    dsl.start(options)
  end

  def self.stop
    @setup.stop if @setup
  end

  def self.reset!
    stop
    @setup = nil
  end

  def self.log(loglevel, message)
    logger.send loglevel, message if logger
  end

  def self.logger
    return @logger if defined?(@logger)
    @logger = Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.dsl
    @dsl ||= DSL.new
  end
  private_class_method :dsl
end
