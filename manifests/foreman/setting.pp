# Class to manage foreman parameters.
#
# @example when declaring the apache class
#  profiles::foreman::setting { 'example':
#    value => 'foo'
#  }
#
# @param value (String) Usetting value.
define profiles::foreman::setting (
  $value,
) {
  foreman_config_entry { $name:
    value => $value,
  }
}