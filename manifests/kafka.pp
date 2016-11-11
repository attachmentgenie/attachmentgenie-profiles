# This class can be used install kafka components.
#
# @example when declaring the kafka class
#  class { '::profiles::kafka': }
#
# @param version (String) version of kafka to install.
# @param zookeeper_config (Hash) kafka config settings.
class profiles::kafka (
  $install_dir      = '/opt/kafka_2.10-0.10.0.1',
  $package_name     = 'kafka_2.10',
  $scala_version    = '2.10',
  $version          = '0.10.0.1',
  $zookeeper_config = { 'broker.id'                     => '0',
                        'inter.broker.protocol.version' => '0.10.0.1',
                        'zookeeper.connect'             => 'localhost:2181' }
) {
  validate_string(
    $package_name,
    $version
  )
  validate_hash(
    $zookeeper_config
  )

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