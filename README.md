# attachmentgenie-profiles

[![Spec Tests](https://github.com/attachmentgenie/attachmentgenie-profiles/actions/workflows/spec.yml/badge.svg)](https://github.com/attachmentgenie/attachmentgenie-profiles/actions/workflows/spec.yml)
[![License](https://img.shields.io/github/license/attachmentgenie/attachmentgenie-profiles?stype=popout)](https://github.com/attachmentgenie/attachmentgenie-profiles/blob/master/LICENSE)

- [Description](#description)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Limitations](#limitations)
- [Development](#development)

## Description

Collection of profiles for tools I find useful, works together with [attachmentgenie-roles](https://github.com/attachmentgenie-roles)

## Usage

All options and configuration can be done through interacting with the parameters
on the main profiles class.
These are now documented via [Puppet Strings](https://github.com/puppetlabs/puppet-strings)

You can view example usage in [REFERENCE](REFERENCE.md).

## Reference

See [REFERENCE](REFERENCE.md).

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

### Running tests

This project contains tests for both rspec-puppet and litmus to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart:

```
pdk bundle install
pdk bundle exec rake 'litmus:provision_list[puppet6]'
pdk bundle exec rake 'litmus:install_agent[puppet6]'
pdk bundle exec rake litmus:install_module
pdk bundle exec rake litmus:acceptance:parallel
pdk bundle exec rake litmus:tear_down
