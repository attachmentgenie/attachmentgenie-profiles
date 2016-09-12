class profiles::collectd (
  $fqdnlookup                              = false,
  $graphitehost                            = 'graphite-gold.europe.intranet',
  $graphiteport                            = 2003,
  $minimum_version                         = '5.4',
  $package_ensure                          = undef,
  $purge                                   = true,
  $purge_config                            = true,
  $recurse                                 = true,
  $write_graphite                          = true,
) {
  # validate boolean params
  validate_bool(
    $fqdnlookup,
    $purge,
    $purge_config,
    $recurse,
    $write_graphite
  )

  # validate integer params
  validate_integer(
    $graphiteport,
  )

  # validate string parameters
  validate_string($graphitehost)

  class { '::collectd':
    fqdnlookup      => $fqdnlookup,
    package_ensure  => $package_ensure,
    purge           => $purge,
    purge_config    => $purge_config,
    recurse         => $recurse,
    minimum_version => $minimum_version,
  }
}