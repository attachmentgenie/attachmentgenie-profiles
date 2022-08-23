# This class can be used install user memcached properties
#
# @example when declaring the memcache class
#  class { '::profiles::cache::memcached': }
#
# @param listen_ip  Interface to bind to.
# @param max_memory Maximum Ram memcached can use.
class profiles::cache::memcached (
  Optional[Stdlib::Compat::Ip_address] $listen_ip = '127.0.0.1',
  Variant[Integer, String] $max_memory = '50%',
) {
  class { 'memcached':
    listen_ip  => $listen_ip,
    max_memory => $max_memory,
  }
}
