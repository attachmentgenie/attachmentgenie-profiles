# This class can be used install time components.
#
# @example when declaring the time class
#  class { '::stacks::time': }
#
# @param restrict (Array) Restrict to this list.
# @param zone (String) Timezone for this node.
class profiles::time (
  $restrict = [],
  $zone     = 'Europe/Amsterdam',
) {
  validate_array(
    $restrict,
  )
  validate_string(
    $zone,
  )
  class { 'ntp':
    restrict => $restrict,
  }
  class { 'timezone':
    zone     => $zone,
  }
}