require "spec_helper"
require "robinhood"

describe "Robinhood.setup" do
  it "creates actors for each process" do
    Robinhood.setup(background: true) do
      process(:ed){}
      process(:balls){}
    end

    expect(Celluloid::Actor[:robinhood_ed]).to_not be_nil
    expect(Celluloid::Actor[:robinhood_balls]).to_not be_nil
  end

  it "executes a process iteratively until it ends" do
    queue = [1, 2]

    Robinhood.setup(background: true) do
      process :test do
        queue.pop
      end
    end

    sleep(0.2)
    expect(queue).to be_empty
  end

  it "allows setting an arbitrary throttle" do
    throttle = 0.01

    calls = []

    method_call = Proc.new do
      calls << Time.now
    end

    Robinhood.setup(background: true) do
      process :test, throttle: throttle do
        method_call.call
      end
    end

    sleep(throttle * 5)

    calls.each_with_index do |call, index|
      if (index + 1) < calls.length
        expect(calls[index + 1] - call).to be > throttle
      end
    end
  end
end