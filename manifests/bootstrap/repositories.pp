# This class can be used install user repositories properties
#
# @example when declaring the repositories class
#  class { '::profiles::bootstrap::repositories': }
#
# @param epel            Configure epel repository .
# @param hashicorp       Configure hashicorp.
# @param puppetlabs_deps Configure puppetlabs_deps.
# @param remi            Configure remi repository.
# @param repositories    Repositories to configure.
class profiles::bootstrap::repositories (
  Boolean $epel            = false,
  Boolean $hashicorp       = false,
  Boolean $puppetlabs_deps = false,
  Boolean $remi            = false,
  Hash $repositories       = {},
) {
  if $epel {
    class { 'epel': }
    Yumrepo['epel'] -> Package <||>
  }
  if $hashicorp {
    class { 'hashi_stack::repo': }
    Yumrepo['HashiCorp'] -> Package <||>
  }
  if $puppetlabs_deps {
    yumrepo { 'puppetlabs-deps':
      descr    => 'Puppet Labs Packages',
      baseurl  => "http://yum.puppetlabs.com/el/${facts['os']['release']['major']}/dependencies/\$basearch",
      enabled  => 1,
      gpgcheck => 0,
    }
    Yumrepo['puppetlabs-deps'] -> Package <||>
  }
  if $remi {
    yumrepo { 'remi':
      descr      => "Remi's RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
      baseurl    => 'absent',
      mirrorlist => "http://rpms.remirepo.net/enterprise/${facts['os']['release']['major']}/remi/mirror",
      enabled    => 1,
      gpgcheck   => 0,
    }
    Yumrepo['remi'] -> Package <||>
  }

  # add extra repositories
  $yum_defaults = {
    enabled  => 1,
    gpgcheck => 1,
  }
  create_resources( 'yumrepo', $repositories, $yum_defaults )
}
