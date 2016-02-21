class profiles::r10k (
  $puppet_repo_url = undef,
) {
  class { 'r10k':
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