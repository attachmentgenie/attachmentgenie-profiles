# This class can be used install user mcollective properties
#
# @example when declaring the apache class
#  class { '::profiles::mcollective': }
#
# @param client (Boolean) Manage client settings
# @param client_user (String) Which user to manage.
# @param middleware_hosts (Array) Which activemq servers to connect to.
# @param users (Hash) Users to manage.
class profiles::mcollective (
  $client           = false,
  $client_user      = 'vagrant',
  $middleware_hosts = [$::fqdn],
  $users            = { 'vagrant' => {} },
) {
  validate_array(
    $middleware_hosts,
  )
  validate_bool(
    $client,
  )
  validate_hash(
    $users,
  )
  validate_string(
    $client_user,
  )
  class { '::mcollective':
    client           => $client,
    middleware_hosts => $middleware_hosts,
  }

  if $client {
    create_resources(mcollective::user, $users)
  }
}