# This class can be used install ruby
#
# @example when declaring the ruby class
#  class { '::profiles::ruby': }
#
# @param gem_packages (Hash) list of packages to install using gem
# @param packages (Hash) list of packages to install
class profiles::ruby (
  $gem_packages = {},
  $packages = {},
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