# frozen_string_literal: true

require 'thor'
require 'gempath'

module Gempath
  class CLI < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    def help(*)
      super
    end

    # Global options available to all commands
    class_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    class_option :filepath, aliases: '-f', type: :string,
                            desc: 'Path to Gemfile.lock (default: ./Gemfile.lock)',
                            default: 'Gemfile.lock'

    desc 'analyze [OPTIONS]', 'Analyze dependencies in Gemfile.lock'
    method_option :name, aliases: '-n', type: :string,
                         desc: 'Name of the gem to analyze'
    long_desc <<~LONGDESC
      `gempath analyze` analyzes dependencies and relationships in your Gemfile.lock.

      When run without options, it shows information for all gems.
      When given a gem name with --name, it shows detailed information just for that gem.

      For each gem, it shows:\n
        * Version being used\n
        * All direct dependencies and their versions\n
        * Source (rubygems.org, git, or path)\n
        * Direct consumers (gems that depend on it)\n
        * All dependency paths leading to this gem\n
      Examples:

        # Analyze all gems using Gemfile.lock in current directory:

          gempath analyze

        # Analyze aws-sdk-core using Gemfile.lock in current directory:

          gempath analyze --name aws-sdk-core

        # Analyze rails using a specific Gemfile.lock:

          gempath analyze --name rails --filepath /path/to/Gemfile.lock
    LONGDESC
    def analyze(*)
      # Thor will handle unknown arguments automatically

      analyzer = Gempath::Analyzer.new(options[:filepath])
      result = analyzer.analyze(options[:name])
      puts JSON.pretty_generate(result)
    rescue Gempath::Error => e
      raise Thor::Error,
            "#{e.message}\n\nTo specify a different Gemfile.lock location:\n  gempath analyze -f /path/to/Gemfile.lock"
    end

    desc 'generate [OPTIONS]', 'Generate a minimal Gemfile for a gem and its dependencies'
    method_option :name, aliases: '-n', type: :string, required: true,
                         desc: 'Name of the gem to generate Gemfile for'
    method_option :filepath, aliases: '-f', type: :string, default: 'Gemfile.lock',
                             desc: 'Path to Gemfile.lock (default: ./Gemfile.lock)'
    method_option :ruby_version, aliases: '-r', type: :string,
                                 desc: 'Ruby version to use (default: current Ruby version)'
    long_desc <<~LONGDESC
      `gempath generate` creates a minimal working Gemfile for a gem and its dependencies.

      This is useful for troubleshooting gem compatibility issues by creating an isolated
      environment with just the gem and its dependencies.

      The generated Gemfile will include:
      * Ruby version (if specified)
      * Source information (e.g. rubygems.org or custom gem server)
      * The target gem and its version
      * All direct dependencies and their versions
      * Any git or path-based dependencies

      Examples:

        # Generate Gemfile for aws-sdk-core using current directory's Gemfile.lock:

          gempath generate --name aws-sdk-core

        # Generate Gemfile for rails with specific Ruby version:

          gempath generate --name rails --ruby-version 3.2.0

        # Generate Gemfile using dependencies from a specific Gemfile.lock:

          gempath generate --name puppet --filepath /path/to/Gemfile.lock
    LONGDESC
    no_commands do
      def group_gems_by_source(_name, _version, source_info)
        case source_info&.dig('source', 'type')
        when 'git'
          [:git, source_info['source']['remote']]
        when 'path'
          [:path, source_info['source']['remote']]
        when 'rubygems'
          source = source_info['source']['remotes'].first
          source == 'https://rubygems.org' ? :default : [:source, source]
        else
          :default
        end
      end
    end

    def generate(*)
      analyzer = Gempath::Analyzer.new(options[:filepath])
      result = analyzer.analyze(options[:name])
      gem_info = result[options[:name]]

      raise Thor::Error, "Gem '#{options[:name]}' not found in #{options[:filepath]}" if gem_info.nil?

      # Start building the Gemfile content
      gemfile_content = []

      # Add Ruby version if specified
      if options[:ruby_version]
        gemfile_content << "ruby '#{options[:ruby_version]}'"
        gemfile_content << ''
      end

      # Default source is always rubygems.org
      gemfile_content << "source 'https://rubygems.org'"
      gemfile_content << ''

      # Group gems by their source
      gems_by_source = {}

      # Helper to add a gem to a source group
      add_to_group = lambda { |name, version, source_info|
        source_key = group_gems_by_source(name, version, source_info)
        gems_by_source[source_key] ||= []
        gems_by_source[source_key] << [name, version, source_info]
      }

      # Add main gem to its source group
      add_to_group.call(gem_info['name'], gem_info['version'], gem_info)

      # Add dependencies to their source groups
      gem_info['dependencies']&.each do |dep_name, dep_version|
        dep_result = analyzer.analyze(dep_name)
        dep_info = dep_result[dep_name]
        add_to_group.call(dep_name, dep_version, dep_info)
      end

      # Output gems grouped by source
      gems_by_source.each do |source_key, gems|
        case source_key
        when :default
          # Output default source gems directly
          gems.each do |name, version, _|
            gemfile_content << "gem '#{name}', '#{version}'"
          end
          gemfile_content << '' unless gems.empty?
        when Array
          source_type, source_value = source_key
          case source_type
          when :source
            gemfile_content << "source '#{source_value}' do"
            gems.each do |name, version, _|
              gemfile_content << "  gem '#{name}', '#{version}'"
            end
            gemfile_content << 'end'
            gemfile_content << ''
          when :git
            gemfile_content << "git '#{source_value}' do"
            gems.each do |name, _version, _|
              gemfile_content << "  gem '#{name}'"
            end
            gemfile_content << 'end'
            gemfile_content << ''
          when :path
            gems.each do |name, _, _|
              gemfile_content << "gem '#{name}', path: '#{source_value}'"
            end
            gemfile_content << ''
          end
        end
      end

      puts gemfile_content.join("\n").strip
    rescue Gempath::Error => e
      raise Thor::Error,
            "#{e.message}\n\nTo specify a different Gemfile.lock location:\n  gempath generate -f /path/to/Gemfile.lock"
    end

    default_task :help
  end
end
