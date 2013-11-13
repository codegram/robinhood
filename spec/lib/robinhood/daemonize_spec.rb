require 'spec_helper'
require 'robinhood/daemonize'

describe Daemonize do
  let(:daemonize) { Robinhood::Daemonize }
  let(:default_options) {
    {
      dir_mode: :normal,
      dir: File.expand_path(File.join('tmp', 'pids')),
      monitor: true,
      multiple: true,
      app_name: 'robinhood',
      log_dir: File.expand_path('log'),
      log_output: true
    }
  }

  let(:pid_dir_options) {
    {
      dir_mode: :normal,
      dir: File.expand_path(File.join('tmp', 'pids_2')),
      monitor: true,
      multiple: true,
      app_name: 'robinhood',
      log_dir: File.expand_path('log'),
      log_output: true
    }
  }

  let(:log_dir_options) {
    {
      dir_mode: :normal,
      dir: File.expand_path(File.join('tmp', 'pids')),
      monitor: true,
      multiple: true,
      app_name: 'robinhood',
      log_dir: File.expand_path('log_2'),
      log_output: true
    }
  }

  describe '#start' do
    context 'when no additional option is provided' do
      it 'should start the daemon' do
        assert_daemons_options(File.expand_path('robinhood.rb'), default_options.merge(ARGV: ['start']))

        daemonize.new.start
      end
    end

    context 'when different robinhood file is provided' do
      it 'should start the daemon with the given file' do
        assert_daemons_options(File.expand_path('robinhood_2.rb'), default_options.merge(ARGV: ['start']))

        daemonize.new(
          robinhood_file_path: File.expand_path('robinhood_2.rb')
        ).start
      end
    end

    context 'when pid dir is provided' do
      it 'start the daemon with the pid dir option' do
        assert_daemons_options(File.expand_path('robinhood.rb'), pid_dir_options.merge(ARGV: ['start']))

        daemonize.new(
          pids_dir_path: File.expand_path(File.join('tmp', 'pids_2'))
        ).start
      end
    end

    context 'when log dir is provided' do
      it 'start the daemon with the log dir option' do
        assert_daemons_options(File.expand_path('robinhood.rb'), log_dir_options.merge(ARGV: ['start']))

        daemonize.new(
          log_dir_path: File.expand_path('log_2')
        ).start
      end
    end
  end

  describe '#stop' do
    it 'should stop the daemon' do
      assert_daemons_options(File.expand_path('robinhood.rb'), default_options.merge(ARGV: ['stop']))

      daemonize.new.stop
    end
  end

  def assert_daemons_options(file, options)
    Daemons.should_receive(:run).with(file, options)
  end
end