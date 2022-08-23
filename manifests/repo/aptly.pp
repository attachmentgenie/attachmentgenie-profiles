# This class can be used install aptly components.
#
# @example when declaring the aptly class
#  class { '::profiles::repo::aptly': }
#
# @param api Setup Api.
# @param api_port Api port.
# @param config Aptly config hash
# @param enable_cli_and_http Allow api and cli access.
# @param key_server Key server to use.
# @param manage_repo Let profile install repo.
# @param mirrors Mirrors to manage
# @param mount_point Directory to store packages.
# @param repos Repos to manage
class profiles::repo::aptly (
  Boolean $api = true,
  Integer $api_port = 8080,
  Hash $config = {},
  Boolean $enable_cli_and_http = true,
  String $key_server = 'keys.gnupg.net',
  Boolean $manage_repo = false,
  Hash $mirrors = {},
  String $mount_point = '/var/lib/aptly',
  Hash $repos = {},
) {
  file { 'aptly mount point':
    ensure => 'directory',
    path   => $mount_point,
  }

  $default_config = {
    'rootDir'          => $mount_point,
    'gpgDisableSign'   => false,
    'gpgDisableVerify' => false,
  }
  class { 'aptly':
    aptly_mirrors => $mirrors,
    aptly_repos   => $repos,
    config        => merge($default_config, $config),
    key_server    => $key_server,
    repo          => $manage_repo,
  }
  if $api {
    class { 'aptly::api':
      enable_cli_and_http => $enable_cli_and_http,
      listen              => ":${api_port}",
    }
  }
}
