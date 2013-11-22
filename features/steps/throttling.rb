class Spinach::Features::Throttling < Spinach::FeatureSteps
  include Spinach::Robinhood

  step 'I have a Robinhood file with a throttling ratio set at 5 seconds' do
    write_robinhood %Q{
      Robinhood.define do
        redis { Redis.new(database: 9) }
        process :test, throttle: 5 do
          puts "TEST"
        end
      end
    }
  end

  step 'I run robinhood for 2 seconds' do
    puts `bin/robinhood tmp/Robinhood`
  end

  step 'I should see its output only one time' do
    pending 'step not implemented'
  end
end
