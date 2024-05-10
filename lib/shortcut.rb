# frozen_string_literal: true

# !/usr/bin/env ruby

require 'thor'
require 'rainbow'

require_relative 'shortcut/version'
require_relative 'shortcut/commands/record'
require_relative 'shortcut/commands/list'
require_relative 'shortcut/commands/exec'
require_relative 'shortcut/commands/delete'
require_relative 'shortcut/commands/edit'

require_relative 'shortcut/config'
require_relative 'shortcut/helpers/messages'

class CLI < Thor
  # ------------------------------------------------------------------------
  def initialize(*args, env: :prod)
    super(*args)
    setup_environment(env)
  end

  # ------------------------------------------------------------------------
  desc 'exec SCRIPT_NAMES', 'Run a script'
  method_option :list, type: :boolean, default: false, desc: 'List all scripts'
  method_option :record, type: :boolean, default: false, desc: 'Record a new script'
  method_option :delete, type: :boolean, default: false, desc: 'Delete recorded script'
  method_option :help, type: :boolean, default: false, desc: 'Show help message'
  method_option :edit, type: :boolean, default: false, desc: 'Edit a script'
  method_option :version, type: :boolean, default: false, desc: 'Current version of the Shortcut'
  method_option :license, type: :boolean, default: false, desc: 'Show license'
  def exec(*script_names)
    Signal.trap('INT') do
      puts "\nOperation cancelled by user."
      exit(1)
    end

    if options[:list]
      Shortcut::Commands::List.call
    elsif options[:record]
      Shortcut::Helpers::Messages.on_record_init
      Shortcut::Commands::Record.call
    elsif options[:delete]
      Shortcut::Commands::Delete.call
    elsif options[:help]
      Shortcut::Helpers::Messages.help_message
    elsif options[:edit]
      Shortcut::Commands::Edit.call
    elsif options[:version]
      Shortcut::Helpers::Messages.version
    elsif options[:license]
      Shortcut::Helpers::Messages.license
    elsif script_names.empty?
      Shortcut::Helpers::Messages.name_can_not_be_empty
      Shortcut::Helpers::Messages.all_commands
      exit(1)
    else
      # Run the scripts
      script_names.each do |script_name|
        Shortcut::Commands::Exec.call(script_name)
      end
    end
  end

  private

  # ------------------------------------------------------------------------
  def setup_environment(env)
    Shortcut::Config.env = env
    Shortcut::Config.setup
  end
end
