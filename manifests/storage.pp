# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage
class profiles::storage (
  Boolean $minio = false,
) {
  if $minio {
    class { 'profiles::storage::minio': }
  }
}
