# 3. Group Gems by Source in Generated Gemfiles

Date: 2025-03-03

## Status

Accepted

## Context

When generating Gemfiles for gems and their dependencies, we need to ensure that:
1. All gems can be properly resolved and installed
2. The source of each gem is clear and explicit
3. The output follows Ruby community conventions
4. The Gemfile is clean and maintainable

## Decision

We will group gems by their source in the generated Gemfile:

1. Default source (rubygems.org) is always declared first
2. Gems from custom sources are grouped in `source` blocks
3. Path-based gems use the `path:` option
4. Git-based gems are grouped in `git` blocks
5. Proper indentation is maintained for all blocks

Example:
```ruby
source 'https://rubygems.org'

source 'https://custom-source.com' do
  gem 'special-gem', '1.0.0'
end

gem 'path-gem', path: '../path/to/gem'

git 'https://github.com/org/repo' do
  gem 'git-gem'
end
```

## Consequences

### Positive

- Clear organization of gems by their source
- Follows Bundler's conventions for source blocks
- Makes troubleshooting easier by showing gem origins
- Improves maintainability with logical grouping
- Preserves all necessary source information
- Makes it obvious which gems come from non-standard sources

### Negative

- Slightly more complex code to generate the output
- May produce longer Gemfiles compared to flat lists
- Requires understanding of different source types

## References

- [Bundler documentation on source blocks](https://bundler.io/guides/gemfile.html#source-blocks)
- [Ruby community conventions for Gemfile organization](https://bundler.io/guides/gemfile_ruby.html)
