require 'spec_helper'
require 'fileutils'
require 'fakefs/safe'
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
      ARGV: ['start']
    }
  }

  describe '#start' do

    before do
      FakeFS.activate!

      FileUtils.touch("Robinhood")
    end

    after do
      FakeFS.deactivate!
    end

    context 'when no additional option is provided' do
      it 'should start the daemon' do
        daemon = Robinhood::Daemon.new

        expect(Daemons).to receive(:run_proc).with('Robinhood', default_options)

        daemon.start
      end
    end

    context 'when different robinhood file is provided' do
      it 'should start the daemon with the given file' do
        daemon = Robinhood::Daemon.new(
          config_file: File.expand_path('robinhood_2.rb')
        )

        expect(Daemons).to receive(:run_proc).with('robinhood_2.rb', default_options)

        FileUtils.touch("robinhood_2.rb")

        daemon.start
      end
    end

    context 'when pid dir is provided' do
      it 'start the daemon with the pid dir option' do
        dir = File.expand_path(File.join('tmp', 'pids_2'))

        daemon = Robinhood::Daemon.new(
          pids_path: dir
        )

        expect(Daemons).to receive(:run_proc).with('Robinhood', default_options.merge(dir: dir))

        daemon.start
      end
    end

    context 'when log dir is provided' do
      it 'start the daemon with the log dir option' do
        dir = File.expand_path('log_2')

        daemon = Robinhood::Daemon.new(
          log_path: dir
        )

        expect(Daemons).to receive(:run_proc).with('Robinhood', default_options.merge(log_dir: dir))

        daemon.start
      end
    end

    describe '#stop' do
      it 'should stop the daemon' do
        daemon = Robinhood::Daemon.new(command: 'stop')

        expect(Daemons).to receive(:run_proc).with('Robinhood', default_options.merge(ARGV: ['stop']))

        daemon.stop
      end
    end
  end
end
