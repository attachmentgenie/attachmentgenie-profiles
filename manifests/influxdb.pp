# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param vhosts (Hash)) Vhosts to manage.
class profiles::influxdb () {
  class {'influxdb::server':}
}
