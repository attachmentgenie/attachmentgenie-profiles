# This class can be used install kafka components.
#
# @example when declaring the kafka class
#  class { '::profiles::kafka': }
#
# @param install_dir (String) Directory to install to.
# @param install_method (String) How to install kafka.
# @param package (String) Package to install.
# @param scala_version (String) Version of scala to depend on.
# @param version (String) version of kafka to install.
# @param zookeeper_config (Hash) kafka config settings.
class profiles::kafka (
  $install_dir      = '/opt/kafka_2.10-0.10.1.0',
  $install_method   = 'package',
  $package          = 'kafka_2.10',
  $scala_version    = '2.10',
  $version          = '0.10.1.0',
  $zookeeper_config = { 'broker.id'                     => '0',
                        'inter.broker.protocol.version' => '0.10.1.0',
                        'log.dir'                       => '/opt/kafka/data',
                        'zookeeper.connect'             => 'localhost:2181' }
) {
  validate_string(
    $install_dir,
    $install_method,
    $package,
    $scala_version,
    $version
  )
  validate_hash(
    $zookeeper_config
  )

  # The upstream voxpupuli-kafka module decided bases on package_name being undef wether or not to install by rpm.
  # Since we can never override a parameter to be undef from hiera we need to force it here.
  if $install_method == 'archive' {
    $package_name = undef
  } else{
    $package_name = $package
  }

  class { '::kafka':
    install_dir   => $install_dir,
    install_java  => false,
    package_name  => $package_name,
    scala_version => $scala_version,
    version       => $version,
  } ->
  class { '::kafka::broker':
    config                     => $zookeeper_config,
    service_requires_zookeeper => false,
  }
}