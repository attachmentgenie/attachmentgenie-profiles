# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::scheduling::nomad::host_volume { 'foo': }
#
define profiles::scheduling::nomad::host_volume (
  Stdlib::Absolutepath $data_path,
  Enum['absent','directory'] $ensure = 'directory',
  Stdlib::Filemode $mode = '0777',
) {
  file { $name:
    ensure => $ensure,
    force  => true,
    mode   => $mode,
    path   => "${data_path}/${name}",
  }
}
