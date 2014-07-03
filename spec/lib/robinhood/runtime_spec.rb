require "spec_helper"
require "robinhood"
require "robinhood/runtime"
require 'thread'

module Robinhood
  describe Runtime do
    let(:runtime){ Robinhood::Runtime.new }

    describe "#add_process" do
      it "adds a process to be executed on start" do
        runtime.add_process :edballs, {foo: :bar}, Proc.new{}

        runtime.run(background: true)

        actor = Celluloid::Actor[:robinhood_edballs]
        expect(actor).to_not be_nil
        expect(actor.options).to include(foo: :bar)
      end
    end

    describe "#run" do
      it "sets the default redis db for the mutex" do
        redis = double(:redis)
        runtime.redis = redis
        runtime.run(background: true)

        expect(Mutex.redis).to eq(redis)
      end
    end

    describe "#stop" do
      it "stops the runtime synchronously" do
        runtime.add_process :edballs, {foo: :bar}, Proc.new{}

        runtime.run(background: true)
        runtime.stop

        expect(Celluloid::Actor[:robinhood_edballs]).to eq(nil)
      end
    end
  end
end
