# This class can be used install apache and web properties
#
# @example when declaring the apache class
#  class { '::profiles::apache': }
#
# @param vhosts (Hash)) Vhosts to manage.
class profiles::apache (
  $vhosts = {}
) {
  class { 'apache':
    default_vhost => false,
  }

  $vhost_defaults = {
    vhost_name     => '*',
    docroot        => '/var/www',
    error_log      => true,
  }
  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )
}