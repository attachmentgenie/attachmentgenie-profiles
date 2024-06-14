# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::bootstrap::systemd
class profiles::bootstrap::systemd (
  Boolean $manage_resolved = true,
  Boolean $manage_networkd = false,
  Boolean $manage_timesyncd = false,
  Boolean $manage_journald = false,
  Boolean $manage_udevd = false,
  Boolean $manage_logind = false,
  Boolean $manage_coredump = false,
  Hash $resolved_confs = {},
  Stdlib::Absolutepath $resolved_conf_dir = '/etc/systemd/resolved.conf.d',
  Boolean $use_stub_resolver = true
) {
  class { 'systemd':
    manage_resolved  => $manage_resolved,
    manage_networkd  => $manage_networkd,
    manage_timesyncd => $manage_timesyncd,
    manage_journald  => $manage_journald,
    manage_udevd     => $manage_udevd,
    manage_logind    => $manage_logind,
    manage_coredump  => $manage_coredump,
    use_stub_resolver => $use_stub_resolver,
  }

  if $manage_resolved {
    file { 'resolved config dir':
      ensure => directory,
      path   => $resolved_conf_dir,
    }

    $resolved_conf_defaults = {
      notify            => Service['systemd-resolved'],
      require           => File['resolved config dir'],
      resolved_conf_dir => $resolved_conf_dir,
    }
    create_resources( '::profiles::bootstrap::systemd::resolved_conf', $resolved_confs, $resolved_conf_defaults)
  }
}
