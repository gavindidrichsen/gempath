# frozen_string_literal: true

require 'spec_helper'
require 'gempath/cli'
require 'tmpdir'

RSpec.describe Gempath::CLI do
  describe 'analyze' do
    context 'when Gemfile.lock is not found' do
      around do |example|
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            example.run
          end
        end
      end

      it 'shows helpful error message' do
        output = `#{RbConfig.ruby} #{File.expand_path('../bin/gempath', __dir__)} analyze 2>&1`
        expect(output).to include("No Gemfile.lock found at 'Gemfile.lock'")
        expect(output).to include('To specify a different Gemfile.lock location:')
        expect(output).to include('gempath analyze -f /path/to/Gemfile.lock')
      end
    end

    context 'when given invalid arguments' do
      let(:gempath_cmd) { "#{RbConfig.ruby} #{File.expand_path('../bin/gempath', __dir__)}" }

      it 'shows usage information when no command is given' do
        # Thor automatically truncates long command descriptions in its help output
        # to maintain consistent formatting. The full description is only shown
        # when running `gempath help analyze`. Here we test for the truncated
        # version that Thor displays in the command list.
        output = `#{gempath_cmd} 2>&1`
        expect(output).to match(/Commands:/)
        expect(output).to match(/gempath analyze \[OPTIONS\]\s+# Analyze depen/)
      end

      it 'shows help for analyze command' do
        output = `#{gempath_cmd} help analyze 2>&1`
        expect(output).to include('Usage:')
        expect(output).to include('gempath analyze [OPTIONS]')
        expect(output).to include('Description:')
        expect(output).to include('`gempath analyze` analyzes dependencies')
        expect(output).to include('Options:')
        expect(output).to include('--name')
        expect(output).to include('--filepath')
      end
    end
  end
end
