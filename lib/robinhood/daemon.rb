require 'robinhood'
require 'daemons'

module Robinhood
  # This class will start robinhood as a daemon
  #
  class Daemon
    attr_reader :file, :pids_path, :log_path

    # Public: Instantiates a new Robinhood::Daemon object
    #
    # args - Hash with the different options that can be supplied to the Daemonize object
    #        :robinhood_file_path - File that will contain the robinhood tasks, by default it will be robinhood.rb
    #        :pids_dir_path - Dir to store de Pidfile for the daemon, by default it will be 'tmp/pids'
    #        :log_dir_path - Dir to store the logs for the daemon, by default it will be 'log'
    #
    # Returns a new Robinhood::Daemonize
    def initialize(options={})
      @options = options
    end

    # Public: Start the daemon
    #
    # Returns nothing
    def run
      definition = File.read(file)
      Daemons.run_proc(filename, options.merge(ARGV: [@options[:command]])) do
        eval definition
        Robinhood.run
      end
    end

    private

    def options
      {
        dir_mode: :normal,
        dir: pids_path,
        monitor: true,
        app_name: 'robinhood',
        log_dir: log_path,
        log_output: true
      }
    end

    def file
      @file ||= File.expand_path(@options[:file] || "Robinhood")
    end

    def filename
      File.basename file
    end

    def log_path
      @log_path ||= File.expand_path(@options[:log_path] || "log")
    end

    def pids_path
      @pids_path ||= File.expand_path(@options[:pids_path] || File.join("tmp", "pids"))
    end
  end
end