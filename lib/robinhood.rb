require "robinhood/version"
require "robinhood/dsl"
require "celluloid/autostart"

module Robinhood
  def self.setup(options = {}, &block)
    @setup ||= DSL.new(options)
    @setup.instance_eval(&block) if block
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
