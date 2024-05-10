require 'shellwords'
require_relative '../spec_helper'

RSpec.describe Shortcut::Commands::Exec do
  describe '.call' do
    let(:scripts_dir) { Shortcut::Config.scripts_dir }
    let(:script_name) { 'test_script' }
    let(:script_path) { "#{scripts_dir}/#{script_name}.sh" }

    before do
      allow(Shortcut::Config).to receive(:scripts_dir).and_return(scripts_dir)
      allow(Shortcut::Config).to receive(:in_new_tab).and_return(false)
      allow(STDOUT).to receive(:puts)
    end

    context 'when the script exists' do
      context 'when the terminal is iTerm' do
        before do
          Dir.mkdir(scripts_dir) unless Dir.exist?(scripts_dir)

          allow(Shortcut::Config).to receive(:scripts_dir).and_return(scripts_dir)
          allow(File).to receive(:exist?).with(script_path).and_return(true)
          allow(Kernel).to receive(:system)
          allow(ENV).to receive(:[]).with('TERM_PROGRAM').and_return('iTerm.app')
        end

        it 'executes the script' do
          expect(Kernel).to receive(:system).with(anything)
          Shortcut::Commands::Exec.call(script_name)
        end
      end

      context 'when the terminal is Apple Terminal' do
        before do
          allow(Shortcut::Config).to receive(:scripts_dir).and_return(scripts_dir)
          allow(File).to receive(:exist?).with(script_path).and_return(true)
          allow(Kernel).to receive(:system)
          allow(ENV).to receive(:[]).with('TERM_PROGRAM').and_return('Apple_Terminal')
        end

        it 'executes the script' do
          expect(Kernel).to receive(:system).with(anything)
          Shortcut::Commands::Exec.call(script_name)
        end
      end
    end

    context 'when the script does not exist' do
      before do
        allow(File).to receive(:exist?).with(script_path).and_return(false)
      end

      it 'outputs a not found error' do
        expect(STDOUT).to receive(:puts).with("Script '#{script_name}' not found.")
        Shortcut::Commands::Exec.call(script_name)
      end
    end

    context 'when the terminal is not supported' do
      before do
        allow(File).to receive(:exist?).with(script_path).and_return(true)
        allow(ENV).to receive(:[]).with('TERM_PROGRAM').and_return('Unsupported_Terminal')
      end

      it 'informs the user that the terminal is not supported' do
        expect(STDOUT).to receive(:puts).with('Terminal not supported! Please use iTerm or Apple Terminal.')
        Shortcut::Commands::Exec.call(script_name)
      end
    end
  end
end
