# This class can be used install rundeck components.
#
# @example when declaring the rundeck class
#  class { '::stacks::rundeck': }
#
# @param projects (Hash) Projects to manage
class profiles::rundeck (
  $projects = {},
) {
  validate_hash(
    $projects,
  )
  class { '::rundeck': }
  create_resources(rundeck::config::project, $projects)
}