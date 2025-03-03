# 4. Store Sample Lock Files in spec/fixtures

Date: 2025-03-03

## Status

Accepted

## Context

For testing and documentation purposes, we need sample Gemfile.lock files that demonstrate:

- Various gem dependency patterns
- Different source types (rubygems.org, custom servers)
- Complex dependency chains
- Multiple consumer paths

We need to decide where to store these files in a way that is:

- Consistent with Ruby community practices
- Accessible for both testing and documentation
- Clearly separated from actual project dependencies

## Decision

We will store sample Gemfile.lock files in the `spec/fixtures` directory:

1. Primary sample file will be `spec/fixtures/sample.lock`
2. Additional test cases can be added as needed (e.g., `spec/fixtures/complex.lock`)
3. Files will be versioned with the project
4. Documentation will reference these files for examples

## Consequences

### Positive

- Follows Ruby community conventions for test fixtures
- Files are available for both testing and documentation
- Clear separation from project's own Gemfile.lock
- Easy to add new test cases
- Version controlled with the project

### Negative

- Need to maintain sample files
- Must ensure samples stay relevant as features change
- Could be confused with actual project dependencies
- Increases repository size
