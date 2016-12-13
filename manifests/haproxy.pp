# This class can be used install haproxy
#
# @example when declaring the haproxy class
#  class { '::profiles::haproxy': }
#
# @param listeners (Hash) listeners to configure.
# @param members (Hash) Balance members to configure.
class profiles::haproxy (
  $listeners = {},
  $members   = {},
) {
  class { '::haproxy': }
  create_resources('::haproxy::listen', $listeners)
  create_resources('@@haproxy::balancermember', $members)
}