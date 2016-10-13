# This class can be used install kafka components.
#
# @example when declaring the kafka class
#  class { '::profiles::kafka': }
#
# @param version (String) version of kafka to install.
# @param zookeeper_config (Hash) kafka config settings.
class profiles::kafka (
  $version           = '0.10.0.1',
  $zookeeper_config = { 'broker.id'                     => '0',
                        'inter.broker.protocol.version' => '0.10.0.1',
                        'zookeeper.connect'             => 'localhost:2181' }
) {
  validate_string($version)
  validate_hash($zookeeper_config)

  class { '::kafka::broker':
    config                     => $zookeeper_config,
    install_java               => false,
    service_requires_zookeeper => false,
    version                    => $version,
  }
}