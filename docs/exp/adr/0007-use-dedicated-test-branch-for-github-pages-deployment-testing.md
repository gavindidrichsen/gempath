---
tags:
  - best-practice
  - github
  - ci-cd
  - deployment
  - testing
  - permissions
  - github-actions
date: 2025-08-01
status: accepted
---

# 7. Use dedicated test branch for GitHub Pages deployment testing

Date: 2025-08-01

## Status

Accepted

## Context

We experienced a GitHub Actions failure after merging a PR that added GitHub Pages deployment functionality. The failure occurred because the coverage job lacked the required `id-token: write` permission for Pages deployment. This failure only manifested after merging to the main branch, not during PR testing, because:

1. Pages deployment steps are conditionally executed only on main/master branches
2. Job-level permissions completely override (not merge with) global permissions in GitHub Actions
3. The coverage job defined its own permissions block without including the Pages-required permissions

This created a testing gap: we couldn't validate the Pages deployment functionality before merging changes to production branches. We needed a way to test Pages deployment changes safely without:

- Affecting production deployments
- Requiring temporary modifications to workflow files
- Waiting until after merge to discover permission issues

## Decision

We will use a dedicated test branch named `test-gh-pages-publish` that:

1. **Triggers the CI workflow** - Added to the `on.push.branches` list
2. **Enables Pages deployment** - Included in the `DEPLOY_CONDITION` environment variable
3. **Provides clear intent** - The branch name explicitly indicates its testing purpose
4. **Requires no cleanup** - Can remain in the workflow permanently without affecting production

The implementation uses a DRY approach with an environment variable `DEPLOY_CONDITION` that controls all three Pages deployment steps, making it easy to maintain and modify.

## Consequences

### What becomes easier

- **Safe testing** of Pages deployment changes before merging to main
- **Validation** of permissions and deployment configuration
- **Debugging** deployment issues in isolation
- **Self-documenting** workflows with clear testing intentions
- **Reusable testing** - the test branch can be used whenever needed

### What becomes more difficult

- **Slightly more complex** workflow configuration (minimal impact)
- **Additional branch** to manage (but lightweight since it's just for testing)
- **Potential confusion** for new contributors (mitigated by clear naming and comments)

### Risk mitigation

- Clear naming convention prevents accidental production use
- Comments in workflow explain the purpose
- Test deployments won't affect main branch coverage reports
- Can be easily removed if testing approach changes

### Alternative approaches considered

1. **Temporary development branch inclusion** - Rejected due to need for manual cleanup
2. **Using "master" branch** - Rejected due to production confusion
3. **Manual testing in forks** - Rejected due to complexity and permissions differences

## Related Topics

- **Best Practices**: GitHub Actions, CI/CD, Deployment
- **Technologies**: GitHub Pages, Ruby, Testing
- **Context**: Release Process, Permissions Management
