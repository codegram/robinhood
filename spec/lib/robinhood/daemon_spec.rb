require 'spec_helper'
require 'robinhood/daemon'

describe Robinhood::Daemon do
  let(:default_options) {
    {
      dir_mode: :normal,
      dir: File.expand_path(File.join('tmp', 'pids')),
      monitor: true,
      multiple: true,
      app_name: 'robinhood',
      log_dir: File.expand_path('log'),
      log_output: true,
      command: 'start'
    }
  }
  let(:pid_dir_options) { default_options.merge!({dir: File.expand_path(File.join('tmp', 'pids_2'))}) }
  let(:log_dir_options) { default_options.merge!({log_dir: File.expand_path('log_2')}) }

  describe '#start' do
    context 'when no additional option is provided' do
      it 'should start the daemon' do
        daemon = Robinhood::Daemon.new
        assert_daemons_options(daemon, File.expand_path('Robinhood'), default_options)

        daemon.run
      end
    end

    context 'when different robinhood file is provided' do
      it 'should start the daemon with the given file' do
        daemon = Robinhood::Daemon.new(
          robinhood_file_path: File.expand_path('robinhood_2.rb')
        )
        assert_daemons_options(daemon, File.expand_path('robinhood_2.rb'), default_options)

        daemon.run
      end
    end

    context 'when pid dir is provided' do
      it 'start the daemon with the pid dir option' do
        daemon = Robinhood::Daemon.new(
          pids_dir_path: File.expand_path(File.join('tmp', 'pids_2'))
        )

        assert_daemons_options(daemon, File.expand_path('Robinhood'), pid_dir_options)

        daemon.run
      end
    end

    context 'when log dir is provided' do
      it 'start the daemon with the log dir option' do
        daemon = Robinhood::Daemon.new(
          log_dir_path: File.expand_path('log_2')
        )
        assert_daemons_options(daemon, File.expand_path('Robinhood'), log_dir_options)

        daemon.run
      end
    end
  end

  describe '#stop' do
    it 'should stop the daemon' do
      daemon = Robinhood::Daemon.new(command: 'stop')
      Daemons.should_receive(:run_proc).with(File.expand_path('Robinhood'), default_options.merge(command: 'stop'))

      daemon.stop
    end
  end
end