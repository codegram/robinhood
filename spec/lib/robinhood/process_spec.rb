require "spec_helper"
require "robinhood"
require "robinhood/process"
require 'thread'

module Robinhood
  describe Process do
    before do
      Robinhood::Runtime.new.run(background: true)
    end

    describe "mutual exclusion" do
      it "doesn't allow two of the same processes to run at once" do
        output = []

        Process.new(:test, {throttle: 0.01}, Proc.new{
          output << :ed
          sleep(0.05)
          output << :ed
        })

        Process.new(:test, {throttle: 0.01}, Proc.new{
          output << :balls
          sleep(0.05)
          output << :balls
        })

        sleep(2)

        (output.length / 2).times.map{|i| i * 2}.each do |index|
          expect(output[index]).to eq(output[index + 1])
        end
      end
    end
  end
end
