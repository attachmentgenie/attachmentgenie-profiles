class profiles::memcached (
  $listen_ip  = '127.0.0.1',
  $max_memory = '50%',
) {
  class { '::memcached':
    listen_ip  => $listen_ip,
    max_memory => $max_memory,
  }
}