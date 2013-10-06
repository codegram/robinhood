require "robinhood/process"
require "celluloid"
require 'logger'

module Robinhood
  class DSL
    def initialize
      @processes = []
    end

    def process(name, options = {}, &block)
      @processes << [name, options, block]
    end

    def redis
      if block_given?
        @redis = yield
      else
        @redis ||= Redis.new
      end
    end

    def supervision_group
      @supervision_group ||= Class.new(Celluloid::SupervisionGroup)
    end

    def start(options = {})
      setup_supervision_group
      Redis::Classy.db = redis

      Robinhood.log :info, "Starting Robin Hood: Robbing from the rich and giving to the poor.."

      @supervision_group_actor = if options[:background]
                                   supervision_group.run!
                                 else
                                   supervision_group.run
                                 end
    end

    def stop
      @supervision_group_actor.finalize if @supervision_group_actor
    end

    def setup_supervision_group
      @processes.each do |process|
        name, options, block = process

        supervision_group.supervise Process,
          as: "robinhood_#{name}",
          args: [name, options.merge(autostart: true), block]
      end
    end
  end
end
