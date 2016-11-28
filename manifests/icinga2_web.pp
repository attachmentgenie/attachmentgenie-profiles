# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::icinga2_web': }
#
class profiles::icinga2_web () {
  notice("Included ${::name}")
}
