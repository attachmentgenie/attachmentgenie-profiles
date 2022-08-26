# This class can be used install zookeeper components.
#
# @example when declaring the zookeeper class
#  class { '::profiles::streaming::zookeeper': }
#
# @param cdhver               Cloudera RPM Repo version.
# @param cfg_dir              Zookeeper configuration directory.
# @param cleanup_sh           Location to zkCleanup.sh
# @param initialize_datastore Create datastore.
# @param install_method       Install method.
# @param manage_service_file  Manage service file.
# @param packages             List of pacakages to install.
# @param repo                 Repository name.
# @param service_name         Service name.
# @param zoo_dir              Zookeeper directory.
class profiles::streaming::zookeeper (
  String $cdhver = '5',
  String $cfg_dir = '/opt/zookeeper/conf',
  String $cleanup_sh = '/opt/zookeeper/bin/zkCleanup.sh',
  Boolean $initialize_datastore = false,
  String $install_method = 'package',
  Array $packages = ['zookeeper'],
  Optional[String] $repo = undef,
  String $service_name = 'zookeeper',
  String $zoo_dir = '/opt/zookeeper'
) {
  class { 'zookeeper':
    cdhver               => $cdhver,
    cfg_dir              => $cfg_dir,
    cleanup_sh           => $cleanup_sh,
    initialize_datastore => $initialize_datastore,
    install_method       => $install_method,
    manage_service_file  => true,
    packages             => $packages,
    repo                 => $repo,
    service_name         => $service_name,
    zoo_dir              => $zoo_dir,
  }
}
