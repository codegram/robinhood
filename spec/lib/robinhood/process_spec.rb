require "spec_helper"
require "robinhood"
require "robinhood/process"
require 'thread'

module Robinhood
  describe Process do
    before do
      Robinhood.start(background: true)
    end

    describe "mutual exclusion" do
      it "doesn't allow two of the same processes to run at once" do
        mutex = Mutex.new
        output = []
        append = Proc.new do |elem|
          mutex.synchronize do
            output << elem
          end
        end

        Process.new(:test, {throttle: 0.01}, Proc.new{
          append.call(:ed)
          sleep(0.05)
          append.call(:ed)
        })

        Process.new(:test, {throttle: 0.01}, Proc.new{
          append.call(:balls)
          sleep(0.05)
          append.call(:balls)
        })

        sleep(2)

        (output.length / 2).floor.times do |index|
          step = index * 2
          current_elem = output[step]
          next_elem    = output[step + 1]
          expect(next_elem).to eq(current_elem)
        end
      end
    end
  end
end
