# Analyzing Gem Dependencies

## Learning Objectives

After completing this tutorial, you will be able to:

- Use Gempath to analyze dependencies in a Gemfile.lock
- Understand different types of gem relationships (dependencies, consumers, paths)
- Interpret gem source information
- Compare simple and complex dependency structures

## Prerequisites

Before starting this tutorial, you should have:

- Ruby installed on your system
- The gempath repository checked out locally
- Basic familiarity with Ruby gems and Bundler

## Tutorial

### 1. Setting Up

First, let's analyze the sample Gemfile.lock that comes with the repository. From the root of your checked-out gempath repository:

```bash
# Make sure you're in the gempath repository directory
cd gempath

# We'll use the sample Gemfile.lock provided in spec/fixtures
ls spec/fixtures/sample.lock
```

### 2. Getting Help

Gempath provides comprehensive built-in help. Let's explore the available commands and options:

```bash
# Show all available commands (note: descriptions may be truncated for formatting)
gempath help

# Get detailed help for the analyze command (shows full description)
gempath help analyze
# or
gempath analyze --help
```

The help output shows you all available options and includes examples for common use cases.

### 3. Basic Analysis

Now that we understand the available options, let's analyze all gems in the sample Gemfile.lock:

```bash
gempath analyze -f spec/fixtures/sample.lock
```

This will output a JSON containing information about all gems. The output might be overwhelming at first, so let's focus on specific gems.

### 4. Analyzing a Simple Gem

Let's analyze the `base64` gem, which has multiple consumers but no dependencies of its own:

```bash
gempath analyze -f spec/fixtures/sample.lock -n base64
```

You'll see output like:

```json
{
  "base64": {
    "name": "base64",
    "version": "0.2.0",
    "dependencies": [],
    "source": {
      "type": "rubygems",
      "remotes": [
        "https://rubygems.org/"
      ]
    },
    "consumer_paths": [
      "puppet_litmus -> bolt -> CFPropertyList -> base64",
      "puppet_litmus -> bolt -> puppet -> CFPropertyList -> base64",
      "puppet_litmus -> bolt -> winrm -> rubyntlm -> base64",
      "puppet_litmus -> bolt -> winrm-fs -> winrm -> rubyntlm -> base64"
    ],
    "direct_consumers": [
      "CFPropertyList",
      "rubyntlm"
    ]
  }
}
```

Let's break down what we're seeing:

- The gem has no dependencies (empty `dependencies` array)
- It's used directly by two gems: `CFPropertyList` and `rubyntlm`
- There are multiple paths through which it's included in the project
- It comes from rubygems.org

### 5. Analyzing a Complex Gem

Now let's look at `bolt`, which has many dependencies and consumers:

```bash
gempath analyze -f spec/fixtures/sample.lock -n bolt
```

Notice how:

- It has multiple direct dependencies
- It's used by `puppet_litmus`
- The dependency paths are more complex

### 6. Understanding Different Sources

Let's look at a gem from a different source. The `puppet` gem comes from a custom RubyGems server:

```bash
gempath analyze -f spec/fixtures/sample.lock -n puppet
```

Pay attention to:

- The `source` information showing `https://rubygems-puppetcore.puppet.com/`
- The specific version requirements from its consumers
- How it fits into the larger dependency graph

## What We've Learned

In this tutorial, you've learned how to:

- Analyze all gems in a Gemfile.lock
- Look at specific gems and their relationships
- Understand dependency paths
- See where gems are sourced from
- Identify direct consumers of a gem

This output is particularly useful when:

- Troubleshooting issues with a specific gem
- Setting up a minimal test environment
- Working on a gem in isolation
- Understanding gem sources and their relationships
- Creating clean, maintainable Gemfiles

## Next Steps

Try these exercises:

1. Analyze these gems from the sample.lock file:
   - `thor` (used by multiple gems)
   - `rspec` (has a clear dependency chain)
   - `puppet_litmus` (the main project gem)

2. Generate minimal Gemfiles:
   - Create a Gemfile for `puppet` (notice the different source)
   - Compare Gemfiles generated for different gems
   - Try adding different Ruby versions

Each exercise will help you understand different aspects of:
- Dependency relationships in Ruby projects
- How to isolate gems for testing and development
- Managing gem sources and version constraints

For more advanced usage:

- Compare dependencies between different versions of your Gemfile.lock
- Look for gems that might be candidates for removal (few consumers, old versions)
- Identify dependency chains that might be simplified
- Create isolated test environments using generated Gemfiles

See also: [Generating Minimal Gemfiles](tutorial_generating_minimal_gemfile.md) for a detailed guide on creating isolated Gemfiles.
