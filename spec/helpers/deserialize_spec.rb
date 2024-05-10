require_relative '../spec_helper'

RSpec.describe Shortcut::Helpers::Deserialize do
  # ------------------------------------------------------------------------
  describe '.call' do
    let(:scripts_dir) { Shortcut::Config.scripts_dir }
    let(:script_name) { 'test_script' }
    let(:script_path) { "#{scripts_dir}/#{script_name}.sh" }

    # ------------------------------------------------------------------------
    context 'when the script file does not exist' do
      before do
        allow(File).to receive(:exist?).with(script_path).and_return(false)
      end

      it 'returns empty dest and description if script not found' do
        expect(Shortcut::Helpers::Messages).to receive(:script_not_found).with(script_name)
        result = described_class.call(script_name)
        expect(result).to eq({ dest: '', description: '' })
      end
    end

    # ------------------------------------------------------------------------
    context 'when the script file exists' do
      let(:file_content) { ["#!/bin/bash\n", "## dest: #{scripts_dir}\n", "## description: Sample script\n"] }

      before do
        allow(File).to receive(:exist?).with(script_path).and_return(true)
        allow(File).to receive(:open).with(script_path, 'r').and_yield(file_content.join)
      end

      it 'extracts and returns the destination and description from the script' do
        result = described_class.call(script_name)
        expect(result[:dest]).to eq(scripts_dir)
        expect(result[:description]).to eq('Sample script')
      end
    end
  end
end
