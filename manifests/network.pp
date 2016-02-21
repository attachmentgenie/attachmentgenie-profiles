class profiles::network (
  $motd = false,
) {

#  class { 'network::interfaces':
#    interfaces => {
#      'eth0' => {
#        'method' => 'dhcp',
#      }
#    },
#    auto       => ['eth0'],
#  }

  if $motd {
    motd::register{ 'Profile : network': }
  }
}