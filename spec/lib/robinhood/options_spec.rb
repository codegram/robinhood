require 'spec_helper'
require 'robinhood'
require 'robinhood/options'

describe Robinhood::Options do
  let(:parser) { Robinhood::Options }

  describe '.parse' do
    context 'when start option is present' do
      it 'extract start option' do
        options = parser.parse(['start'])
        expect(options[:start]).to be_true
      end
    end

    context 'when stop option is present' do
      it 'extract stop option' do
        options = parser.parse(['stop'])
        expect(options[:stop]).to be_true
      end
    end

    context 'when log dir is present' do
      it 'extract log dir' do
        options = parser.parse(['LOGFILE=log/robinhood.log'])
        expect(options[:log_dir]).to eq('log/robinhood.log')
      end
    end

    context 'when pids dir is present' do
      it 'extract pids dir' do
        options = parser.parse(['PIDS_DIR=tmp/pids/robinhood'])
        expect(options[:pids_dir]).to eq('tmp/pids/robinhood')
      end
    end

    context 'when robinhood file path is present' do
      it 'extract robinhood file path' do
        options = parser.parse(['ROBINHOOD_FILE_PATH=robinhood_file.rb'])
        expect(options[:robinhood_file_path]).to eq('robinhood_file.rb')
      end
    end

    context 'when multiple options are present' do
      it 'extract all the options' do
        options = parser.parse(['start', 'PIDS_DIR=tmp/pids/robinhood'])
        expect(options[:start]).to be_true
        expect(options[:pids_dir]).to eq('tmp/pids/robinhood')
      end
    end
  end
end

