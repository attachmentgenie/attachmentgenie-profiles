class profiles::ruby (
  $motd = false,
) {

  case $::osfamily {
    'debian': {
      $developerPackages = ['rubygems','ruby','ruby-devel']
    }
    'redhat': {
      $developerPackages = ['rubygems','ruby','ruby-devel']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  package { $developerPackages: ensure => installed }

  if $motd {
    motd::register{ 'Profile : ruby': }
  }
}