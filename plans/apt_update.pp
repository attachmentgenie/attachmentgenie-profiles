plan profiles::apt_update (
  TargetSpec $targets = 'prod',
) {
  return run_command("apt update -y; apt dist-upgrade -y;apt autoremove -y", $targets, _catch_errors => true)
}