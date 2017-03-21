# This class can be used install nodejs
#
# @example when declaring the nodejs class
#  class { '::profiles::nodejs': }
#
# @param manage_repo (Boolean) manage repo.
# @param npm_package_ensure (String) install npm.
# @param npm_packages (Hash) list of packages to install using npm
# @param packages (Hash) list of packages to install
class profiles::nodejs (
  $manage_repo = false,
  $npm_package_ensure = 'installed',
  $npm_packages = {},
  $packages = {},
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
