# This class can be used install selinux components.
#
# @example when declaring the selinux class
#  class { '::stacks::selinux': }
#
# @param mode (String) Selinux operation mode.
class profiles::selinux (
  $mode = 'disabled',
) {
  validate_string(
    $mode
  )
  class { '::selinux':
    mode => $mode,
  }
}