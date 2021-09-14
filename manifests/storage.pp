# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage
class profiles::storage (
  Boolean $ceph = false,
  Boolean $gluster = false,
  Boolean $minio = false,
) {
  if $ceph {
    class { '::profiles::storage::ceph': }
  }
  if $gluster {
    class { '::profiles::storage::gluster': }
  }
  if $minio {
    class { '::profiles::storage::minio': }
  }
}
