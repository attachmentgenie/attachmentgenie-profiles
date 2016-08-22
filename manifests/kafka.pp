class profiles::kafka () {
  yumrepo { 'cloudera-cdh5':
    descr    => "Cloudera's Distribution for Hadoop, Version 5",
    baseurl  => 'http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5/',
    gpgkey   => 'http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera',
    gpgcheck => 1,
  }
  yumrepo { 'cloudera-kafka':
    descr    => "Cloudera's Distribution for kafka, Version 2.0.2",
    baseurl  => 'http://archive.cloudera.com/kafka/redhat/6/x86_64/kafka/2.0.2',
    gpgkey   => 'http://archive.cloudera.com/kafka/redhat/6/x86_64/kafka/RPM-GPG-KEY-cloudera',
    gpgcheck => 1,
  }
  package { 'redhat-lsb-core':
    ensure => present,
  }
  class { '::kafka':
    broker_id         => 1,
    conf_dir          => '/etc/kafka/conf.dist',
    install_java      => false,
    install_service   => false,
    manage_repo       => false,
    package_name      => 'kafka-server',
    service_name      => 'kafka-server',
    zookeeper_connect => ['node1.kafka.vagrant:2181'],
  }

  Yumrepo['cloudera-cdh5'] -> Package['kafka-server']
  Yumrepo['cloudera-kafka'] -> Package['kafka-server']
  Package['redhat-lsb-core'] -> Service['kafka-server']
}