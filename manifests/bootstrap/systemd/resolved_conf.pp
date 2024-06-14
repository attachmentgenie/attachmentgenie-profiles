# @summary Create resolevd ini config files.
#
# Build files based on setttings passed
#
# @example
#   profiles::bootstrap::systemd::resolved_conf { 'namevar': }
define profiles::bootstrap::systemd::resolved_conf (
  Hash $settings,
  Stdlib::Absolutepath $resolved_conf_dir = '/etc/systemd/resolved.conf.d',
) {
  $defaults = { 'path' => "${resolved_conf_dir}/${name}.conf" }
  inifile::create_ini_settings($settings, $defaults)
}
