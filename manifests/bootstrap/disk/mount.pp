# This class can be used install user mount properties
#
# @example when declaring the mount defined type
#  ::profiles::bootstrap::disk::mount{'/dev/sdb': }
#
define profiles::bootstrap::disk::mount (
  Stdlib::Absolutepath $device,
  Boolean $createfs = true,
  Enum['absent', 'present'] $ensure = present,
  Enum['ext4','xfs'] $fs_type = 'ext4',
  Stdlib::Absolutepath $mountpath = $name,
  Boolean $mounted = true,
) {
  $_mount_ensure    = $ensure ? {
    'absent' => absent,
    default  => $mounted ? {
      true      => mounted,
      false     => present,
    }
  }

  $_mount_options = $fs_type ? {
    'xfs'   => '',
    default => '-F'
  }

  if $createfs {
    filesystem { $device:
      ensure  => $ensure,
      fs_type => $fs_type,
      options => $_mount_options,
    }
  }

  if $createfs or $ensure != 'present' {
    exec { "ensure mountpoint '${mountpath}' exists":
      path    => ['/bin', '/usr/bin'],
      command => "mkdir -p ${mountpath}",
      unless  => "test -d ${mountpath}",
      before  => Mount[$mountpath],
    }

    mount { $mountpath:
      ensure => $_mount_ensure,
      name   => $mountpath,
      device => $device,
      fstype => $fs_type,
      atboot => true,
    }
  }

  if $ensure == 'present' and $createfs {
    Filesystem[$device]
    -> Mount[$mountpath]
  } elsif $ensure != 'present' and $createfs {
    Mount[$mountpath]
    -> Filesystem[$device]
  }
}
