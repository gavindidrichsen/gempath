# Generating Minimal Gemfiles

## Learning Objectives

After completing this tutorial, you will be able to:

- Generate minimal Gemfiles for specific gems
- Organize gems by their source
- Include Ruby version requirements
- Handle path-based and custom source gems

## Prerequisites

Before starting this tutorial, you should have:

- Ruby installed on your system
- The gempath repository checked out locally
- Basic familiarity with Ruby gems and Bundler

## Tutorial

### 1. Setting Up

First, let's use the sample Gemfile.lock that comes with the repository. From the root of your checked-out gempath repository:

```bash
# Make sure you're in the gempath repository directory
cd gempath

# We'll use the sample Gemfile.lock provided in spec/fixtures
ls spec/fixtures/sample.lock
```

### 2. Basic Gemfile Generation

Let's start by generating a minimal Gemfile for the `puppet` gem:

```bash
# Generate a Gemfile for puppet and its dependencies
gempath generate --name puppet --filepath spec/fixtures/sample.lock
```

This produces a clean, organized Gemfile:

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

Notice how:

- The default rubygems.org source is always first
- Gems from custom sources are grouped in `source` blocks
- Version constraints are preserved
- Dependencies are properly organized

### 3. Working with Path Sources

Let's try a gem with a path source:

```bash
gempath generate --name diataxis --filepath spec/fixtures/sample.lock
```

This produces:

```ruby
source 'https://rubygems.org'

gem 'diataxis', path: '/path/to/diataxis'
```

### 4. Adding Ruby Version Requirements

You can also specify a Ruby version:

```bash
gempath generate --name puppet --filepath spec/fixtures/sample.lock --ruby-version 3.2.0
```

Produces:

```ruby
ruby '3.2.0'

source 'https://rubygems.org'

source 'https://rubygems-puppetcore.puppet.com/' do
  gem 'puppet', '8.11.0'
  # ... dependencies
end
```

## What We've Learned

In this tutorial, you've learned how to:

- Generate minimal Gemfiles for specific gems
- Handle different gem sources (rubygems.org, custom servers, paths)
- Preserve version constraints
- Include Ruby version requirements
- Organize gems by their source for better maintainability
