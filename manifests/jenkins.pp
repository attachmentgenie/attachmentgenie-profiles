class profiles::jenkins (
  $motd    = false,
  $plugins = {},
  $version = 'latest',
) {
  class { 'jenkins':
    version            => $version,
    configure_firewall => false,
  }
  create_resources(::jenkins::plugin, $plugins)

  if $motd {
    motd::register{ 'Profile : jenkins': }
  }
}