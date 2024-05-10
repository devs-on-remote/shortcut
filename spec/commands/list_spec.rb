require 'pty'
require 'fileutils'

require_relative "../spec_helper"

RSpec.describe Shortcut::Commands::List do
  # ------------------------------------------------------------------------
  describe '.call' do
    before do
      allow(STDOUT).to receive(:puts)
      allow(STDOUT).to receive(:print)
    end

    let(:scripts_dir) { Shortcut::Config.scripts_dir }

    # ------------------------------------------------------------------------
    context 'when the scripts directory exists and has files' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(true)
        allow(Dir).to receive(:glob).with("#{scripts_dir}/*.sh")
                                    .and_return([
                                                  "#{scripts_dir}/script1.sh",
                                                  "#{scripts_dir}/script2.sh"
                                                ])
      end

      it 'lists available scripts' do
        expect(STDOUT).to receive(:puts).with('Available scripts:')
        expect(STDOUT).to receive(:puts).with('index |  name   | description')
        expect(STDOUT).to receive(:puts).with('  0   | script1 | ')
        expect(STDOUT).to receive(:puts).with('  1   | script2 | ')

        Shortcut::Commands::List.call

        Shortcut::Commands::List.call
      end
    end

    # ------------------------------------------------------------------------
    context 'when the scripts directory is empty' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(true)
        allow(Dir).to receive(:glob).with("#{scripts_dir}/*.sh").and_return([])
      end

      it 'outputs no shortcuts available' do
        expect(STDOUT).to receive(:puts).with('No scripts found.')

        Shortcut::Commands::List.call
      end
    end

    # ------------------------------------------------------------------------
    context 'when the scripts directory does not exist' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(false)
        allow(FileUtils).to receive(:mkdir_p).with(scripts_dir)
      end

      it 'creates the directory and outputs no shortcuts available' do
        expect(STDOUT).to receive(:puts).with('No scripts found.')

        Shortcut::Commands::List.call
      end
    end
  end
end
