require "spec_helper"
require "robinhood"
require "robinhood/dsl"

module Robinhood
  describe DSL do
    let(:dsl){ DSL.new(runtime) }

    describe "#process" do
      let(:runtime){ double(:runtime, add_process: true) }

      it "adds a process to the runtime" do
        block = Proc.new{}
        dsl.process :test, {foo: :bar}, &block

        expect(runtime).to have_received(:add_process).
          with(:test, {foo: :bar}, block)
      end
    end

    describe "#redis" do
      let(:runtime){ double(:runtime, :redis= => true) }

      it "allows setting a redis client to the runtime" do
        redis = double(:redis)
        dsl.redis{ redis }

        expect(runtime).to have_received(:redis=).with(redis)
      end
    end
  end
end
