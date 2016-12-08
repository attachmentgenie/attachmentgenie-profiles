# This class can be used to setup flink.
#
# @example when declaring the node role
#  class { '::profiles::flink': }
#
# @param archive_source (String) Flink Download url.
# @param install_method (String) How to install flink.
class profiles::flink (
  $archive_source = 'http://apache.xl-mirror.nl/flink/flink-1.1.3/flink-1.1.3-bin-hadoop27-scala_2.11.tgz',
  $install_method = 'package',
){
  validate_string(
    $archive_source,
    $install_method,
  )
  class { '::flink':
    archive_source => $archive_source,
    install_method => $install_method,
  }
}
