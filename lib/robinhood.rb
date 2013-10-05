require "robinhood/version"
require "robinhood/setup"
require "celluloid/autostart"

module Robinhood
  def self.setup(options = {}, &block)
    @setup ||= Setup.new(options)
    @setup.instance_eval(&block)
    @setup.start
  end

  def self.stop
    @setup.stop if @setup
  end

  def self.reset!
    stop
    @setup = nil
  end
end
