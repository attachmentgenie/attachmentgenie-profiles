class profiles::firewall (
  $ensure = 'running',
  $motd   = false,
) {
  class { 'firewall':
    ensure => $ensure,
  }

  if $motd {
    motd::register{ 'Profile : selinux': }
  }
}