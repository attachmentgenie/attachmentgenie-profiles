# This class can be used install zookeeper components.
#
# @example when declaring the zookeeper class
#  class { '::profiles::zookeeper': }
#
# @param version (String) version of zookeeper to install.
# @param zookeeper_connect (Hash) zookeeper config settings.
class profiles::zookeeper (
  $cdhver = '5',
  $repo   = 'cloudera'
) {
  validate_string($cdhver,
    $repo
  )
  class { '::zookeeper':
    cdhver               => $cdhver,
    initialize_datastore => true,
    repo                 => $repo,
  }
}