# This class can be used to setup a bare minimum node, on top of which we can add the required technology stack.
#
# @example when declaring the bootstrap class
#  class { '::profiles::bootstrap': }
#
# @param accounts Manage accounts on this node.
# @param fail2ban Manage fail2ban on this node.
# @param firewall Manage the firewall on this node.
# @param ntp      Manage the time settings for this node.
# @param puppet   Manage puppet on this node.
# @param repos    Manage repositories on this node.
# @param ssh      Manage ssh on this node.
class profiles::bootstrap (
  Boolean $accounts = false,
  Boolean $dnsmasq = false,
  Boolean $fail2ban = false,
  Boolean $firewall = false,
  Boolean $ntp      = false,
  Boolean $puppet   = false,
  Boolean $repos    = false,
  Boolean $ssh      = false,
) {
  if $accounts{
    class { '::profiles::bootstrap::accounts': }
  }
  if $dnsmasq {
    class { '::profiles::bootstrap::dnsmasq': }
  }
  if $firewall {
    if $fail2ban {
      class { '::profiles::bootstrap::fail2ban': }
    }
    class { '::profiles::bootstrap::firewall': }
  }
  if $ntp {
    class { '::profiles::bootstrap::time': }
  }
  if $puppet {
    class { '::profiles::bootstrap::puppet': }
  }
  if $repos {
    class { '::profiles::bootstrap::repositories': }
  }
  if $ssh {
    class { '::profiles::bootstrap::ssh': }
  }
}
