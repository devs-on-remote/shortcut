require 'pty'
require 'fileutils'

require_relative '../spec_helper'

RSpec.describe Shortcut::Commands::Edit do
  # ------------------------------------------------------------------------
  describe '.call' do
    let(:scripts_dir) { Shortcut::Config.scripts_dir }
    let(:script_name) { 'test_script' }
    let(:new_script_name) { 'new_test_script' }
    let(:new_description) { 'New description of the script.' }
    let(:script_path) { "#{scripts_dir}/#{script_name}.sh" }
    let(:new_script_path) { "#{scripts_dir}/#{new_script_name}.sh" }

    before do
      allow(Shortcut::Config).to receive(:scripts_dir).and_return(scripts_dir)
      allow(STDIN).to receive(:gets).and_return(script_name, new_script_name, new_description)
    end

    # ------------------------------------------------------------------------
    context 'when the scripts directory does not exist' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(false)
      end

      it 'prints no scripts found message' do
        expect(Shortcut::Helpers::Messages).to receive(:no_scripts_found)
        described_class.call
      end
    end

    # ------------------------------------------------------------------------
    context 'when the script does not exist' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(true)
        allow(File).to receive(:exist?).with(script_path).and_return(false)
      end

      it 'prints script not found message' do
        expect(Shortcut::Helpers::Messages).to receive(:script_not_found).with(script_name)
        described_class.call
      end
    end

    # ------------------------------------------------------------------------
    context 'when the script exists' do
      before do
        allow(Dir).to receive(:exist?).with(scripts_dir).and_return(true)
        allow(File).to receive(:exist?).with(script_path).and_return(true)
        allow(FileUtils).to receive(:mv).with(script_path, new_script_path)
        allow(File).to receive(:open).with(
          new_script_path,
          'r'
        ).and_yield(StringIO.new("#!/bin/bash\n## dest: #{scripts_dir} description: #{new_description}\n"))
        allow(File).to receive(:open).with(new_script_path, 'w')
      end

      it 'edits the script successfully' do
        expect(Shortcut::Helpers::Messages).to receive(:script_edited).with(
          script_name,
          new_script_name,
          new_description
        )
        described_class.call
      end
    end
  end
end
