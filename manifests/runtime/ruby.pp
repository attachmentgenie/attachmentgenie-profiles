# This class can be used install ruby
#
# @example when declaring the ruby class
#  class { '::profiles::runtime::ruby': }
#
# @param gem_packages List of packages to install using gem
# @param packages     List of packages to install
class profiles::runtime::ruby (
  Hash $gem_packages = {},
  Hash $packages = {},
) {
  class { '::ruby':
    gems_version => 'latest',
  }
  class  { '::ruby::dev': }
  $gem_package_defaults = {
    provider => 'gem',
  }
  create_resources('package',$gem_packages, $gem_package_defaults)
  create_resources('package',$packages)
}