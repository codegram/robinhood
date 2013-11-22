require_relative '../daemon'
require 'optparse'

class Robinhood::Daemon::Options
  def initialize(data)
    @data = data.dup
  end

  def parse
    options = {}
    parser(options).parse!(@data)
    options[:command] = @data[0]

    options
  end

  private

  def parser(result)
    OptionParser.new do |opts|
      opts.on('-c', "--config FILE", String) do |file|
        result[:file] = file
      end

      opts.on('--pids-path PATH') do |dir|
        result[:pids_path] = dir
      end

      opts.on('--log-path PATH') do |dir|
        result[:log_path] = dir
      end
    end
  end
end
