#
# Wrapper around ::icinga2::object::checkcommand to ensure that there are no duplicates.
#
define profiles::monitoring::icinga2::checkcommand (
  $target,
  $ensure            = present,
  $checkcommand_name = $title,
  $import            = ['plugin-check-command'],
  $command           = undef,
  $env               = undef,
  $vars              = undef,
  $timeout           = undef,
  $arguments         = undef,
  $template          = false,
  $order             = '15',
) {
  $_config_hash = {
    $checkcommand_name  => {
    'target'            => $target,
    'ensure'            => $ensure,
    'checkcommand_name' => $checkcommand_name,
    'import'            => $import,
    'command'           => $command,
    'env'               => $env,
    'vars'              => $vars,
    'timeout'           => $timeout,
    'arguments'         => $arguments,
    'template'          => $template,
    'order'             => $order,
    }
  }
  ensure_resource( ::icinga2::object::checkcommand, $_config_hash )
}
