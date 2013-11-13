require 'robinhood'
require 'daemons'

module Robinhood
  class Daemonize
    attr_reader :robinhood_file_path, :pids_dir_path, :log_dir_path

    def initialize(args={})
      @robinhood_file_path = args[:robinhood_file_path]
      @pids_dir_path = args[:pids_dir_path]
      @log_dir_path = args[:log_dir_path]
    end

    def start
      Daemons.run(file_path, options.merge(ARGV: ['start']))
    end

    def stop
      Daemons.run(file_path, options.merge(ARGV: ['stop']))
    end

    private

    def options
      {
        dir_mode: :normal,
        dir: pids_path,
        monitor: true,
        multiple: true,
        app_name: 'robinhood',
        log_dir: log_path,
        log_output: true
      }
    end

    def file_path
      @file_path ||= robinhood_file_path || File.expand_path('robinhood.rb')
    end

    def log_path
      @log_path ||= log_dir_path || File.expand_path('log')
    end

    def pids_path
      @pids_path ||= pids_dir_path || File.expand_path(File.join('tmp', 'pids'))
    end
  end
end