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
# @param vhost_packages (Hash) Packages to manage that contain vhosts files.
class profiles::apache (
  $default_mods    = true,
  $default_vhost   = false,
  $modules         = {},
  $mpm_module      = 'prefork',
  $purge_configs   = false,
  $purge_vhost_dir = false,
  $vhosts          = {},
  $vhost_packages  = {},
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
    $vhost_packages,
  )
  class { '::apache':
    default_mods    => $default_mods,
    default_vhost   => $default_vhost,
    mpm_module      => $mpm_module,
    purge_configs   => $purge_configs,
    purge_vhost_dir => $purge_vhost_dir,
  }
  create_resources( 'apache::mod', $modules)

  $package_defaults = {
    ensure => present,
    tag    => 'do_a',
  }
  create_resources( 'package', $vhost_packages, $package_defaults )

  $vhost_defaults = {
    docroot    => '/var/www',
    error_log  => true,
    tag        => 'do_b',
    vhost_name => '*',
  }
  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )

  Package<| tag == 'do_a' |> -> Apache::Vhost<| tag == 'do_b' |>
}
