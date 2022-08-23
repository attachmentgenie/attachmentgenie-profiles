# This class can be used install selinux components.
#
# @example when declaring the selinux class
#  class { '::profiles::selinux': }
#
# @param mode Selinux operation mode.
class profiles::security::selinux (
  String $mode = 'disabled',
) {
  class { 'selinux':
    mode => $mode,
  }
}
