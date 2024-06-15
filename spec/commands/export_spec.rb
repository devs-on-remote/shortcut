require 'fileutils'
require_relative '../spec_helper'

RSpec.describe Shortcut::Commands::Export do
  describe '.call' do
    let(:path) { '/destination/directory' }

    before do
      allow(STDIN).to receive(:gets).and_return(path)
      allow(Shortcut::Helpers::Messages).to receive(:no_scripts_found)
      allow(Shortcut::Helpers::Messages).to receive(:directory_not_found)
    end

    context 'when scripts directory does not exist' do
      before do
        allow(Dir).to receive(:exist?).with(Shortcut::Config.scripts_dir).and_return(false)
      end

      it 'prints no scripts found message and returns' do
        expect(Shortcut::Helpers::Messages).to receive(:no_scripts_found)
        described_class.call
      end
    end

    context 'when destination directory does not exist' do
      before do
        allow(Dir).to receive(:exist?).with(Shortcut::Config.scripts_dir).and_return(true)
        allow(Dir).to receive(:exist?).with(path).and_return(false)
      end

      it 'prints directory not found message and returns' do
        expect(Shortcut::Helpers::Messages).to receive(:directory_not_found)
        described_class.call
      end
    end

    context 'when both directories exist' do
      before do
        allow(Dir).to receive(:exist?).with(Shortcut::Config.scripts_dir).and_return(true)
        allow(Dir).to receive(:exist?).with(path).and_return(true)
        allow(described_class).to receive(:copy_files)
      end

      it 'calls copy_files with the destination directory' do
        expect(described_class).to receive(:copy_files).with(path)
        described_class.call
      end
    end
  end

  describe '.copy_files' do
    let(:source_dir) { '/source/directory' }
    let(:destination_dir) { '/destination/directory' }
    let(:source_item) { '/source/directory/file.sh' }
    let(:destination_item) { '/destination/directory/file.sh' }
    let(:script_name) { 'file' }
    let(:script_info) { { description: 'A test script' } }

    before do
      allow(Shortcut::Config).to receive(:scripts_dir).and_return(source_dir)
      allow(Dir).to receive(:glob).with("#{source_dir}/*").and_return([source_item])
      allow(File).to receive(:file?).with(source_item).and_return(true)
      allow(File).to receive(:extname).with(source_item).and_return('.sh')
      allow(File).to receive(:extname).with('file.sh').and_return('.sh')
      allow(File).to receive(:basename).with(source_item).and_call_original
      allow(File).to receive(:basename).with(source_item, '.sh').and_return('file')
      allow(Shortcut::Helpers::Deserialize).to receive(:call).with('file').and_return(script_info)
      allow(Shortcut::Helpers::Messages).to receive(:script_copied)
      allow(FileUtils).to receive(:cp)
    end

    context 'when the file does not exist in the destination' do
      before do
        allow(File).to receive(:exist?).with(destination_item).and_return(false)
      end

      it 'copies the file and notifies the user' do
        expect(FileUtils).to receive(:cp).with(source_item, destination_item)
        expect(Shortcut::Helpers::Messages).to receive(:script_copied).with(destination_item, script_name, script_info[:description])
        described_class.copy_files(destination_dir)
      end
    end

    context 'when the file already exists in the destination' do
      before do
        allow(File).to receive(:exist?).with(destination_item).and_return(true)
      end

      it 'does not copy the file or notify the user' do
        expect(FileUtils).not_to receive(:cp)
        expect(Shortcut::Helpers::Messages).not_to receive(:script_copied)
        described_class.copy_files(destination_dir)
      end
    end
  end
end
