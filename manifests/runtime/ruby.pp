# This class can be used install ruby
#
# @example when declaring the ruby class
#  class { '::profiles::runtime::ruby': }
#
# @param gem_packages       List of packages to install using gem
# @param packages           List of packages to install
# @param rubygems_package   Rubygems package.
class profiles::runtime::ruby (
  Hash $gem_packages = {},
  Hash $packages = {},
  String $rubygems_package = 'rubygems',
) {
  class { '::ruby':
    gems_version     => 'latest',
    rubygems_package => $rubygems_package,
  }
  class  { '::ruby::dev': }
  $gem_package_defaults = {
    provider => 'gem',
  }
  create_resources('package',$gem_packages, $gem_package_defaults)
  create_resources('package',$packages)
}