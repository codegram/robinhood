require "spec_helper"
require "robinhood"

describe "Robinhood.define" do
  it "executes a process iteratively until it ends" do
    queue = [1, 2]

    Robinhood.define do
      process :test do
        queue.pop
      end
    end

    Robinhood.run(background: true)

    sleep(0.2)
    expect(queue).to be_empty
  end

  it "allows setting an arbitrary throttle" do
    throttle = 0.01

    calls = []

    method_call = Proc.new do
      calls << Time.now
    end

    Robinhood.define do
      process :test, throttle: throttle do
        method_call.call
      end
    end

    Robinhood.run(background: true)

    sleep(throttle * 5)

    calls.each_with_index do |call, index|
      if (index + 1) < calls.length
        expect(calls[index + 1] - call).to be > throttle
      end
    end
  end
end
