# This class can be used install cache components.
#
# @example when declaring the cache class
#  class { '::profiles::cache': }
#
# @param memcached Manage memcached on this node.
class profiles::cache (
  Boolean $memcached = false,
) {
  if $memcached {
    class { '::profiles::cache::memcached': }
  }
}
