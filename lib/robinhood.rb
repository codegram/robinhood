require "robinhood/version"
require "robinhood/dsl"
require "celluloid/autostart"

module Robinhood
  def self.define(&block)
    @setup ||= DSL.new
    @setup.instance_eval(&block) if block
  end

  def self.start(options = {})
    @setup ||= DSL.new
    @setup.start(options)
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
end
