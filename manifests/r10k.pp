# This class can be used install user r10k properties
#
# @example when declaring the r10k class
#  class { '::profiles::r10k': }
#
# @param basedir (String) Environments directory.
# @param mcollective (Boolean) Manage mcollective bindings.
# @param puppet_repo_url (String) url to git repo where puppet code is stored.
class profiles::r10k (
  $basedir         = '/etc/puppetlabs/code/environments',
  $mcollective     = false,
  $puppet_repo_url = undef,
) {
  validate_bool(
    $mcollective,
  )
  validate_string(
    $basedir,
    $puppet_repo_url,
  )
  class { '::r10k':
    manage_modulepath => false,
    mcollective       => $mcollective,
    r10k_basedir      => $basedir,
    sources           => {
      'puppet' => {
        'remote'  => $puppet_repo_url,
        'basedir' => $basedir,
        'prefix'  => false,
      }
    },
  }
}