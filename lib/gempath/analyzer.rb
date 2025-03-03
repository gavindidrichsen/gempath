# frozen_string_literal: true

require 'bundler'

module Gempath
  class Analyzer
    def initialize(lockfile_path = 'Gemfile.lock')
      @lockfile_path = lockfile_path
      raise Gempath::Error, "No Gemfile.lock found at '#{lockfile_path}'" unless File.exist?(lockfile_path)

      @lockfile = Bundler::LockfileParser.new(File.read(lockfile_path))
    end

    def analyze(gem_name = nil)
      if gem_name
        spec = @lockfile.specs.find { |s| s.name == gem_name }
        raise Gempath::Error, "Gem '#{gem_name}' not found in Gemfile.lock" unless spec

        {
          gem_name => {
            'name' => spec.name,
            'version' => spec.version.to_s,
            'dependencies' => spec.dependencies.each_with_object({}) { |d, h| h[d.name] = d.requirement.to_s },
            'source' => extract_source(spec),
            'consumer_paths' => find_consumer_paths(spec),
            'direct_consumers' => find_direct_consumers(spec)
          }
        }
      else
        @lockfile.specs.each_with_object({}) do |spec, result|
          result[spec.name] = {
            'name' => spec.name,
            'version' => spec.version.to_s,
            'dependencies' => spec.dependencies.each_with_object({}) { |d, h| h[d.name] = d.requirement.to_s },
            'source' => extract_source(spec),
            'consumer_paths' => find_consumer_paths(spec),
            'direct_consumers' => find_direct_consumers(spec)
          }
        end
      end
    end

    private

    def extract_source(spec)
      source = spec.source
      case source
      when Bundler::Source::Git
        {
          'type' => 'git',
          'remote' => source.uri,
          'ref' => source.ref,
          'branch' => source.branch
        }
      when Bundler::Source::Path
        {
          'type' => 'path',
          'remote' => source.path
        }
      when Bundler::Source::Rubygems
        {
          'type' => 'rubygems',
          'remotes' => source.remotes.map(&:to_s)
        }
      else
        {
          'type' => 'unknown'
        }
      end
    end

    def find_consumer_paths(spec)
      paths = Set.new
      @lockfile.specs.each do |s|
        paths.merge(find_paths_to_spec(s, spec.name))
      end
      paths.to_a
    end

    def find_paths_to_spec(from_spec, target_name, path = [])
      return Set.new if path.include?(from_spec.name)

      paths = Set.new

      from_spec.dependencies.each do |dep|
        if dep.name == target_name
          paths.add([*path, from_spec.name, target_name].join(' -> '))
        else
          dep_spec = @lockfile.specs.find { |s| s.name == dep.name }
          if dep_spec
            sub_paths = find_paths_to_spec(dep_spec, target_name, [*path, from_spec.name])
            paths.merge(sub_paths)
          end
        end
      end
      paths
    end

    def find_direct_consumers(spec)
      @lockfile.specs.select { |s| s.dependencies.any? { |d| d.name == spec.name } }.map(&:name)
    end
  end
end
