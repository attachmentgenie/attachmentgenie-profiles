plan profiles::yum_update (
  TargetSpec $targets,
  Boolean $reboot = false,
) {
  $update = run_command("yum update -y", $targets, _catch_errors => true)
  if $reboot {
   run_task('reboot', $targets, _catch_errors => true)
  }

  return $update
}