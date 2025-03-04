# Gempath

[![Coverage](https://img.shields.io/badge/coverage-87%25-green.svg)](https://gavindidrichsen.github.io/gempath/coverage)

Gempath is a tool for analyzing gem dependencies in your Ruby projects. It helps you understand:

- What gems depend on other gems
- The exact versions being used
- All the dependency paths that lead to a particular gem
- Where each gem comes from (rubygems.org, git, local path)

## Installation

```bash
gem install gempath
```

## Usage

The following sections show quick-start usage.  For more detaile information including tutorials and design decisions, see [docs/README.md](./docs/README.md).

### gempath help

Gempath provides a command-line interface with built-in help:

```bash
# Show all available commands and options
gempath help

# Show detailed help for the analyze command
gempath help analyze
# or
gempath analyze --help
```

### gempath analyze

Basic usage assumes you're running this from within a project that has a valid Gemfile.lock:

```bash
# Analyze all gems in current directory's Gemfile.lock
gempath analyze

# Analyze a specific gem
gempath analyze --name base64  # or -n for short

# Analyze a gem in a specific Gemfile.lock
gempath analyze --filepath /path/to/Gemfile.lock --name rails  # or -f for short
```

For example, run the following from the root of the repository:

```bash
➜  gempath git:(add_full_gem) gempath analyze --name facter --filepath spec/fixtures/sample.lock
{
  "facter": {
    "name": "facter",
    "version": "4.11.0",
    "dependencies": {
      "hocon": "~> 1.3",
      "thor": ">= 1.0.1, < 1.3"
    },
    "source": {
      "type": "rubygems",
      "remotes": [
        "https://rubygems-puppetcore.puppet.com/"
      ]
    },
    "consumer_paths": [
      "bolt -> puppet -> facter",
      "puppet -> facter",
      "puppet_litmus -> bolt -> puppet -> facter"
    ],
    "direct_consumers": [
      "puppet"
    ]
  }
}
➜  gempath git:(add_full_gem) ✗ 
```

### gempath generate

```bash
# Generate a minimal Gemfile for a specific gem
gempath generate --name thor

# Generate a Gemfile with a specific Ruby version
gempath generate --name thor --ruby-version 3.2.0

# Generate from a specific Gemfile.lock
gempath generate --name thor --filepath /path/to/Gemfile.lock
```

The `generate` command creates a clean, organized Gemfile that:

- Groups gems by their source (rubygems.org, custom sources, git, path)
- Maintains proper version constraints
- Follows Bundler's conventions for source blocks

For example, run the following command from the root of the repository:

```ruby
➜  gempath git:(add_full_gem) ✗ gempath generate --name facter --filepath spec/fixtures/sample.lock 
source 'https://rubygems.org'

source 'https://rubygems-puppetcore.puppet.com/' do
  gem 'facter', '4.11.0'
end

source 'https://rubygems.org/' do
  gem 'hocon', '~> 1.3'
  gem 'thor', '>= 1.0.1, < 1.3'
end
➜  gempath git:(add_full_gem) 
```

This is particularly useful when you need to:

- Troubleshoot issues with a specific gem
- Set up an isolated test environment
- Work on a gem without interference from other dependencies
- Understand gem sources and their organization

## Understanding the Output

- `dependencies`: Lists all gems that this gem directly depends on, including their versions
- `direct_consumers`: Shows which gems directly use this gem as a dependency
- `consumer_paths`: Shows all the dependency paths that lead to this gem, helping you understand why it's in your project
- `source`: Indicates where the gem comes from (rubygems.org, a git repository, or a local path)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gavindidrichsen/gempath.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
