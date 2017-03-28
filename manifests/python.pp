# This class can be used install user python properties
#
# @example when declaring the python class
#  class { '::profiles::python': }
#
# @param manage_repo (Boolean) Manage epel repository.
# @param pip_packages (Hash) List of pip packages to install.
# @param packages (Hash) list of packages to install
class profiles::python (
  $manage_repo = false,
  $packages = {},
  $pip_packages = {},
) {
  class { '::python' :
    dev         => 'present',
    gunicorn    => 'absent',
    pip         => 'present',
    python_pips => $pip_packages,
    version     => 'system',
    use_epel    => $manage_repo,
    virtualenv  => 'absent',
  }
  create_resources('package',$packages)
}