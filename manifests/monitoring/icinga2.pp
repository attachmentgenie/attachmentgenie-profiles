# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::monitoring::icinga2': }
#
# @param api_endpoint      Public API endpoint.
# @param api_password      Api password.
# @param api_pki           Cypher to use for api certs.
# @param api_user          Api user.
# @param client            Is this a icinga client.
# @param confd             Include conf.d directory or specify your own.
# @param database_host     Db host.
# @param database_name     Db name.
# @param database_password Db password.
# @param database_user     Db user.
# @param features          Enabled features.
# @param group             Group
# @param ipaddress         Primary ipaddress.
# @param manage_repo       Manage icinga repository.
# @param owner             Owner
# @param parent_endpoints  Icinga parents.
# @param parent_zone       Icinga zone.
# @param plugins_package   Package with plugins to install.
# @param server            Is this a icinga masters.
# @param slack             Slack integration.
# @param slack_channel     Slack channel to send notifications to.
# @param slack_webhook     Slack webhook url.
# @param vars              Icinga vars.
class profiles::monitoring::icinga2 (
  Hash $parent_endpoints,
  Optional[String] $api_endpoint = undef,
  String $api_password = 'icinga',
  String $api_pki = 'puppet',
  String $api_user = 'root',
  Boolean $client = true,
  Variant[Boolean,String] $confd = false,
  String $database_host = '127.0.0.1',
  String $database_name = 'icinga2',
  String $database_password = 'icinga2',
  String $database_user = 'icinga2',
  Array $features = [ 'checker', 'command', 'mainlog', 'notification' ],
  String $group = $::profiles::monitoring::icinga2::params::group,
  String $ipaddress = $::ipaddress,
  Boolean $manage_repo = false,
  String $owner = $::profiles::monitoring::icinga2::params::owner,
  String $parent_zone = 'master',
  String $plugins_package = $::profiles::monitoring::icinga2::params::plugins_package,
  Boolean $server = false,
  Boolean $slack = false,
  String $slack_channel = '#icinga',
  Optional[String] $slack_webhook = undef,
  Hash $vars = {},
) inherits profiles::monitoring::icinga2::params {
  if $server {
    $constants = {
      'ZoneName' => 'master',
    }
    $zones = {
      'ZoneName' => {
        'endpoints' => [ 'NodeName' ],
      }
    }
  } else {
    $constants = {}
    $zones = {
      'ZoneName' => {
        'endpoints' => [ 'NodeName' ],
        'parent'    => $parent_zone,
      }
    }
  }


  package { 'nagios-plugins-all':
    name => $plugins_package,
  }

  class { '::icinga2':
    confd       => $confd,
    constants   => $constants,
    features    => $features,
    manage_repo => true,
  }

  class { '::icinga2::feature::api':
    accept_config   => true,
    accept_commands => true,
    pki             => $api_pki,
    zones           => $zones,
  }

  icinga2::object::zone { ['global-templates', 'linux-commands']:
    global => true,
    order  => '47',
  }

  if $client {
    if !($server) {
      create_resources('icinga2::object::endpoint', $parent_endpoints)

      ::icinga2::object::zone { $parent_zone:
        endpoints => keys($parent_endpoints),
      }

      @@::icinga2::object::endpoint { $::fqdn:
        host   => $ipaddress,
        target => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }

      @@::icinga2::object::zone { $::fqdn:
        endpoints => [ $::fqdn ],
        parent    => $parent_zone,
        target    => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }
    }

    @@::icinga2::object::host { $::fqdn:
      address      => $ipaddress,
      display_name => $::hostname,
      import       => ['linux-host'],
      target       => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      vars         => $vars,
    }
  }

  if $server {

    class { 'icinga2::feature::idopgsql':
      host          => $database_host,
      user          => $database_user,
      password      => $database_password,
      database      => $database_name,
      import_schema => true,
    }

    ::icinga2::object::apiuser { $api_user:
      password    => $api_password,
      permissions => [ '*' ],
      target      => "/etc/icinga2/zones.d/${parent_zone}/api-users.conf",
    }

    file { ['/etc/icinga2/zones.d/master',
      '/etc/icinga2/zones.d/linux-commands',
      '/etc/icinga2/zones.d/global-templates']:
      ensure => directory,
      owner  => 'icinga',
      group  => 'icinga',
      mode   => '0750',
      tag    => 'icinga2::config::file',
    }

    case $::osfamily {
      'Debian': {
        ::icinga2::object::service { 'linux_apt':
          import           => ['generic-service'],
          service_name     => 'apt',
          apply            => true,
          check_command    => 'apt',
          check_period     => '9to5',
          command_endpoint => 'host.name',
          assign           => ['NodeName'],
          target           => '/etc/icinga2/zones.d/global-templates/services.conf',
        }
      }
      default: {}
    }

    ::icinga2::object::service { 'linux_icinga':
      import           => ['generic-service'],
      service_name     => 'icinga',
      apply            => true,
      check_command    => 'icinga',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_procs':
      import           => ['generic-service'],
      service_name     => 'procs',
      apply            => true,
      check_command    => 'procs',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_users':
      import           => ['generic-service'],
      service_name     => 'users',
      apply            => true,
      check_command    => 'users',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_ssh':
      import           => ['generic-service'],
      service_name     => 'ssh',
      apply            => true,
      check_command    => 'ssh',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_load':
      import           => ['generic-service'],
      service_name     => 'load',
      apply            => true,
      check_command    => 'load',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_disks':
      import           => ['generic-service'],
      apply            => 'disk_name => config in host.vars.disks',
      check_command    => 'disk',
      command_endpoint => 'host.name',
      vars             => 'vars + config',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::usergroup { 'icingaadmins':
      display_name => 'Icinga 2 Admin Group',
      target       => '/etc/icinga2/zones.d/global-templates/usergroups.conf',
    }

    ::icinga2::object::timeperiod{ '24x7':
      target => '/etc/icinga2/zones.d/global-templates/timeperiods.conf',
      ranges => {
        'monday'    => '00:00-24:00',
        'tuesday'   => '00:00-24:00',
        'wednesday' => '00:00-24:00',
        'thursday'  => '00:00-24:00',
        'friday'    => '00:00-24:00',
        'saturday'  => '00:00-24:00',
        'sunday'    => '00:00-24:00',
      }
    }

    ::icinga2::object::timeperiod{ '9to5':
      target => '/etc/icinga2/zones.d/global-templates/timeperiods.conf',
      ranges => {
        'monday'    => '09:00-17:00',
        'tuesday'   => '09:00-17:00',
        'wednesday' => '09:00-17:00',
        'thursday'  => '09:00-17:00',
        'friday'    => '09:00-17:00',
      }
    }

    if $slack {
      class { '::profiles::monitoring::icinga2::slack':
        icinga_endpoint => $api_endpoint,
        slack_channel   => $slack_channel,
        slack_webhook   => $slack_webhook,
      }
    }

    # Collect objects
    ::Icinga2::Object::Endpoint <<| |>>
    ::Icinga2::Object::Zone <<| |>>
    ::Icinga2::Object::Host <<| |>>

    # Static config files
    file { '/etc/icinga2/zones.d/global-templates/templates.conf':
      ensure => file,
      owner  => 'icinga',
      group  => 'icinga',
      mode   => '0640',
      source => 'puppet:///modules/profiles/monitoring/icinga2/templates.conf',
    }
  }
}
