# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param manage_repo (Boolean) Manage repositories.
class profiles::influxdb (
  $manage_repo = false,
){
  class {'::influxdb':
    graphite_config => {
        'default' => {
        'enabled'           => true,
        'database'          => 'graphite',
        'retention-policy'  => '',
        'bind-address'      => ':2003',
        'protocol'          => 'tcp',
        'consistency-level' => 'one',
        'batch-size'        => 5000,
        'batch-pending'     => 10,
        'batch-timeout'     => '1s',
        'udp-read-buffer'   => 0,
        'separator'         => '.',
        'tags'              => [],
        'templates'         => [],
      }
    },
    manage_repos    => $manage_repo,
  }
}
