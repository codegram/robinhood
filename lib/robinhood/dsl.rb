require "robinhood/process"
require "celluloid"

module Robinhood
  class DSL
    attr_reader :options

    def initialize(options = {})
      @options = options
      @processes = []
    end

    def process(name, options = {}, &block)
      @processes << [name, options, block]
    end

    def redis
      @redis = yield
    end

    def supervision_group
      @supervision_group ||= Class.new(Celluloid::SupervisionGroup)
    end

    def start
      setup_supervision_group
      Redis::Classy.db = @redis || Redis.new

      @supervision_group_actor = if options[:background]
                                   supervision_group.run!
                                 else
                                   supervision_group.run
                                 end
    end

    def stop
      @supervision_group_actor.finalize if @supervision_group_actor
    end

    def redis_options
      options[:redis] || {}
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
