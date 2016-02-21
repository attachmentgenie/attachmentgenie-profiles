#
class profiles::icinga (
  $is_server   = false,
) {
  stage { 'before':
    before => Stage['main'],
  }

  case $::osfamily {
    'RedHat': {
      if !defined(Class['::repoforge']) {
        class { '::repoforge':
          enabled => ['rpmforge'],
          stage   => before,
        }
      }
      if !defined(Class['::epel']) {
        class { '::epel':
          stage => before,
        }
      }
    }
    default: { }
  }

  if str2bool($is_server) {
    class { '::apache': }
    package { 'httpd-tools': }
  }
  class { 'icinga':
    icinga_vhost        => '/etc/httpd/conf.d/15-icinga.conf',
    server              => $is_server,
    hostgroups          => 'default',
    nrpe_allowed_hosts  => [ '127.0.0.1', '192.168.21.132' ],
    nrpe_server_address => $::ipaddress_eth1,
    plugins             => [
      'checkalldisks',
      'checkcron',
      'checkload',
      'checkntp',
      'checkping',
      'checkpuppet',
      'checkssh',
      'checkswap',
      'checktotalprocs',
      'checkzombie'],
  }

  icinga::user { 'dummy1':
    ensure   => present,
    password => 'default',
    email    => 'dummy1@example.com',
    pager    => '320000001';
  } ->
  icinga::group{ $::environment:
    members => 'dummy1',
  }

  Nagios_service {
    host_name           => $::fqdn,
    use                 => 'generic-service',
    notification_period => '24x7',
    target              => "${::icinga::targetdir}/services/${::fqdn}.cfg",
    action_url          => '/pnp4nagios/graph?host=$HOSTNAME$&srv=$SERVICEDESC$',
  }
}