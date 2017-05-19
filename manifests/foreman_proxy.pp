# This class can be used install user foreman_proxy properties
#
# @example when declaring the foreman_proxy class
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
  if $protocol == 'https' {
    $http = false
    $port = 8443
    $ssl  = true
  } else {
    $http = true
    $port = 8000
    $ssl  = false
  }
  class { '::foreman_proxy':
    bmc                   => false,
    dhcp                  => false,
    dns                   => false,
    foreman_base_url      => "${protocol}://${foreman_host}",
    http                  => $http,
    http_port             => $port,
    logs                  => true,
    logs_listen_on        => $protocol,
    oauth_consumer_key    => $oauth_consumer_key,
    oauth_consumer_secret => $oauth_consumer_secret,
    puppetca              => $puppetca,
    puppetca_listen_on    => $protocol,
    puppet                => true,
    puppet_listen_on      => $protocol,
    registered_name       => $::fqdn,
    registered_proxy_url  => "${protocol}://${::fqdn}:${port}",
    ssl                   => $ssl,
    ssl_port              => 8443,
    tftp                  => false,
    trusted_hosts         => [$::fqdn, $foreman_host],
    version               => $version,
  }
}