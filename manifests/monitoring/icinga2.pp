# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::monitoring::icinga2': }
#
# @param api_endpoint                   Public API endpoint.
# @param api_password                   Api password.
# @param api_pki                        Cypher to use for api certs.
# @param api_user                       Api user.
# @param api_users                      Hash of api users to generate.
# @param checkcommands                  List of checks
# @param client                         Is this a icinga client.
# @param confd                          Include conf.d directory or specify your own.
# @param database_host                  Db host.
# @param database_name                  Db name.
# @param database_password              Db password.
# @param database_user                  Db user.
# @param features                       Enabled features.
# @param fragments                      Custom configuration fragments.
# @param group                          Group
# @param hostgroups                     Host groups
# @param ipaddress                      Primary ipaddress.
# @param manage_repo                    Manage icinga repository.
# @param notifications                  Notification objects to generate.
# @param owner                          Owner
# @param parent_endpoints               Icinga parents.
# @param parent_zone                    Icinga zone.
# @param plugins_package                Package with plugins to install.
# @param server                         Is this a icinga masters.
# @param servicegroups                  Servicegroups
# @param services                       services
# @param slack                          Slack integration.
# @param slack_channel                  Slack channel to send notifications to.
# @param slack_webhook                  Slack webhook url.
# @param templates                      Templates.
# @param timeperiods                    Timeperiods
# @param usergroups                     User groups
# @param users                          Users
# @param vars                           Icinga vars.
class profiles::monitoring::icinga2 (
  Hash $parent_endpoints,
  Optional[String] $api_endpoint = undef,
  String $api_password = 'icinga',
  String $api_pki = 'puppet',
  String $api_user = 'root',
  Optional[Hash] $api_users = undef,
  Boolean $client = true,
  Variant[Boolean,String] $confd = false,
  String $database_grant = 'all',
  String $database_host = '127.0.0.1',
  String $database_name = 'icinga2',
  String $database_password = 'icinga2',
  String $database_user = 'icinga2',
  Array $features = [ 'checker', 'command', 'mainlog', 'notification' ],
  Optional[Stdlib::Host] $graphite_host = undef,
  Optional[Stdlib::Port::Unprivileged] $graphite_port = undef,
  String $group = 'icinga',
  Boolean $manage_database = true,
  Boolean $manage_repo = false,
  String $owner = 'icinga',
  String $parent_zone = 'master',
  String $plugins_package = 'nagios-plugins-all',
  Boolean $server = false,
  Boolean $ship_metrics = false,
  Boolean $slack = false,
  String $slack_channel = '#icinga',
  Optional[String] $slack_webhook = undef,
  Hash $checkcommands = {},
  Hash $hostgroups = {},
  Hash $services = {},
  Hash $servicegroups = {},
  Hash $timeperiods = {},
  Hash $users = {],
  Hash $usergroups = {},
  Hash $vars = {},
  Hash $templates = {},
  Hash $notifications = {},
  Hash $fragments = {},
) {
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

  if !($server) {
    create_resources('icinga2::object::endpoint', $parent_endpoints)

    ::icinga2::object::zone { $parent_zone:
      endpoints => keys($parent_endpoints),
    }
  }

  if $client {

    if !($server) {
      @@::icinga2::object::endpoint { $::fqdn:
        host   => $::hostname,
        target => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }

      @@::icinga2::object::zone { $::fqdn:
        endpoints => [ $::fqdn ],
        parent    => $parent_zone,
        target    => "/etc/icinga2/zones.d/${parent_zone}/${::hostname}.conf",
      }
    }

    @@::icinga2::object::host { $::fqdn:
      address      => $::ipaddress,
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

    if $api_users and $api_users != {} {
      $api_users.each | $user, $opts | {
        ::icinga2::object::apiuser { $user:
          *      => $opts,
          target => "/etc/icinga2/zones.d/${parent_zone}/api-users.conf",
        }
      }
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

    if $ship_metrics {
      class { '::icinga2::feature::graphite':
        host => $graphite_host,
        port => $graphite_port,
      }
    }
    if $slack {
      class { '::profiles::monitoring::icinga2::slack':
        icinga_endpoint => $api_endpoint,
        slack_channel   => $slack_channel,
        slack_webhook   => $slack_webhook,
      }
    }

    # Generate objects
    ensure_resources( ::icinga2::object::checkcommand, $checkcommands )
    ensure_resources( ::icinga2::object::hostgroup, $hostgroups )
    ensure_resources( ::icinga2::object::notification, $notifications )
    ensure_resources( ::icinga2::object::service, $services )
    ensure_resources( ::icinga2::object::servicegroup, $servicegroups )
    ensure_resources( ::icinga2::object::timeperiod, $timeperiods )
    ensure_resources( ::icinga2::object::user, $users)
    ensure_resources( ::icinga2::object::usergroup, $usergroups )
    ensure_resources( ::icinga2::config::fragment, $fragments )

    $templates.each | $object_type, $object_configs | {
      $_default_template_params = {
        'target'   => '/etc/icinga2/zones.d/global-templates/templates.conf',
        'template' => true,
      }
      ensure_resources( "::icinga2::object::${object_type}", $object_configs, $_default_template_params )
    }

    # Collect objects
    ::Icinga2::Object::Apiuser <<| |>>
    ::Icinga2::Object::Checkcommand <<| |>>
    ::Icinga2::Object::Endpoint <<| |>>
    ::Icinga2::Object::Host <<| |>>
    ::Icinga2::Object::Service <<| |>>
    ::Icinga2::Object::Zone <<| |>>

    profiles::bootstrap::firewall::entry { '200 allow icinga':
      port => 5665,
    }

    if $manage_database {
      profiles::database::postgresql::db { $database_name:
        grant    => $database_grant,
        password => $database_password,
        user     => $database_user,
      }
    }
  }
}
