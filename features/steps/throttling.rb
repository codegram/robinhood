class Spinach::Features::Throttling < Spinach::FeatureSteps
  include Spinach::Robinhood

  step 'I have a Robinhood file with a throttling ratio set at 3 seconds' do
    @file_name = File.expand_path('./tmp/robin_tmp')
    write_robinhood %Q{
      Robinhood.define do
        redis { Redis.new(database: 9) }
        process :test, throttle: 3 do
          File.open('#{@file_name}', 'a') do |f|
            f.write("yeah")
          end
        end
      end
    }
  end

  step 'I run robinhood for 4 seconds' do
    `bin/robinhood start -c tmp/Robinhood`
    sleep 4
    `bin/robinhood stop -c tmp/Robinhood`
  end

  step 'It only has run 2 times' do
    expect(File.read(@file_name)).to eq('yeahyeah')
  end

  after do
    FileUtils.rm(@file_name)
    FileUtils.rm('tmp/Robinhood')
  end
end
