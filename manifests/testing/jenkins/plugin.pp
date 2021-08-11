# This class can be used to install a jenkins plugin
#
# @example when declaring this class
#  ::profiles::testing::jenkins::plugin { 'foo.bar': }
#
define profiles::testing::jenkins::plugin (
  Enum['hpi', 'jpi'] $extension = 'hpi',
  Optional[String] $version = undef,
){

  ::jenkins::plugin { $title:
    extension => $extension,
    version   => $version,
  }
}