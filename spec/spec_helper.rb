# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-html'
  require 'simplecov-json'
  require 'simplecov-badge'

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/'
    enable_coverage :branch
    primary_coverage :branch

    # Set minimum coverage thresholds
    minimum_coverage line: 87, branch: 64

    # Generate HTML and JSON reports locally, badge will be generated in CI
    formatters = [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::JSONFormatter
    ]
    # Only add badge formatter in CI environment where ImageMagick is available
    formatters << SimpleCov::Formatter::BadgeFormatter if ENV['CI']

    formatter SimpleCov::Formatter::MultiFormatter.new(formatters)
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
end
