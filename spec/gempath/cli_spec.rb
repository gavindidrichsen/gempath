# frozen_string_literal: true

require 'spec_helper'
require 'gempath/cli'

RSpec.describe Gempath::CLI do
  let(:cli) { described_class.new }
  let(:sample_lockfile) { File.join('spec', 'fixtures', 'sample.lock') }

  describe '#analyze' do
    context 'when given a specific gem' do
      it 'outputs the analysis for that gem' do
        output = JSON.parse(capture(:stdout) { cli.invoke(:analyze, [], name: 'bolt', filepath: sample_lockfile) })
        expect(output).to include('bolt' => include('name' => 'bolt'))
      end
    end

    context 'when no gem is specified' do
      it 'outputs the analysis for all gems' do
        output = JSON.parse(capture(:stdout) { cli.invoke(:analyze, [], filepath: sample_lockfile) })
        expect(output).to include(
          'bolt' => include('name' => 'bolt'),
          'puppet' => include('name' => 'puppet')
        )
      end
    end
  end

  describe '#generate' do
    context 'when given a specific gem' do
      it 'generates a Gemfile for bolt and its dependencies with proper source grouping' do
        output = capture(:stdout) { cli.invoke(:generate, [], name: 'bolt', filepath: sample_lockfile) }
        expect(output).to include('source \'https://rubygems.org\'')
        expect(output).to include('source \'https://rubygems.org/\' do')
        expect(output).to include('gem \'bolt\', \'4.0.0\'')
        expect(output).to include('source \'https://rubygems-puppetcore.puppet.com/\' do')
        expect(output).to include('gem \'puppet\', \'>= 6.18.0\'')
      end

      it 'generates a Gemfile for puppet with custom source and dependencies' do
        output = capture(:stdout) { cli.invoke(:generate, [], name: 'puppet', filepath: sample_lockfile) }
        expect(output).to include('source \'https://rubygems.org\'')
        expect(output).to include('source \'https://rubygems-puppetcore.puppet.com/\' do')
        expect(output).to include('gem \'puppet\', \'8.11.0\'')
        expect(output).to include('gem \'facter\', \'>= 4.3.0, < 5\'')
        expect(output).to include('source \'https://rubygems.org/\' do')
        expect(output).to include('gem \'CFPropertyList\', \'>= 3.0.6, < 4\'')
        expect(output).to include('gem \'concurrent-ruby\', \'~> 1.0\'')
      end

      it 'generates a Gemfile for path-based gems' do
        output = capture(:stdout) { cli.invoke(:generate, [], name: 'diataxis', filepath: sample_lockfile) }
        expect(output).to include('source \'https://rubygems.org\'')
        expect(output).to include('gem \'diataxis\', path: \'/Users/gavin.didrichsen/@REFERENCES/github/app/development/philosophy/diataxis_usage/diataxis\'')
      end

      it 'includes ruby version and maintains source grouping' do
        output = capture(:stdout) { cli.invoke(:generate, [], name: 'bolt', filepath: sample_lockfile, ruby_version: '3.2.0') }
        expect(output).to include('ruby \'3.2.0\'')
        expect(output).to include('source \'https://rubygems.org\'')
        expect(output).to include('source \'https://rubygems.org/\' do')
        expect(output).to include('gem \'bolt\', \'4.0.0\'')
      end
    end

    context 'with invalid input' do
      it 'raises an error for non-existent gem' do
        expect { cli.generate('nonexistent-gem', filepath: sample_lockfile) }
          .to raise_error(Thor::Error, /not found/)
      end

      it 'raises an error for non-existent lockfile' do
        expect { cli.generate('bolt', filepath: 'nonexistent.lock') }
          .to raise_error(Thor::Error, /not found/)
      end
    end
  end
end
