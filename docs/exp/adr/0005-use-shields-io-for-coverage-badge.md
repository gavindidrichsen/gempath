# 5. Use shields.io for coverage badge

Date: 2025-03-04

## Status

Proposed

## Context

We need to display our test coverage percentage in the README to provide transparency about code quality. Initially, we attempted to use `simplecov-badge` which generates a badge SVG using ImageMagick. However, this approach had several drawbacks:

1. Required ImageMagick as a system dependency
2. Added complexity to our CI workflow
3. Required additional gem dependencies (`simplecov-badge`, `simplecov-html`, `simplecov-json`)
4. Generated badge was not as visually consistent with other badges

## Decision

We will use shields.io to generate our coverage badge instead of `simplecov-badge`. The badge URL will be:

```bash
https://img.shields.io/badge/coverage-87%25-green.svg
```

This approach:

1. Uses a trusted, widely-used badge service
2. Requires no additional system dependencies
3. Produces badges that match other common GitHub badges
4. Still links to our detailed coverage report on GitHub Pages

## Consequences

Positive:

- Simpler CI workflow (no ImageMagick installation needed)
- Fewer gem dependencies to maintain
- Consistent badge styling with other GitHub badges
- No local system dependencies required
- Faster CI builds

Negative:

- Badge must be manually updated when coverage changes
- Relies on an external service (shields.io)
- Not automatically synchronized with actual coverage numbers

We accept these trade-offs because:

1. Coverage numbers don't change frequently
2. Shields.io is a stable, widely-used service
3. The simplification of our build process outweighs the manual update requirement
