# This class can be used install nodejs
#
# @example when declaring the nodejs class
#  class { '::profiles::nodejs': }
#
# @param npm_packages (Hash) list of packages to install using npm
# @param packages (Hash) list of packages to install
class profiles::nodejs (
  $npm_packages = {},
  $packages = {},
){
  class { '::nodejs': }
  $npm_package_defaults = {
    provider => 'npm',
  }
  create_resources('package',$npm_packages, $npm_package_defaults)
  create_resources('package',$packages)
}
