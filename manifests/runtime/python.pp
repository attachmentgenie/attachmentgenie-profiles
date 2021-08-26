# This class can be used install user python properties
#
# @example when declaring the python class
#  class { '::profiles::runtime::python': }
#
# @param manage_repo  Manage epel repository.
# @param pip_packages List of pip packages to install.
# @param packages     List of packages to install
class profiles::runtime::python (
  Boolean $manage_repo = false,
  Hash $packages = {},
  Hash $pip_packages = {},
) {
  class { '::python' :
    dev         => 'present',
    gunicorn    => 'absent',
    pip         => 'present',
    python_pips => $pip_packages,
    version     => 'system',
    use_epel    => $manage_repo,
  }
  create_resources('package',$packages)
}