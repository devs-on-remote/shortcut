require 'spec_helper'

RSpec.describe CLI do
  describe '#exec' do
    let(:cli_instance) { CLI.new }

    before do
      allow(Signal).to receive(:trap).with('INT')
      allow(STDOUT).to receive(:puts)
      allow(Shortcut::Helpers::Messages).to receive(:on_record_init)
      allow(Shortcut::Helpers::Messages).to receive(:help_message)
      allow(Shortcut::Helpers::Messages).to receive(:version)
      allow(Shortcut::Helpers::Messages).to receive(:license)
    end

    # Correct the way to pass options in a Thor command test
    context 'when the list option is specified' do
      it 'calls the list command' do
        expect(Shortcut::Commands::List).to receive(:call)
        cli_instance.invoke(:exec, [], { list: true })
      end
    end

    context 'when the record option is specified' do
      it 'initializes recording and calls the record command' do
        expect(Shortcut::Helpers::Messages).to receive(:on_record_init)
        expect(Shortcut::Commands::Record).to receive(:call)
        cli_instance.invoke(:exec, [], { record: true })
      end
    end

    context 'when the delete option is specified' do
      it 'calls the delete command' do
        expect(Shortcut::Commands::Delete).to receive(:call)
        cli_instance.invoke(:exec, [], { delete: true })
      end
    end

    context 'when the help option is specified' do
      it 'displays the help message' do
        expect(Shortcut::Helpers::Messages).to receive(:help_message)
        cli_instance.invoke(:exec, [], { help: true })
      end
    end

    context 'when the edit option is specified' do
      it 'calls the edit command' do
        expect(Shortcut::Commands::Edit).to receive(:call)
        cli_instance.invoke(:exec, [], { edit: true })
      end
    end

    context 'when the version option is specified' do
      it 'displays the version message' do
        expect(Shortcut::Helpers::Messages).to receive(:version)
        cli_instance.invoke(:exec, [], { version: true })
      end
    end

    context 'when the license option is specified' do
      it 'displays the license message' do
        expect(Shortcut::Helpers::Messages).to receive(:license)
        cli_instance.invoke(:exec, [], { license: true })
      end
    end

    context 'when no script name is provided' do
      it 'alerts user and shows all commands' do
        expect(Shortcut::Helpers::Messages).to receive(:name_can_not_be_empty)
        expect(Shortcut::Helpers::Messages).to receive(:all_commands)
        cli_instance.invoke(:exec, [])
      end
    end

    context 'when multiple script names are provided' do
      let(:script_names) { ['script1.sh', 'script2.sh', 'script3.sh'] }

      it 'executes each script provided' do
        script_names.each do |script_name|
          expect(Shortcut::Commands::Exec).to receive(:call).with(script_name)
        end
        cli_instance.invoke(:exec, script_names)
      end
    end
  end
end
