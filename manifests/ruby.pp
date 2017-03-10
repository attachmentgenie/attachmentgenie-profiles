# This class can be used install ruby
#
# @example when declaring the ruby class
#  class { '::profiles::ruby': }
#
class profiles::ruby {

  case $::osfamily {
    'debian': {
      $packages = ['rubygems-integration','ruby','ruby-dev']
    }
    'redhat': {
      $packages = ['rubygems','ruby','ruby-devel']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  package { $packages:
    ensure => installed,
  }
}