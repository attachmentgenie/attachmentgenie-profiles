# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::icinga2': }
#
class profiles::icinga2 () {
  notice("Included ${::name}")
}
