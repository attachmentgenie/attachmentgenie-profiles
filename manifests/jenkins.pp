# This class can be used install jenkins components.
#
# @example when declaring the jenkins class
#  class { '::profiles::jenkins': }
#
# @param plugins (Hash) Plugins to install.
class profiles::jenkins (
  $plugins = {},
) {
  class { 'jenkins':
    configure_firewall => false,
    install_java       => false,
  }
  create_resources(::jenkins::plugin, $plugins)
}