# 1. Separate CLI from Core Functionality

Date: 2025-03-03

## Status

Accepted

## Context

When building a Ruby gem that provides both a command-line interface and programmatic functionality, we need to decide how to structure the codebase. The main considerations are:

- Maintainability of the codebase
- Ability to test components independently
- Potential for reuse in other contexts
- Clear separation of concerns

## Decision

We have decided to implement a clean separation between CLI code and core functionality:

1. `bin/gempath`: A thin executable that only requires and starts the CLI
2. `lib/gempath/cli.rb`: Thor CLI code with self-documenting commands using Thor's desc/long_desc system
3. `lib/gempath.rb`: Core functionality with no CLI dependencies

## Consequences

### Positive

- Improved maintainability through single responsibility principle
- Better testability with separate CLI and core tests
- Core functionality can be used without CLI dependencies
- Easier to change CLI framework if needed
- Clear boundaries between user interface and business logic
- Self-documenting CLI through Thor's built-in help system
- Documentation stays in sync with code automatically

### Negative

- Slightly more complex initial setup
- Need to maintain clear interface between CLI and core
- Additional files and directories in project structure
