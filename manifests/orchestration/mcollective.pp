# This class can be used install user mcollective properties
#
# @example when declaring the mcollective class
#  class { '::profiles::orchestration::mcollective': }
#
# @param client           Manage client settings
# @param client_user      Which user to manage.
# @param middleware_hosts Which activemq servers to connect to.
# @param users            Users to manage.
class profiles::orchestration::mcollective (
  Boolean $client         = false,
  String $client_user     = 'vagrant',
  Array $middleware_hosts = [$::fqdn],
  Hash $users             = { 'vagrant' => {} },
) {
  class { '::mcollective':
    client           => $client,
    middleware_hosts => $middleware_hosts,
  }

  if $client {
    create_resources(mcollective::user, $users)
  }
}
