require "spec_helper"
require "robinhood"

module Robinhood
  describe ".setup" do
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

      sleep(1)
      expect(queue).to be_empty
    end

    it "allows setting an arbitrary throttle" do
      queue = [1, 2]

      Robinhood.setup(background: true) do
        process :test, throttle: 0.5 do
          queue.pop
        end
      end

      sleep(0.2)
      expect(queue).not_to be_empty
      sleep(1)
      expect(queue).to be_empty
    end
  end
end
