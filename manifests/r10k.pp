# This class can be used install user r10k properties
#
# @example when declaring the apache class
#  class { '::profiles::r10k': }
#
# @param mcollective (Boolean) Manage mcollective bindings.
# @param puppet_repo_url (String) url to git repo where puppet code is stored.
class profiles::r10k (
  $mcollective     = false,
  $puppet_repo_url = undef,
) {
  validate_bool(
    $mcollective,
  )
  validate_string(
    $puppet_repo_url,
  )
  class { '::r10k':
    manage_modulepath => false,
    mcollective       => $mcollective,
    sources           => {
      'puppet' => {
        'remote'  => $puppet_repo_url,
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }
    },
  }
}