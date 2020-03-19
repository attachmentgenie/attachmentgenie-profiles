# This class can be used install user foreman_proxy properties
#
# @example when declaring the foreman_proxy class
#  class { '::profiles::puppet::foreman_proxy': }
#
# @param foreman_host          Foreman fqdn.
# @param oauth_consumer_key    oauth_consumer_key.
# @param oauth_consumer_secret oauth_consumer_secret.
# @param manage_sudoersd       Whether to manage File['/etc/sudoers.d'] or not.
# @param protocol              Protocol to reach Foreman.
# @param puppetca              Is there a CA on this node.
# @param version               What version should be installed.
class profiles::puppet::foreman_proxy (
  String $foreman_host = 'foreman',
  Boolean $manage_sudoersd = true,
  String$oauth_consumer_key = 'secret',
  String $oauth_consumer_secret = 'secret',
  String $protocol = 'https',
  Boolean $puppetca = false,
  String $version = 'present',
) {
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
    manage_sudoersd       => $manage_sudoersd,
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

  Foreman::Repos <||> -> Package['foreman-proxy']

  case $::osfamily {
    'debian': {}
    'RedHat': {}
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
