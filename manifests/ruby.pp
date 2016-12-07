# This class can be used install ruby
#
# @example when declaring the ruby class
#  class { '::profiles::ruby': }
#
class profiles::ruby {

  case $::osfamily {
    'redhat': {
      $developer_packages = ['rubygems','ruby','ruby-devel']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  package { $developer_packages:
    ensure => installed,
  }
}