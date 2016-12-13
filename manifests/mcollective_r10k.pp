# This class can be used install user mcollective_r10k properties
#
# @example when declaring the apache class
#  class { '::profiles::mcollective_r10k': }
#
# @param agent_path (String) Location where agent is installed.
# @param app_path (String) Location where application is installed.
class profiles::mcollective_r10k (
  $agent_path = '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective/agent',
  $app_path   = '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective/application',
) {
  validate_string(
    $agent_path,
    $app_path,
  )
  class { '::r10k::mcollective':
    agent_path => $agent_path,
    app_path   => $app_path,
  }
}