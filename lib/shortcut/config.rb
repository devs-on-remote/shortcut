require 'fileutils'

require_relative 'helpers/messages'
require_relative 'helpers/deserialize'

module Shortcut
  module Config
    # env - the environment to run the scripts in
    # script_dir - the directory where the scripts are stored
    # in_new_tab - whether to open the script in a new tab or not

    class << self
      attr_accessor :env
      attr_reader :scripts_dir, :in_new_tab
    end

    # ------------------------------------------------------------------------
    def self.setup
      case env
      when :test
        @scripts_dir = File.expand_path('../../tmp/test_scripts', __dir__)
        @in_new_tab = false

        FileUtils.mkdir_p(@scripts_dir) unless Dir.exist?(@scripts_dir)
      when :prod
        @scripts_dir = File.expand_path('../../tmp/scripts', __dir__)
        @in_new_tab = true

        FileUtils.mkdir_p(@scripts_dir) unless Dir.exist?(@scripts_dir)
      else
        raise "Error: Unknown environment: `#{env}`"
      end
    end

    # ------------------------------------------------------------------------
    def self.clean
      FileUtils.rm_rf(scripts_dir)
    end
  end
end
