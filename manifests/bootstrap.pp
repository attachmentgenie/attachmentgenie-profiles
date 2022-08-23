# This class can be used to setup a bare minimum node, on top of which we can add the required technology stack.
#
# @example when declaring the bootstrap class
#  class { '::profiles::bootstrap': }
#
class profiles::bootstrap (
  Boolean $accounts = false,
  Boolean $dnsmasq = false,
  Boolean $fail2ban = false,
  Boolean $firewall = false,
  Boolean $keepalive = false,
  Boolean $network = false,
  Boolean $ntp = false,
  Boolean $puppet = false,
  Boolean $repos = false,
  Boolean $resolv = false,
  Boolean $ssh = false,
) {
  if $accounts {
    class { 'profiles::bootstrap::accounts': }
  }
  if $dnsmasq {
    class { 'profiles::bootstrap::dnsmasq': }
  }
  if $firewall {
    if $fail2ban {
      class { 'profiles::bootstrap::fail2ban': }
    }
    class { 'profiles::bootstrap::firewall': }
  }
  if $keepalive {
    class { 'profiles::bootstrap::keepalive': }
  }
  if $network {
    class { 'profiles::bootstrap::network': }
  }
  if $ntp {
    class { 'profiles::bootstrap::time': }
  }
  if $puppet {
    class { 'profiles::bootstrap::puppet': }
  }
  if $repos {
    class { 'profiles::bootstrap::repositories': }
  }
  if $resolv {
    class { 'profiles::bootstrap::resolv': }
  }
  if $ssh {
    class { 'profiles::bootstrap::ssh': }
  }
}
