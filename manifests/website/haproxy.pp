# This class can be used install haproxy
#
# @example when declaring the haproxy class
#  class { '::profiles::website::haproxy': }
#
# @param listeners listeners to configure.
# @param members   Balance members to configure.
class profiles::website::haproxy (
  Hash $listeners = {},
  Hash $members = {},
) {
  class { '::haproxy': }
  create_resources('::haproxy::listen', $listeners)
  create_resources('@@haproxy::balancermember', $members)
}
