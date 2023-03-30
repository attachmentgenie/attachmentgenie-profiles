# This class can be used install user repositories properties
#
# @example when declaring the repositories class
#  class { '::profiles::bootstrap::repositories': }
#
# @param epel            Configure epel repository .
# @param foreman         Configure foreman repository .
# @param foreman_repo    What version of foreman to install.
# @param hashicorp       Configure hashicorp.
# @param puppetlabs_deps Configure puppetlabs_deps.
# @param remi            Configure remi repository.
# @param repositories    Repositories to configure.
class profiles::bootstrap::repositories (
  Boolean $epel            = false,
  Boolean $foreman         = false,
  String $foreman_repo     = '2.5',
  Boolean $hashicorp       = false,
  Boolean $puppetlabs_deps = false,
  Boolean $remi            = false,
  Hash $repositories       = {},
) {
  if $epel {
    class { 'epel': }

    if $facts['os']['family'] == 'RedHat' {
      Yumrepo['epel'] -> Package <||>
    }
  }
  if $foreman {
    class { 'foreman::repo':
      repo => $foreman_repo,
    }

    if $facts['os']['family'] == 'RedHat' {
      Yumrepo['epel'] -> Package <||>
    }
  }
  if $hashicorp {
    class { 'hashi_stack::repo': }

    if $facts['os']['family'] == 'RedHat' {
      Yumrepo['HashiCorp'] -> Package <||>
    }
  }
  if $puppetlabs_deps {
    yumrepo { 'puppetlabs-deps':
      descr    => 'Puppet Labs Packages',
      baseurl  => "http://yum.puppetlabs.com/el/${facts['os']['release']['major']}/dependencies/\$basearch",
      enabled  => 1,
      gpgcheck => 0,
    }

    if $facts['os']['family'] == 'RedHat' {
      Yumrepo['puppetlabs-deps'] -> Package <||>
    }
  }
  if $remi {
    yumrepo { 'remi':
      descr      => "Remi's RPM repository for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
      baseurl    => 'absent',
      mirrorlist => "http://rpms.remirepo.net/enterprise/${facts['os']['release']['major']}/remi/mirror",
      enabled    => 1,
      gpgcheck   => 0,
    }

    if $facts['os']['family'] == 'RedHat' {
      Yumrepo['remi'] -> Package <||>
    }
  }

  # add extra repositories
  $yum_defaults = {
    enabled  => 1,
    gpgcheck => 1,
  }
  create_resources( 'yumrepo', $repositories, $yum_defaults )
}
