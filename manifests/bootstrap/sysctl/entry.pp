# This class can be used install user sysctl properties
#
# @example when declaring the sysctl class
#   ::profiles::bootstrap::sysctl::entry { 'net.ipv4.ip_forward': }
#
define profiles::bootstrap::sysctl::entry (
  Enum['absent','present'] $ensure = 'present',
  String $comment = '',
  $value = 1,
) {
  sysctl { $name:
    ensure  => $ensure,
    comment => 'test',
    value   => $value,
  }
}
