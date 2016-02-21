class profiles::package (
  $motd = false,
) {

  require ::profiles::ruby

  package { 'fpm':
    ensure   => 'latest',
    provider => 'gem',
  }

  if $motd {
    motd::register{ 'Profile : package': }
  }
}