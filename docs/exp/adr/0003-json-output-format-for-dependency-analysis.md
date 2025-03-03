# 3. JSON Output Format for Dependency Analysis

Date: 2025-03-03

## Status

Accepted

## Context

When analyzing gem dependencies, we need a clear way to understand both the dependencies of a gem and what other gems consume it. The bundler-why plugin provides an excellent model for understanding ancestor consumers of a gem, which helps in troubleshooting and analyzing Gemfile.lock files.

We need to output complex data structures that show:

- Gem metadata (name, version, source)
- Dependencies (what the gem needs)
- Consumer paths (chains of gems that lead to this gem)
- Direct consumers (immediate parent gems)

This bidirectional view (both dependencies and consumers) is crucial for:

- Troubleshooting dependency conflicts
- Understanding why a gem is included
- Analyzing potential impact of updates
- Finding opportunities for dependency cleanup

The output format needs to be:

- Human-readable
- Machine-parseable
- Easy to process with common tools
- Well-structured

## Decision

We have chosen JSON as the output format for dependency analysis results, inspired by the clarity of bundler-why's output but extending it to show both upstream and downstream relationships:

1. Output will be structured as a JSON object with gem names as keys
2. Each gem entry will contain:
   - Basic metadata (name, version)
   - Source information
   - Array of dependencies (downstream relationships)
   - Array of consumer paths (full upstream chains)
   - Array of direct consumers (immediate upstream relationships)
3. The consumer paths will show the complete chain of dependencies (like bundler-why)
4. Output will be pretty-printed by default for easy reading
5. The structure allows for both quick lookups (direct consumers) and deep analysis (full paths)

## Consequences

### Positive

- Universal format supported by all programming languages
- Easy to parse and process programmatically
- Human-readable when pretty-printed
- Can be easily transformed into other formats
- Works well with common Unix tools (jq, grep)

### Negative

- More verbose than simpler formats
- Pretty-printing increases output size
- No support for comments or documentation within the output
- May need additional processing for complex queries
