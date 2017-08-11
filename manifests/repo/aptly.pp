# This class can be used install aptly components.
#
# @example when declaring the aptly class
#  class { '::profiles::repo::aptly': }
#
# @param aptly_mirrors Mirrors to manage
# @param aptly_repos   Repos to manage
# @param config        Aptly config hash
# @param key_server    Key server to use.
# @param manage_repo   Let profile install repo.
class profiles::repo::aptly (
  Hash $aptly_mirrors = {},
  Hash $aptly_repos = {},
  Hash $config = {},
  String $key_server = 'keys.gnupg.net',
  Boolean $manage_repo = false,
) {
  class { '::aptly':
    aptly_mirrors => $aptly_mirrors,
    aptly_repos   => $aptly_repos,
    config        => $config,
    key_server    => $key_server,
    repo          => $manage_repo,
  }
}
