class profiles::zookeeper () {
  class { '::zookeeper':
    cdhver               => '5',
    initialize_datastore => true,
    repo                 => 'cloudera',
  }
}