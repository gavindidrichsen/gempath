# Generating Minimal Gemfiles

## Learning Objectives

After completing this tutorial, you will be able to:

- Generate minimal Gemfiles for specific gems
- Handle gems from multiple sources
- Include proper version constraints
- Specify Ruby version requirements

## Prerequisites

Before starting this tutorial, you should have:

- Ruby installed on your system
- The gempath repository checked out locally
- Basic familiarity with Bundler and Gemfiles

## Tutorial

### 1. Getting Help

Let's start by exploring the generate command:

```bash
# Show help for the generate command
gempath help generate
```

This shows all available options, including:

- `--name`: The gem to generate a Gemfile for (required)
- `--filepath`: Path to the Gemfile.lock (default: ./Gemfile.lock)
- `--ruby-version`: Ruby version to use

### 2. Basic Gemfile Generation

Let's generate a Gemfile for a simple gem like `thor`:

```bash
# Use the sample Gemfile.lock
gempath generate -f spec/fixtures/sample.lock -n thor
```

The output will be a minimal Gemfile containing:

- The gem source (rubygems.org)
- The gem and its version
- Any direct dependencies (thor has none)

### 3. Handling Multiple Sources

Now let's try a more complex case with `puppet`, which comes from a custom gem source:

```bash
gempath generate -f spec/fixtures/sample.lock -n puppet
```

Notice how the generated Gemfile:

- Groups gems by their source
- Uses source blocks for custom gem servers
- Maintains all version constraints

```ruby
source 'https://rubygems.org'

source 'https://rubygems-puppetcore.puppet.com/' do
  gem 'puppet', '8.11.0'
  gem 'facter', '>= 4.3.0, < 5'
end

source 'https://rubygems.org/' do
  gem 'CFPropertyList', '>= 3.0.6, < 4'
  gem 'concurrent-ruby', '~> 1.0'
  # ... other dependencies
end
```

### 4. Specifying Ruby Version

You can also generate a Gemfile with a specific Ruby version:

```bash
gempath generate -f spec/fixtures/sample.lock -n puppet --ruby-version 3.2.0
```

This adds a Ruby version requirement to the Gemfile:

```ruby
ruby '3.2.0'

source 'https://rubygems.org'
# ... rest of the Gemfile
```

### 5. Complex Dependencies

Let's look at a gem with many dependencies, like `rspec`:

```bash
gempath generate -f spec/fixtures/sample.lock -n rspec
```

The generated Gemfile will include:

- All direct dependencies (rspec-core, rspec-expectations, rspec-mocks)
- Their version constraints
- Any shared dependencies

## What We've Learned

In this tutorial, you've learned how to:

- Generate minimal Gemfiles for specific gems
- Handle gems from multiple sources
- Include proper version constraints
- Add Ruby version requirements
- Deal with complex dependency chains

## Next Steps

Try these exercises:

1. Generate Gemfiles for different types of gems:
   - A gem with git dependencies
   - A gem with path dependencies
   - A gem from a private source

2. Compare generated Gemfiles:
   - Look at how version constraints differ
   - See how sources are organized
   - Understand dependency grouping

3. Use generated Gemfiles:
   - Create isolated test environments
   - Verify gem compatibility
   - Debug dependency issues
