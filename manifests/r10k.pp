# This class can be used install user r10k properties
#
# @example when declaring the apache class
#  class { '::profiles::r10k': }
#
# @param puppet_repo_url (String) url to git repo where puppet code is stored.
class profiles::r10k (
  $puppet_repo_url = undef,
) {
  validate_string(
    $puppet_repo_url,
  )
  class { '::r10k':
    sources           => {
      'puppet' => {
        'remote'  => $puppet_repo_url,
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }
    },
    manage_modulepath => false,
  }
}