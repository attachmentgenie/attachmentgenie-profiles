#
class profiles::locale (
  $motd = false,
) {

  case $::osfamily {
    'debian': {
      class { 'locales': }
    }
    default : {}
  }

  if $motd {
    motd::register{ 'Profile : locale': }
  }
}