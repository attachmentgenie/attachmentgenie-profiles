task profiles::r10k_deploy (
  String $environment = '',
  TargetSpec $targets = 'puppet',
) {
  return run_command("/opt/puppetlabs/puppet/bin/r10k deploy environment ${environment} -pv", $targets, _catch_errors => true)
}