# This class can be used install user foreman_proxy properties
#
# @example when declaring the apache class
#  class { '::profiles::foreman_proxy': }
#
# @param foreman_host (String) Foreman fqdn.
# @param protocol (String) Protocol to reach Foreman.
# @param puppetca (Boolean) Is there a CA on this node.
# @param version (String) What version should be installed.
class profiles::foreman_proxy (
  $foreman_host = 'foreman',
  $protocol     = 'https',
  $puppetca     = false,
  $version      = 'present',
) {
  class { '::foreman_proxy':
    foreman_base_url => "${protocol}://${foreman_host}",
    trusted_hosts    => [$::fqdn, $foreman_host],
    bmc              => false,
    dhcp             => false,
    dns              => false,
    puppetca         => $puppetca,
    registered_name  => $foreman_host,
    tftp             => false,
    version          => $version,
  }
}