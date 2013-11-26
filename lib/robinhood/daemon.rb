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
    #        :config_file - File that will contain the robinhood tasks, by default it will be robinhood.rb
    #        :pids_path - Dir to store de Pidfile for the daemon, by default it will be 'tmp/pids'
    #        :log_path - Dir to store the logs for the daemon, by default it will be 'log'
    #
    # Returns a new Robinhood::Daemonize
    def initialize(options={})
      @options = default_options.merge(options)
      @file = File.expand_path(@options[:config_file])
      @pids_path = File.expand_path(@options[:pids_path])
      @log_path = File.expand_path(@options[:log_path])
    end

    # Public: Start the daemon
    #
    # Returns nothing
    def start
      definition = File.read(file)

      FileUtils.mkdir_p(log_path)
      FileUtils.mkdir_p(pids_path)

      Daemons.run_proc(filename, daemon_options.merge(ARGV: [@options[:command]])) do
        instance_eval(definition, @file)
        Robinhood.run
      end
    end
    alias :run :start

    def stop
      Daemons.run_proc(filename, daemon_options.merge(ARGV: ['stop']))
    end

    def restart
      stop
      start
    end

    private

    def default_options
      {
        command: 'start',
        config_file: 'Robinhood',
        log_path: 'log',
        pids_path: File.join("tmp", "pids")
      }
    end

    def daemon_options
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

    def filename
      File.basename file
    end
  end
end
