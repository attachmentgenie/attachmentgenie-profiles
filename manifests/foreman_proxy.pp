# This class can be used install user foreman_proxy properties
#
# @example when declaring the apache class
#  class { '::profiles::foreman_proxy': }
#
# @param foreman_host (String) Foreman fqdn.
# @param oauth_consumer_key (String) oauth_consumer_key.
# @param oauth_consumer_secret (String) oauth_consumer_secret.
# @param protocol (String) Protocol to reach Foreman.
# @param puppetca (Boolean) Is there a CA on this node.
# @param version (String) What version should be installed.
class profiles::foreman_proxy (
  $foreman_host          = 'foreman',
  $oauth_consumer_key    = 'secret',
  $oauth_consumer_secret = 'secret',
  $protocol              = 'https',
  $puppetca              = false,
  $version               = 'present',
) {
  validate_bool(
    $puppetca,
  )
  validate_string(
    $foreman_host,
    $oauth_consumer_key,
    $oauth_consumer_secret,
    $protocol,
    $version,
  )
  class { '::foreman_proxy':
    foreman_base_url      => "${protocol}://${foreman_host}",
    trusted_hosts         => [$::fqdn, $foreman_host],
    bmc                   => false,
    dhcp                  => false,
    dns                   => false,
    logs                  => true,
    oauth_consumer_key    => $oauth_consumer_key,
    oauth_consumer_secret => $oauth_consumer_secret,
    puppetca              => $puppetca,
    registered_name       => $foreman_host,
    registered_proxy_url  => "${protocol}://${foreman_host}",
    tftp                  => false,
    version               => $version,
  }
}