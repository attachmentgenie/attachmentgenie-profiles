# This class can be used install apache and web properties
#
# @example when declaring the apache class
#  class { '::profiles::website::apache': }
#
# @param default_mods    Modules to install.
# @param default_vhost   Keep default vhost
# @param modules         List of modules to install
# @param mpm_module      MPM module.
# @param purge_configs   Purge unmanaged config files.
# @param purge_vhost_dir Purge unmanaged vhost files.
# @param vhosts          Vhosts to manage.
# @param vhost_packages  Packages to manage that contain vhosts files.
class profiles::website::apache (
  Boolean $default_mods = true,
  Boolean $default_vhost = false,
  Hash $modules = {
    'proxy' => {},
    'proxy_fcgi' => {},
  },
  String $mpm_module = 'prefork',
  Boolean $purge_configs = false,
  Boolean $purge_vhost_dir = false,
  Hash $vhosts = {},
  Hash $vhost_packages = {},
) {
  class { '::apache':
    default_mods     => $default_mods,
    default_vhost    => $default_vhost,
    file_mode        => '0640',
    mpm_module       => $mpm_module,
    purge_configs    => $purge_configs,
    purge_vhost_dir  => $purge_vhost_dir,
    server_signature => 'Off',
    server_tokens    => 'Prod',
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
