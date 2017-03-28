# This class can be used install user alertmanager properties
#
# @example when declaring the alertmanager class
#  class { '::profiles::alertmanager': }
#
# @param global (Hash) Global settings
# @param route (Hash) Routes.
# @param receivers (Array) receivers.
# @param inhibit_rules (Array) Inhibit rules.
# @param install_method (String) how to install
# @param version (String) Version to install
class profiles::alertmanager (
  $global         = { 'smtp_smarthost' =>'localhost:25',
                      'smtp_from'=>'alertmanager@localhost' },
  $inhibit_rules  = [{ 'source_match' => { 'severity'=> 'critical' },
                        'target_match'=> { 'severity'=>'warning'},
                        'equal'=>['alertname','cluster','service']}],
  $install_method = 'package',
  $receivers      = [{ 'name' => 'Admin',
                        'email_configs'=> [ { 'to'=> 'root@localhost' }] }],
  $route          = { 'group_by' =>  [ 'alertname', 'cluster', 'service' ],
                      'group_wait'=> '30s',
                      'group_interval'=> '5m',
                      'repeat_interval'=> '3h',
                      'receiver'=> 'Admin' },
  $version        = '0.5.1'
){
  validate_array(
    $receivers,
    $inhibit_rules,
  )
  validate_hash(
    $global,
    $route,
  )
  validate_string(
    $install_method,
    $version,
  )
  class { '::prometheus::alertmanager':
    global         => $global,
    inhibit_rules  => $inhibit_rules,
    install_method => $install_method,
    receivers      => $receivers,
    route          => $route,
    version        => $version,
  }
}