class profiles::rsyslog_client (
  $motd = false,
){

  class { 'rsyslog::client': }

  if $motd {
    motd::register{ 'Profile : rsyslog_client': }
  }
}