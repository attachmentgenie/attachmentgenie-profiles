# This class can be used install user r10k properties
#
# @example when declaring the r10k class
#  class { '::profiles::puppet::r10k': }
#
# @param basedir         Environments directory.
# @param mcollective     Manage mcollective bindings.
# @param puppet_repo_url Url to git repo where puppet code is stored.
class profiles::puppet::r10k (
  String $basedir = '/etc/puppetlabs/code/environments',
  Boolean $mcollective = false,
  Optional[String] $puppet_repo_url = undef,
) {
  class { 'r10k':
    manage_modulepath => false,
    mcollective       => $mcollective,
    r10k_basedir      => $basedir,
    sources           => {
      'puppet' => {
        'remote'  => $puppet_repo_url,
        'basedir' => $basedir,
        'prefix'  => false,
      },
    },
  }
}
