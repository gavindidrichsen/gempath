# 2. Use Thor for CLI Implementation

Date: 2025-03-03

## Status

Accepted

## Context

For implementing the command-line interface of gempath, we need a robust CLI framework that provides:

- Easy command and subcommand definition
- Built-in help text generation
- Option parsing and validation
- Error handling
- Wide adoption in the Ruby community
- Support for Unix-style command philosophy (each command does one thing well)

## Decision

We have chosen Thor as our CLI framework for the following reasons:

1. Thor is a mature, well-maintained library used by many popular Ruby tools (Rails, Bundler)
2. It provides a clean, class-based approach to defining commands
3. Excellent built-in help system:
   - Automatic help text generation from command descriptions
   - Long-form command descriptions for detailed usage via `help COMMAND`
   - Smart truncation of command descriptions in command list for consistent formatting
   - Dynamic help text that updates with code changes
   - Consistent help formatting across commands
4. Built-in support for:
   - Option parsing and validation
   - Error handling
   - Command namespacing
5. Supports Unix-style command philosophy:
   - Each command does one thing well (e.g., 'analyze' for dependency analysis, 'generate' for Gemfile creation)
   - Commands share common options where appropriate (--filepath, --name)
   - Consistent output formatting across commands
6. Facilitates structured output generation:
   - Organized Gemfile generation with proper source grouping
   - Hierarchical formatting with correct indentation
   - Consistent style following Ruby community conventions

## Consequences

### Positive

- Reduced boilerplate code for CLI implementation
- Consistent command-line interface
- Self-documenting commands through Thor's desc/long_desc system
- Help text automatically stays in sync with code
- Familiar tooling for Ruby developers
- Good documentation and community support
- Supports complex output formatting:
  - Source-grouped Gemfile generation
  - Proper indentation in blocks
  - Clean separation between different source types

### Negative

- Adds a runtime dependency
- Thor-specific code patterns required
- Migration cost if we need to change frameworks later
