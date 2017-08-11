# This class can be used to setup flink.
#
# @example when declaring the node role
#  class { '::profiles::flink': }
#
# @param archive_source Flink Download url.
# @param install_method How to install flink.
class profiles::streaming::flink (
  String $archive_source = 'http://apache.xl-mirror.nl/flink/flink-1.3.2/flink-1.3.2-bin-hadoop27-scala_2.11.tgz',
  String $install_method = 'package',
){
  class { '::flink':
    archive_source => $archive_source,
    install_method => $install_method,
  }
}
