# 6. Collect additional gem metadata from bundle info

Date: 2025-03-20

## Status

Proposed

## Context

Sometimes, it is unclear who owns a particular gem—whether it is maintained by Puppet Labs or another organization. The `bundle info` command provides useful metadata, such as the `homepage` and `summary`, which can help distinguish the actual owner of a gem. However, calling bundle info for each gem can be expensive in terms of performance.

## Decision

Therefore, I decided to add an optional enhancement to the gempath output.  By default, gempath will return only the original information extracted from Gemfile.lock.  When the `-d` flag is provided, however, then gempath will invoke `bundle info` for each gem and include the additional `summary` and `homepage` metadata in the output.

## Consequences

This change simplifies the process of identifying gem ownership and understanding dependencies. Users can now easily access the homepage and summary of a gem, which aids in troubleshooting and decision-making. However, since the `bundle info` call can be resource-intensive, the optional flag ensures that users can choose when to retrieve this additional data, thus balancing performance with the need for detailed information.
