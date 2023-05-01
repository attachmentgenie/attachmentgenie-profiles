# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::puppet::g10k
class profiles::puppet::g10k (
  String $puppet_repo_url,
  String $basedir         = '/etc/puppetlabs/code/environments',
  String $source_name     = 'puppet-tree',
  String $version         = '0.9.7',
) {
  file { '/usr/local/share/g10k':
    ensure => directory,
    mode   => '0755',
  }
  -> class { 'g10k':
    source_name    => $source_name,
    source_remote  => $puppet_repo_url,
    source_basedir => $basedir,
    version        => $version,
  }
}
