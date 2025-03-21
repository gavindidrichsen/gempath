# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/'
    enable_coverage :branch
    primary_coverage :branch

    # Set minimum coverage thresholds
    minimum_coverage line: 80, branch: 55

    # Generate HTML report
    formatter SimpleCov::Formatter::HTMLFormatter
  end
end

require 'bundler/setup'
require 'gempath'

module CliHelpers
  # Captures the output of a CLI command
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Include CLI helpers
  config.include CliHelpers

  # Ensure ARGV has a valid command for CLI tests
  config.before(:each) do
    # Only set default ARGV if it's empty or starts with a flag
    stub_const('ARGV', ['analyze']) if ARGV.empty? || ARGV.first&.start_with?('-')
  end
end
