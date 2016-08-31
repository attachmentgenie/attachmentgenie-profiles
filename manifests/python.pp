class profiles::python (
  $python_pips = {},
) {
  class { '::python' :
    dev         => 'present',
    gunicorn    => 'absent',
    pip         => 'present',
    python_pips => $python_pips,
    version     => 'system',
    virtualenv  => 'absent',
  }
}
