# This class can be used install jenkins components.
#
# @example when declaring the jenkins class
#  class { '::profiles::jenkins': }
#
# @param config_hash (Hash) Config settings
# @param manage_repo (Boolean) Manage rpm repository.
# @param plugins (Hash) Plugins to install.
# @param purge_plugins (Boolean) Remove unmanaged plugins.
class profiles::jenkins (
  $config_hash   = { 'JENKINS_LISTEN_ADDRESS' => { 'value' => '127.0.0.1' }},
  $manage_repo   = false,
  $plugins       = {},
  $purge_plugins = true,
) {
  validate_bool(
    $manage_repo,
    $purge_plugins,
  )
  validate_hash(
    $config_hash,
    $plugins,
  )

  class { '::jenkins':
    config_hash        => $config_hash,
    configure_firewall => false,
    install_java       => false,
    purge_plugins      => $purge_plugins,
    repo               => $manage_repo,
  }
  create_resources(::jenkins::plugin, $plugins)
}