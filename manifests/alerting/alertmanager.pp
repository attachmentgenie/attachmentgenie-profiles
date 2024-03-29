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
  Boolean $cluster = false,
  Optional[String[1]] $extra_options = undef,
  Hash $global = {
    'smtp_smarthost' => 'localhost:25',
    'smtp_from'=> 'alertmanager@localhost',
  },
  Array $inhibit_rules = [
    { 'source_match' => { 'severity'=> 'critical' },
      'target_match'=> { 'severity'=> 'warning' },
      'equal'=> ['alertname','cluster','service']
    }
  ],
  String $install_method = 'package',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $receivers = [
    { 'name' => 'Admin',
      'email_configs'=> [{ 'to'=> 'root@localhost' }]
    }
  ],
  Hash $route = {
    'group_by'       => ['alertname', 'cluster', 'service'],
    'group_wait'     => '30s',
    'group_interval' => '5m',
    'repeat_interval'=> '3h',
    'receiver'       => 'Admin',
  },
  String $sd_service_name = 'alertmanager',
  Array $sd_service_tags = ['metrics'],
  String $version = '0.23.0'
) {
  class { 'prometheus::alertmanager':
    extra_options  => $extra_options,
    global         => $global,
    inhibit_rules  => $inhibit_rules,
    install_method => $install_method,
    receivers      => $receivers,
    route          => $route,
    version        => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => 'http://localhost:9093',
          interval => '10s'
        },
      ],
      port   => 9093,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow alertmanager':
      port => 9093,
    }
    if $cluster {
      profiles::bootstrap::firewall::entry { '200 allow alertmanager gossip':
        port => 9094,
      }
    }
  }
}
