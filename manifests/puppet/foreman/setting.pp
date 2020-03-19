# Class to manage foreman parameters.
#
# @example when declaring the apache class
#  profiles::puppet::puppet::foreman::setting { 'example':
#    value => 'foo'
#  }
#
# @param value Setting value.
define profiles::puppet::foreman::setting (
  Variant[Boolean, Integer, String] $value,
) {
  foreman_config_entry { $title:
    value => $value,
  }
}
