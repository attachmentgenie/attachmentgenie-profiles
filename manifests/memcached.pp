# This class can be used install user memcached properties
#
# @example when declaring the memcache class
#  class { '::profiles::memcached': }
#
# @param listen_ip (String) interface to bind to.
# @param max_memory (String) Maximum Ram memcached can use.
class profiles::memcached (
  $listen_ip  = '127.0.0.1',
  $max_memory = '50%',
) {
  class { '::memcached':
    listen_ip  => $listen_ip,
    max_memory => $max_memory,
  }
}