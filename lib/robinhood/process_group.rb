require "celluloid"
require "robinhood/process"

module Robinhood
  class ProcessGroup
    attr_accessor :redis

    def initialize
      @processes = []
    end

    def add_process(name, options, block)
      @processes << [name, options, block]
    end

    def supervision_group
      @supervision_group ||= Class.new(Celluloid::SupervisionGroup)
    end

    def redis
      @redis ||= Redis.new
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
