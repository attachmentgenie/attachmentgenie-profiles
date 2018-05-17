# This class manages the icinga api user for the dashboard
#
#
class profiles::alerting::icingaweb2::dashboard (
  String $api_username = 'icingadashboard',
  String $api_password = 'changemeplease!',
) inherits profiles::alerting::icingaweb2 {

  if ( $api_password == 'changemeplease!' ) {
    notify { 'Using the default password, only use in development environments!': }
  }

  ::icinga2::object::apiuser { $api_username:
    password    => $api_password,
    target      => '/etc/icinga2/zones.d/master/api-users.conf',
    permissions => [ 'status/query', 'objects/query/*' ],
  }
}
