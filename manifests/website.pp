# == Class: profiles::website
#
# This class can be used install website components
#
# === Examples
#
# @example when declaring the website class
#  class { '::profiles::website': }
#
# === Parameters
#
# @param apache      Manage apache on this node.
# @param haproxy     Manage haproxy on this node.
# @param letsencrypt Manage letsencrypt certificates on this node.
# @param nginx       Manage nginx on this node.
# @param traefik     Manage nginx on this node.
# @param uwsgi       Manage uwsgi on this node.
#
class profiles::website (
  Boolean $apache      = false,
  Boolean $haproxy     = false,
  Boolean $letsencrypt = false,
  Boolean $nginx       = false,
  Boolean $traefik     = false,
  Boolean $uwsgi       = false,
){
  if $apache {
    class { '::profiles::website::apache': }
  }

  if $haproxy {
    class { '::profiles::website::haproxy': }
  }

  if $letsencrypt {
    class { '::profiles::website::letsencrypt': }
  }

  if $nginx {
    class { '::profiles::website::nginx': }
  }

  if $traefik {
    class { '::profiles::website::traefik': }
  }

  if $uwsgi {
    class { '::profiles::website::uwsgi': }
  }
}
