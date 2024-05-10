require 'fileutils'
require_relative '../spec_helper'

RSpec.describe Shortcut::Commands::Delete do
  # ------------------------------------------------------------------------
  describe '.call' do
    let(:scripts_dir) { Shortcut::Config.scripts_dir }
    let(:script_name) { 'test_script' }
    let(:script_path) { File.join(scripts_dir, "#{script_name}.sh") }

    before do
      allow(Shortcut::Config).to receive(:scripts_dir).and_return(scripts_dir)
      allow(STDOUT).to receive(:puts)
      allow(STDOUT).to receive(:print)
      allow(STDIN).to receive(:gets).and_return(script_name)
    end

    # ------------------------------------------------------------------------
    context 'when the directory exists and contains the script' do
      before do
        FileUtils.mkdir_p(scripts_dir) unless Dir.exist?(scripts_dir)

        File.open(script_path, 'w') do |file|
          file.puts('#!/bin/bash')
          file.puts('echo Hello World!')
        end

        system("chmod +x #{script_path}")
      end

      after do
        Shortcut::Config.clean
      end

      it 'deletes the script and confirms deletion' do
        expect(File).to exist(script_path)
        Shortcut::Commands::Delete.call
        expect(File).not_to exist(script_path)
        expect(STDOUT).to have_received(:puts).with("Script '#{script_name}' has been deleted.")
      end
    end

    # ------------------------------------------------------------------------
    context 'when the script does not exist but directory does' do
      before do
        FileUtils.mkdir_p(scripts_dir) unless Dir.exist?(scripts_dir)
      end

      after do
        Shortcut::Config.clean
      end

      it 'informs the user that the script was not found' do
        Shortcut::Commands::Delete.call
        expect(STDOUT).to have_received(:puts).with("Script '#{script_name}' not found.")
      end
    end

    # ------------------------------------------------------------------------
    context 'when the scripts directory does not exist' do
      before do
        allow(Shortcut::Config).to receive(:scripts_dir).and_return('/non/existent/directory')
      end

      it 'informs the user no scripts are available to delete' do
        Shortcut::Commands::Delete.call
        expect(STDOUT).to have_received(:puts).with('No scripts found.')
      end
    end
  end
end
