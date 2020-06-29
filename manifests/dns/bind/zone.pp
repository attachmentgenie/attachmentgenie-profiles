# This class can be used to create a bind9 zone
#
# @example when declaring the bind class
#  ::profiles::dns::bind::zone { 'foo.bar': }
#
define profiles::dns::bind::zone (
  Boolean $reverse = false,
  String $soa = $::fqdn,
  Optional[Stdlib::IP::Address::V4] $soaip = undef,
  Optional[Dns::UpdatePolicy] $update_policy = undef,
) {
  ::dns::zone { $name:
    reverse       => $reverse,
    soa           => $soa,
    soaip         => $soaip,
    update_policy => $update_policy,
  }
}