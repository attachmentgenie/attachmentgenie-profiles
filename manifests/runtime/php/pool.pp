# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#  class { '::profiles::bootstrap::firewall': }
#
# @param address    Ip to bind to.
# @param port       Port to bind to.
define profiles::runtime::php::pool (
  Stdlib::Ip_address $address = '127.0.0.1',
  Stdlib::Port::Unprivileged $port = 9000,
) {
  php::fpm::pool { $name:
    listen => "${address}:${port}",
  }

  if $address != '127.0.0.1' {
    profiles::bootstrap::firewall::entry { "100 allow fpm pool ${port}":
      port => $port,
    }
  }
}