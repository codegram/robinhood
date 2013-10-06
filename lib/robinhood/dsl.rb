require "robinhood/process_group"
require "celluloid"
require 'logger'

module Robinhood
  class DSL
    def initialize
      @group = ProcessGroup.new
    end

    def process(name, options = {}, &block)
      @group.add_process(name, options, block)
    end

    def redis
      @group.redis = yield
    end

    def start(options = {})
      @group.start(options)
    end

    def stop
      @group.stop
    end
  end
end
