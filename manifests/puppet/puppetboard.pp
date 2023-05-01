# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::puppet::puppetboard
class profiles::puppet::puppetboard (
  Enum['docker'] $install_method = 'docker',
  String $docker_image = 'ghcr.io/voxpupuli/puppetboard',
  Tuple $docker_env_parameters = [
    'PUPPETDB_HOST=127.0.0.1',
    'PUPPETDB_PORT=8080',
    'PUPPETBOARD_PORT=8088',
  ],
) {
  case $install_method {
    'docker': {
      docker::image { $docker_image: }

      docker::run { 'puppetboard':
        image   => $docker_image,
        env     => $docker_env_parameters,
        net     => 'host',
        require => Service['docker'],
      }
    }
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
}
