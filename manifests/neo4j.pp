class profiles::neo4j (
  $neo4j_version = '2.3.6',
) {
  class { '::neo4j':
    version => $neo4j_version,
  }
}