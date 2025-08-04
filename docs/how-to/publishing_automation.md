# Publishing Your Gem with GitHub Automation

This repository includes GitHub Actions workflows to automate the gem publishing process, inspired by the puppetlabs/cat-github-actions workflows but adapted for personal use.

## Prerequisites

Before you can use these workflows, you need to set up a few things:

### 1. RubyGems API Key

To publish to RubyGems.org, you need to set up an API key:

1. Go to https://rubygems.org/settings/edit
2. Create an API key with the scope you need (usually "Push rubygems")
3. In your GitHub repository, go to Settings → Secrets and variables → Actions
4. Add a new repository secret named `GEM_HOST_API_KEY` with your RubyGems API key

### 2. Optional: Codecov Integration

For enhanced coverage reporting:

1. Go to https://codecov.io and sign up/login with your GitHub account
2. Add your repository to Codecov
3. Get your repository's Codecov token
4. Add it as a repository secret named `CODECOV_TOKEN`

## Available Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:** Push to main/master/development branches, pull requests to main/master

**What it does:**
- Runs tests on Ruby 3.1 and 3.2
- Runs RuboCop linting
- Generates coverage reports
- Uploads coverage to Codecov (if configured)
- Deploys coverage reports to GitHub Pages

### 2. Release Prep Workflow (`.github/workflows/release_prep.yml`)

**Triggers:** Manual trigger via GitHub Actions tab

**What it does:**
- Updates the version in your `lib/gempath/version.rb` file
- Generates/updates the CHANGELOG.md using PR/issue labels
- Runs tests and linting to ensure everything works
- Builds the gem to verify it can be built
- Creates a release preparation pull request

**How to use:**
1. Go to your repository's Actions tab
2. Select "Release Prep" workflow
3. Click "Run workflow"
4. Enter the version you want to release (e.g., "1.0.0")
5. Review and merge the generated pull request

### 3. Release Workflow (`.github/workflows/release.yml`)

**Triggers:** Manual trigger via GitHub Actions tab

**What it does:**
- Runs final tests and linting
- Builds the gem
- Creates a GitHub release with generated release notes
- Publishes the gem to RubyGems.org
- Publishes the gem to GitHub Packages

**How to use:**
1. Ensure your release prep PR has been merged
2. Go to your repository's Actions tab
3. Select "Release" workflow
4. Click "Run workflow"
5. The workflow will automatically detect the version from your gemspec

## Changelog Generation

The workflows use the `gh-changelog` extension to automatically generate changelog entries based on:

- Pull request titles and descriptions
- Issue labels
- Git commit messages

### Label Mapping

The changelog generator maps GitHub labels to changelog sections:

- **Added:** enhancement, feature, new
- **Changed:** backwards-incompatible, breaking-change, change
- **Fixed:** bug, bugfix, fix
- **Security:** security, vulnerability
- **Deprecated:** deprecation
- **Removed:** removal

### Excluded Labels

These labels won't appear in the changelog:
- maintenance
- dependencies
- wontfix
- duplicate
- invalid

## Release Process

Here's the recommended process for releasing a new version:

1. **Develop and test your changes** on feature branches
2. **Create and merge pull requests** to main with appropriate labels
3. **Run the Release Prep workflow** with your desired version number
4. **Review the generated pull request** to ensure the changelog and version bump look correct
5. **Merge the release prep pull request**
6. **Run the Release workflow** to publish the gem

## Differences from puppetlabs/cat-github-actions

While inspired by the puppetlabs workflows, these have been adapted for personal use:

1. **Repository ownership check:** Changed from `puppetlabs` to `gavindidrichsen`
2. **Ruby version:** Updated to use Ruby 3.2 as primary version
3. **Additional verification:** Added gem building verification in release prep
4. **Enhanced CI:** Added matrix testing across Ruby 3.1 and 3.2
5. **Development branch:** Added support for development branch in CI
6. **Better error handling:** Made Codecov upload optional to prevent failures

## Troubleshooting

### Release Prep Fails

- Check that your repository has proper PR/issue history for changelog generation
- Ensure your version.rb file is in the expected location (`lib/gempath/version.rb`)
- Verify tests pass locally before running the workflow

### Release Fails

- Ensure `GEM_HOST_API_KEY` secret is set correctly
- Check that the gem builds successfully locally with `bundle exec rake build`
- Verify your gemspec is valid

### Coverage Issues

- Codecov upload is optional; the workflow will continue if it fails
- Check that your test suite generates coverage data in the expected format
