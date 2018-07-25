# This class can be used install the icinga2 dashboard:
# https://github.com/dnsmichi/dashing-icinga2
#
# @example when declaring the icinga2 class
#  class { '::profiles::dashboard::icinga2': }
#
# @param api_password The password of the api user, required.
# @param api_username The username of the api user.
# @param runmode The way that the dasboard is running, can be package or docker.
# @param package_name The name of the package, only needed when runmode is package.
# @param service_name The name of the service, only needed when runmode is package.
# @param docker_image The name of the docker image, only needed when runmode is docker.
# @param docker_env_parameters A hash containing the environment parameters, only needed when runmode is docker.
# ex:
# profile::dashboard::icinga2::docker_env_parameters:
#   ICINGA2_API_HOST: '192.168.20.60'
#   ICINGA2_API_PORT: '5665'
#   ICINGA2_API_USERNAME: icingadashboard
#   ICINGA2_API_PASSWORD: verylongandsecurepw
#   ICINGAWEB2_URL: 'http://192.168.20.60/icingaweb2'
class profiles::dashboard::icinga2 (
  String $api_password,
  String $api_username = 'icingadashboard',
  Optional[String] $runmode = undef,
  Optional[String] $package_name = undef,
  Optional[String] $service_name = undef,
  Optional[String] $docker_image = undef,
  Optional[Hash] $docker_env_parameters,
){

  if ( $runmode == 'package' ) {
    package { $package_name:
      ensure => installed,
    }
    service { $service_name:
      ensure  => running,
      require => Package[$package_name],
    }
  }

  if ( $runmode == 'docker' ) {
    $container_name = 'icinga2dashboard'
    $env_dir = '/etc/docker/env_files'
    $env_file = "${env_dir}/${container_name}"

    concat { $env_file:
      ensure  => present,
    }

    keys($docker_env_parameters).each | $parameter | {
      $u_key = upcase( $parameter )
      concat::fragment { "docker env file ${parameter}":
        target  => $env_file,
        order   => '10',
        content => "${u_key}=${docker_env_parameters[$parameter]}\n",
      }
    }

    docker::image { $docker_image: }

    docker::run { $container_name:
      image    => $docker_image,
      ports    => '3030:3030',
      env_file => [ $env_file ],
      require  => [
        Docker::Image[$docker_image],
        File[$env_file],
      ],
    }
  }

  @@::icinga2::object::apiuser { $api_username:
    password    => $api_password,
    target      => '/etc/icinga2/zones.d/master/api-users.conf',
    permissions => [ 'status/query', 'objects/query/*' ],
  }
}
