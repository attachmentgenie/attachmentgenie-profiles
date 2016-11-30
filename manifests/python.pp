# This class can be used install user python properties
#
# @example when declaring the apache class
#  class { '::profiles::python': }
#
# @param python_pips (Hash) List of pip packages to install.
# @param use_epel (Boolean) Manage epel repository.
class profiles::python (
  $python_pips = {},
  $use_epel    = false
) {
  class { '::python' :
    dev         => 'present',
    gunicorn    => 'absent',
    pip         => 'present',
    python_pips => $python_pips,
    version     => 'system',
    use_epel    => $use_epel,
    virtualenv  => 'absent',
  }
}