# frozen_string_literal: true

require 'shortcut'
require 'rainbow'

Shortcut::Config.env = :test
Shortcut::Config.setup

Rainbow.enabled = false

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
