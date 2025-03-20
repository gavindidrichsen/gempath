# How to get homepage and summary info on gems

## Description

This guide shows how to add `bundle info` metadata for a gem, in particular the `homepage` and `summary`.  These extra bits of information are very useful to quickly identify the owner of a gem.  The gem may come from a common source like `https://rubygems.org`, but the owner may be something unexpected.  Therefore, this is a good way to get further clarity on your gems.

## Prerequisites

To get valid `homepage` and `summary` information, you must be analying an existing bundle installation.  In other words, the following assumes that you've done a `bundle install` of gems locally.

## Usage

For example, beneath a bundle installation, one of the included gems is `puppet-syntax`.  Notice that there are now 2 extra fields `homepage` and `summary`.

Doing `gempath analyze -n puppet-syntax` will return the normal set of information and nothing in the `homepage` or `summary` elements:

```json
{
  "puppet-syntax": {
    "name": "puppet-syntax",
    "version": "4.1.1",
    "homepage": "Homepage information is available when using the -d flag",
    "summary": "Summary information is available when using the -d flag",
    "dependencies": {
      "puppet": ">= 7, < 9",
      "rake": "~> 13.1"
    },
    "source": {
      "type": "rubygems",
      "remotes": [
        "https://rubygems.org/"
      ]
    },
    "consumer_paths": [
      "puppetlabs_spec_helper -> puppet-syntax"
    ],
    "direct_consumers": [
      "puppetlabs_spec_helper"
    ]
  }
}
```

However, adding the `-d` flag will trigger a call to `bundle info` for each gem analyzed.  For example, see the extra information added below:

Run `gempath analyze -n puppet-syntax -d`:

```json
{
  "puppet-syntax": {
    "name": "puppet-syntax",
    "version": "4.1.1",
    "homepage": "https://github.com/voxpupuli/puppet-syntax",
    "summary": "Syntax checks for Puppet manifests, templates, and Hiera YAML",
    "dependencies": {
      "puppet": ">= 7, < 9",
      "rake": "~> 13.1"
    },
    "source": {
      "type": "rubygems",
      "remotes": [
        "https://rubygems.org/"
      ]
    },
    "consumer_paths": [
      "puppetlabs_spec_helper -> puppet-syntax"
    ],
    "direct_consumers": [
      "puppetlabs_spec_helper"
    ]
  }
}
```

The `homepage` and `summary` are very useful for distinguishing the owner of a gem, i.e., `puppetlabs` or `voxpupuli`.
