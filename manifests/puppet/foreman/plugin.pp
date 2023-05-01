# Class to manage foreman plugins.
#
# @example when declaring the apache class
#  profiles::puppet::puppet::foreman::plugin { 'example':
#    value => 'foo'
#  }
#
define profiles::puppet::foreman::plugin (
  String[1] $package = "${facts['foreman::plugin_prefix']}${title}",
) {
  ::foreman::plugin { $title:
    package => $package,
  }

  Foreman::Repos <||> -> Package[$package]
}
