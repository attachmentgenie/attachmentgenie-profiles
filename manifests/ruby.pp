class profiles::ruby (
  $motd = false,
) {

  case $::osfamily {
    'debian': {
      $developer_packages = ['rubygems','ruby','ruby-devel']
    }
    'redhat': {
      $developer_packages = ['rubygems','ruby','ruby-devel']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  package { $developer_packages: ensure => installed }

  if $motd {
    motd::register{ 'Profile : ruby': }
  }
}