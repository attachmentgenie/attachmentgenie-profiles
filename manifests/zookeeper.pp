# This class can be used install zookeeper components.
#
# @example when declaring the zookeeper class
#  class { '::profiles::zookeeper': }
#
# @param zookeeper_connect (Hash) zookeeper config settings.
class profiles::zookeeper (
  $cdhver               = '5',
  $cfg_dir              = '/opt/zookeeper/conf',
  $cleanup_sh           = '/opt/zookeeper/bin/zkCleanup.sh',
  $initialize_datastore = false,
  $manage_service_file  = true,
  $packages             = ['zookeeper'],
  $repo                 = undef,
  $service_name         = 'zookeeper',
  $zoo_dir              = '/opt/zookeeper'
) {
  validate_array(
    $packages,
  )
  validate_string(
    $cdhver,
  )
  if $repo != undef {
    validate_string(
      $repo,
    )
  }
  class { '::zookeeper':
    cdhver               => $cdhver,
    cfg_dir              => $cfg_dir,
    cleanup_sh           => $cleanup_sh,
    initialize_datastore => $initialize_datastore,
    manage_service_file  => $manage_service_file,
    packages             => $packages,
    repo                 => $repo,
    service_name         => $service_name,
    zoo_dir              => $zoo_dir,
  }
}