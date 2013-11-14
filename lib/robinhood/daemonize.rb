require 'robinhood'
require 'daemons'

module Robinhood
  # This class will start robinhood as a daemon
  #
  class Daemonize
    attr_reader :robinhood_file_path, :pids_dir_path, :log_dir_path

    # Public: Instantiates a new Robinhood::Daemonize object
    #
    # args - Hash with the different options that can be supplied to the Daemonize object
    #        :robinhood_file_path - File that will contain the robinhood tasks, by default it will be robinhood.rb
    #        :pids_dir_path - Dir to store de Pidfile for the daemon, by default it will be 'tmp/pids'
    #        :log_dir_path - Dir to store the logs for the daemon, by default it will be 'log'
    #
    # Returns a new Robinhood::Daemonize
    def initialize(args={})
      @robinhood_file_path = args[:robinhood_file_path]
      @pids_dir_path = args[:pids_dir_path]
      @log_dir_path = args[:log_dir_path]
    end

    # Public: Start the daemon
    #
    # Returns nothing
    def start
      Daemons.run(file_path, options.merge(ARGV: ['start']))
    end

    # Public: Stop the daemon
    #
    # Returns nothing
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