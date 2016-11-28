# This class can be used install apache and web properties
#
# @example when declaring the apache class
#  class { '::profiles::apache': }
#
# @param default_mods (Boolean|Hash) Modules to install.
# @param default_vhost (Boolean) Keep default vhost
# @param vhosts (Hash) Vhosts to manage.
class profiles::apache (
  $default_mods  = true,
  $default_vhost = false,
  $vhosts = {}
) {
  class { '::apache':
    default_mods  => $default_mods,
    default_vhost => $default_vhost,
  }

  $vhost_defaults = {
    vhost_name     => '*',
    docroot        => '/var/www',
    error_log      => true,
  }
  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )
}