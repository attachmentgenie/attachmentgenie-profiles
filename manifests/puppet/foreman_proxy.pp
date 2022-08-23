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
  Boolean $manage_bmc = false,
  Boolean $manage_dhcp = false,
  Boolean $manage_dns = false,
  Boolean $manage_sudoersd = true,
  String$oauth_consumer_key = 'secret',
  String $oauth_consumer_secret = 'secret',
  String $protocol = 'https',
  Boolean $puppet = true,
  Boolean $puppetca = false,
  Boolean $tftp = false,
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
  class { 'foreman_proxy':
    bmc                   => $manage_bmc,
    dhcp                  => $manage_dhcp,
    dns                   => $manage_dns,
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
    puppet                => $puppet,
    puppet_listen_on      => $protocol,
    registered_name       => $facts['networking']['fqdn'],
    registered_proxy_url  => "${protocol}://${facts['networking']['fqdn']}:${port}",
    ssl                   => $ssl,
    ssl_port              => 8443,
    tftp                  => $tftp,
    trusted_hosts         => [$facts['networking']['fqdn'], $foreman_host],
    version               => $version,
  }

  Foreman::Repos <||> -> Package['foreman-proxy']
}
