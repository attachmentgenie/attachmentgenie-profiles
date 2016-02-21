class profiles::accounts (
  $accounts = undef,
  $motd     = false,
) {
  class { 'accounts': }

  if $motd {
    motd::register{ 'Profile : accounts': }
  }
}