# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::bootstrap::keepalive
class profiles::bootstrap::keepalive (
  Hash $instances = {},
  Hash $scripts = {},
  String[1] $script_user = 'root',
  Hash $processes = {},
) {
  class { 'keepalived': }
  -> class { 'keepalived::global_defs':
    script_user => $script_user,
  }
  create_resources( '::keepalived::vrrp::instance', $instances )
  create_resources( '::keepalived::vrrp::script', $scripts )
  create_resources( '::keepalived::vrrp::track_process', $processes )
}
