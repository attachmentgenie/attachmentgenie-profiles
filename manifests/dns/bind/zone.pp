# This class can be used to create a bind9 zone
#
# @example when declaring the bind class
#  ::profiles::dns::bind::zone { 'foo.bar': }
#
define profiles::dns::bind::zone () {
  ::dns::zone { $name: }
}