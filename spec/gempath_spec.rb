# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gempath do
  let(:sample_lockfile) { File.join(__dir__, 'fixtures', 'sample.lock') }
  let(:analyzer) { Gempath::Analyzer.new(sample_lockfile) }

  it 'has a version number' do
    expect(Gempath::VERSION).not_to be nil
  end

  describe '#analyze' do
    context 'without gem name' do
      let(:result) { analyzer.analyze }

      it 'returns information for all gems' do
        expect(result.keys).to include('base64', 'bolt')
        expect(result['base64']).to include(
          'name' => 'base64',
          'version' => '0.2.0'
        )
      end
    end

    context 'with base64' do
      let(:result) { analyzer.analyze('base64') }

      it 'returns correct gem information' do
        expect(result['base64']).to include(
          'name' => 'base64',
          'version' => '0.2.0'
        )
      end

      it 'shows correct source information' do
        expect(result['base64']['source']).to eq(
          'type' => 'rubygems',
          'remotes' => ['https://rubygems.org/']
        )
      end

      it 'shows dependency paths' do
        paths = result['base64']['consumer_paths']
        expect(paths).to include(
          'puppet_litmus -> bolt -> CFPropertyList -> base64',
          'puppet_litmus -> bolt -> puppet -> CFPropertyList -> base64',
          'puppet_litmus -> bolt -> winrm -> rubyntlm -> base64',
          'puppet_litmus -> bolt -> winrm-fs -> winrm -> rubyntlm -> base64'
        )
      end

      it 'shows direct consumers' do
        consumers = result['base64']['direct_consumers']
        expect(consumers).to include('CFPropertyList', 'rubyntlm')
      end
    end

    context 'with non-existent gem' do
      it 'raises an error' do
        expect do
          analyzer.analyze('non-existent-gem')
        end.to raise_error(Gempath::Error, /not found in/)
      end
    end

    context 'with non-existent lockfile' do
      it 'raises an error with helpful message' do
        expect do
          Gempath::Analyzer.new('non-existent.lock')
        end.to raise_error(Gempath::Error, /No Gemfile.lock found at 'non-existent.lock'/)
      end
    end

    context 'with puppet gem' do
      it 'returns correct information for puppet gem' do
        result = analyzer.analyze('puppet')
        expect(result['puppet']).to include(
          'homepage' => 'Homepage information is available when using the -d flag',
          'summary' => 'Summary information is available when using the -d flag'
        )
      end

      it 'returns correct information for puppet gem when using -d debug flag' do
        allow(analyzer).to receive(:get_gem_info).with('puppet', true).and_return(['https://github.com/puppetlabs/puppet', 'Puppet, an automated configuration management tool'])
        result = analyzer.analyze('puppet', true)
        expect(result['puppet']).to include(
          'homepage' => 'https://github.com/puppetlabs/puppet',
          'summary' => 'Puppet, an automated configuration management tool'
        )
      end
    end
  end
end
