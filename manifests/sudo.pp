class profiles::sudo (
  $motd = false,
) {

  class { 'sudo': }

  if $motd {
    motd::register{ 'Profile : sudo': }
  }
}