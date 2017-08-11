# This class can be used install nodejs
#
# @example when declaring the nodejs class
#  class { '::profiles::runtime::nodejs': }
#
# @param manage_repo        Manage repo.
# @param npm_package_ensure Install npm.
# @param npm_packages       List of packages to install using npm
# @param packages           List of packages to install
class profiles::runtime::nodejs (
  Boolean $manage_repo = false,
  String $npm_package_ensure = 'installed',
  Hash $npm_packages = {},
  Hash $packages = {},
){
  class { '::nodejs':
    manage_package_repo => $manage_repo,
    npm_package_ensure  => $npm_package_ensure,
  }
  $npm_package_defaults = {
    provider => 'npm',
  }
  create_resources('package',$npm_packages, $npm_package_defaults)
  create_resources('package',$packages)
}
