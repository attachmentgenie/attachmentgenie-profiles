plan profiles::yum_update (
  TargetSpec $targets,
) {
  return run_command('yum update -y', $targets, _catch_errors => true)
}