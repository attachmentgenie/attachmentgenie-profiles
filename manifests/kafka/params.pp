class profiles::kafka::params {
  $advertised_hostname = $::ipaddress
  $hostname            = $::ipaddress
}
