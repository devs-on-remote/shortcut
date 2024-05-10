require 'pty'
require 'expect'
require 'rainbow'
require 'fileutils'
require 'timeout'
require_relative '../spec_helper'

RSpec.describe Shortcut::Commands::Record do
  describe '.call' do
    let(:reader) { double('reader') }
    let(:writer) { double('writer') }
    let(:pid) { 1234 }

    before do
      Shortcut::Config.clean
      allow(PTY).to receive(:spawn).with('bash --login').and_yield(reader, writer, pid)
      allow(reader).to receive(:readpartial).and_return('user@hostname:~/Users')
      allow(reader).to receive(:read_nonblock).and_return('')
      allow(Process).to receive(:kill)
      allow(STDOUT).to receive(:puts)
      allow(STDOUT).to receive(:print)

      # Allow writer to receive 'puts' with 'pwd' any number of times
      allow(writer).to receive(:puts).with('pwd').and_return(nil)
      allow(Shortcut::Helpers::Messages).to receive(:script_created)
    end

    after do
      Shortcut::Config.clean
    end

    context 'when saving commands successfully and notifying user' do
      before do
        allow(reader).to receive(:expect).with(/[$#] /).and_yield(['user@hostname:~$ '])
        allow(STDIN).to receive(:gets).and_return('ls', 'pwd', 'sc-stop', 'valid_name')
        allow(writer).to receive(:puts).with('ls')
        allow(writer).to receive(:puts).with('pwd')
        allow(writer).to receive(:puts).with('valid_name')
      end

      it 'records, saves commands successfully, and notifies user' do
        expect(Shortcut::Commands::Record).to receive(:save_commands).and_call_original
        expect(Shortcut::Helpers::Messages).to receive(:script_created).with('valid_name')
        described_class.call
      end
    end

    context 'when user inputs an invalid script name' do
      it 'rejects empty script names' do
        allow(STDIN).to receive(:gets).and_return('sc-stop', '', 'valid_name')
        allow(reader).to receive(:expect).with(/[$#] /).at_least(:once).and_yield(['user@hostname:~$ '])
        expect(STDOUT).to receive(:puts).with(Rainbow("Script name can't be empty").red).ordered
        described_class.call
      end

      it 'rejects names with spaces' do
        allow(STDIN).to receive(:gets).and_return('sc-stop', 'invalid name', 'valid_name')
        allow(reader).to receive(:expect).with(/[$#] /).at_least(:once).and_yield(['user@hostname:~$ '])
        expect(STDOUT).to receive(:puts).with(Rainbow("Script name can't have spaces").red).ordered
        described_class.call
      end

      it 'rejects names with invalid characters' do
        allow(STDIN).to receive(:gets).and_return('sc-stop', 'name$', 'valid_name')
        allow(reader).to receive(:expect).with(/[$#] /).at_least(:once).and_yield(['user@hostname:~$ '])
        expect(STDOUT).to receive(:puts).with(Rainbow('Script name must be alphanumeric. Signs allowed: _-').red).ordered
        described_class.call
      end

      it 'rejects a duplicate script name' do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).with("#{Shortcut::Config.scripts_dir}/duplicate_name.sh").and_return(true)
        allow(STDIN).to receive(:gets).and_return('sc-stop', 'duplicate_name', 'unique_name')
        allow(reader).to receive(:expect).with(/[$#] /).at_least(:once).and_yield(['user@hostname:~$ '])
        expect(STDOUT).to receive(:puts).with(Rainbow('Script with this name already exists!').red).ordered
        described_class.call
      end
    end
  end
end
