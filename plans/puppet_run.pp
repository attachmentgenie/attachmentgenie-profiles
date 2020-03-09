plan profiles::puppet_run (
  TargetSpec $targets,
) {
  return run_command("/opt/puppetlabs/bin/puppet agent -t", $targets, _catch_errors => true)
}