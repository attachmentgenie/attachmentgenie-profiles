# This class is used to setup the grafana module on icingaweb2.
#
#
# @param grafana_host         Host grafana listens on
# @param grafana_port         Port grafana listens on
# @param grafana_username     Grafana user
# @param grafana_password     Grafana credentials
# @param grafana_datasource   Grafana datasource
# @param git_url              git repo to pull the plugin from
class profiles::alerting::icingaweb2::grafana (
  String $grafana_host       = 'localhost',
  String $grafana_port       = '3000',
  String $grafana_username   = 'icinga2',
  String $grafana_password   = 'icinga2',
  String $grafana_datasource = 'influxdb',
  String $git_url            = 'https://github.com/Mikesch-mp/icingaweb2-module-grafana',
) inherits profiles::alerting::icingaweb2 {

  $conf_dir        = $::icingaweb2::params::conf_dir
  $module_conf_dir = "${conf_dir}/modules/grafana"


  $_settings     =  {
    'grafana'    => {
      'target'   => "${module_conf_dir}/grafana.ini",
      'settings' => {
        'host'                    => "${grafana_host}:${grafana_port}",
        'username'                => $grafana_username,
        'password'                => $grafana_password,
        'datasource'              => $grafana_datasource,
        'timerange'               => '1h',
        'timerangeAll'            => '1M/M',
        'defaultorgid'            => '1',
        'defaultdashboard'        => 'icinga2-default',
        'defaultdashboardpanelid' => '1',
        'defaultdashboardstore'   => 'db',
        'accessmode'              => 'proxy',
        'timeout'                 => '5',
        'directrefresh'           => 'no',
        'usepublic'               => 'no',
        'debug'                   => '0',
        'ssl_verifypeer'          => '0',
        'ssl_verifyhost'          => '0',
      }
    }
  }

  icingaweb2::module { 'grafana':
    ensure         => present,
    module         => 'grafana',
    install_method => 'git',
    git_repository => $git_url,
    settings       => $_settings,
  }
}
