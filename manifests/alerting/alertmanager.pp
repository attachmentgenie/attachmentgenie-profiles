# This class can be used install user alertmanager properties
#
# @example when declaring the alertmanager class
#  class { '::profiles::alerting::alertmanager': }
#
# @param global         Global settings
# @param route          Routes.
# @param receivers      Receivers.
# @param inhibit_rules  Inhibit rules.
# @param install_method How to install
# @param version        Version to install
class profiles::alerting::alertmanager (
  Hash $global = {
    'smtp_smarthost' =>'localhost:25',
    'smtp_from'=>'alertmanager@localhost'
  },
  Array $inhibit_rules = [
    { 'source_match' => { 'severity'=> 'critical' },
      'target_match'=> { 'severity'=>'warning'},
      'equal'=>['alertname','cluster','service']
    }
  ],
  String $install_method = 'package',
  Array $receivers = [
    { 'name' => 'Admin',
      'email_configs'=> [ { 'to'=> 'root@localhost' }]
    }
  ],
  Hash $route = {
    'group_by'       => [ 'alertname', 'cluster', 'service' ],
    'group_wait'     => '30s',
    'group_interval' => '5m',
    'repeat_interval'=> '3h',
    'receiver'       => 'Admin',
  },
  String $version = '0.15.2'
){
  class { '::prometheus::alertmanager':
    global         => $global,
    inhibit_rules  => $inhibit_rules,
    install_method => $install_method,
    receivers      => $receivers,
    route          => $route,
    version        => $version,
  }
}
