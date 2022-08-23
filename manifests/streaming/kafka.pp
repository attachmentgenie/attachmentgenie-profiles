# This class can be used install kafka components.
#
# @example when declaring the kafka class
#  class { '::profiles::streaming::kafka': }
#
# @param install_dir      Directory to install to.
# @param install_method   How to install kafka.
# @param package          Package to install.
# @param scala_version    Version of scala to depend on.
# @param version          Version of kafka to install.
# @param zookeeper_config Kafka config settings.
class profiles::streaming::kafka (
  String $install_dir = '/opt/kafka_2.12-2.4.1',
  String $install_method = 'package',
  String $package = 'kafka_2.12',
  String $scala_version = '2.12',
  String $version = '2.4.1',
  Hash $zookeeper_config = { 'broker.id'                     => '0',
    'inter.broker.protocol.version' => '0.10.1.0',
    'log.dir'                       => '/opt/kafka/data',
  'zookeeper.connect'             => 'localhost:2181' }
) {
  # The upstream voxpupuli-kafka module decided bases on package_name being undef wether or not to install by rpm.
  # Since we can never override a parameter to be undef from hiera we need to force it here.
  if $install_method == 'archive' {
    $package_name = undef
  } else {
    $package_name = $package
  }

  class { 'kafka':
    install_dir   => $install_dir,
    kafka_version => $version,
    package_name  => $package_name,
    scala_version => $scala_version,
  }
  -> class { 'kafka::broker':
    config => $zookeeper_config,
  }
}
