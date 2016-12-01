# This class can be used install apache and web properties
#
# @example when declaring the apache class
#  class { '::profiles::apache': }
#
# @param default_mods (Boolean) Modules to install.
# @param default_vhost (Boolean) Keep default vhost
# @param modules (Hash) List of modules to install
# @param mpm_module (String) mpm_module.
# @param purge_configs (Boolean) purge unmanaged config files.
# @param purge_vhost_dir (Boolean) purge unmanaged vhost files.
# @param vhosts (Hash) Vhosts to manage.
class profiles::apache (
  $default_mods    = true,
  $default_vhost   = false,
  $modules         = {},
  $mpm_module      = 'prefork',
  $purge_configs   = false,
  $purge_vhost_dir = false,
  $vhosts          = {},
) {
  validate_bool(
    $default_mods,
    $default_vhost,
    $purge_configs,
    $purge_vhost_dir,
  )
  validate_hash(
    $modules,
    $vhosts,
  )
  class { '::apache':
    default_mods    => $default_mods,
    default_vhost   => $default_vhost,
    mpm_module      => $mpm_module,
    purge_configs   => $purge_configs,
    purge_vhost_dir => $purge_vhost_dir,
  }
  create_resources( 'apache::mod', $modules)
  contain ::apache::mod::php
  $vhost_defaults = {
    vhost_name     => '*',
    docroot        => '/var/www',
    error_log      => true,
  }
  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )
}