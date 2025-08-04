# Release Checklist

Use this checklist to ensure a smooth release process:

## Pre-Release

- [ ] All desired features and fixes are merged to `main`
- [ ] Tests are passing locally: `bundle exec rake spec`
- [ ] RuboCop passes locally: `bundle exec rubocop`
- [ ] Gem builds successfully: `bundle exec rake build`
- [ ] Documentation is up to date
- [ ] Version number follows [Semantic Versioning](https://semver.org/)

## Release Prep

- [ ] Run the "Release Prep" workflow from GitHub Actions
  - [ ] Go to Actions tab → Release Prep → Run workflow
  - [ ] Enter the new version number (e.g., "1.0.0")
- [ ] Review the generated pull request:
  - [ ] Version bump is correct in `lib/gempath/version.rb`
  - [ ] CHANGELOG.md has been updated appropriately
  - [ ] All automated checks pass
- [ ] Merge the release prep pull request

## Release

- [ ] Ensure the release prep PR has been merged
- [ ] Run the "Release" workflow from GitHub Actions
  - [ ] Go to Actions tab → Release → Run workflow
- [ ] Verify the release completed successfully:
  - [ ] GitHub release was created with release notes
  - [ ] Gem was published to RubyGems.org
  - [ ] Gem was published to GitHub Packages (optional)

## Post-Release

- [ ] Verify the gem can be installed: `gem install gempath`
- [ ] Test the installed gem works as expected
- [ ] Announce the release (optional):
  - [ ] Update project README if needed
  - [ ] Share on social media, blog, etc.

## Secrets Required

Ensure these GitHub repository secrets are configured:

- [ ] `GEM_HOST_API_KEY` - Your RubyGems.org API key (required)
- [ ] `CODECOV_TOKEN` - Your Codecov token (optional, for coverage reporting)

## Troubleshooting

If something goes wrong:

1. **Release Prep fails**: Check the workflow logs and ensure your repo has sufficient history for changelog generation
2. **Release fails**: Verify your `GEM_HOST_API_KEY` is correct and has push permissions
3. **Gem push fails**: Check if the version already exists on RubyGems.org

## Version Numbering Guide

Follow [Semantic Versioning](https://semver.org/):

- **Major (X.0.0)**: Breaking changes
- **Minor (0.X.0)**: New features, backwards compatible
- **Patch (0.0.X)**: Bug fixes, backwards compatible

Examples:
- `0.1.0` → `0.1.1` (bug fix)
- `0.1.1` → `0.2.0` (new feature)
- `0.2.0` → `1.0.0` (breaking change or first stable release)
