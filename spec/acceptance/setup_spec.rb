require "spec_helper"
require "robinhood"

module Robinhood
  describe ".setup" do
    after{ Robinhood.stop }

    it "creates actors for each process" do
      Robinhood.setup(background: true) do
        process(:ed){}
        process(:balls){}
      end

      expect(Celluloid::Actor[:robinhood_ed]).to_not be_nil
      expect(Celluloid::Actor[:robinhood_balls]).to_not be_nil
    end

    it "executes a process iteratively until it ends" do
      queue = [1, 2, 3]

      Robinhood.setup(background: true) do
        process :test do
          queue.pop
        end
      end

      sleep(1)
      expect(queue).to be_empty
    end
  end
end
