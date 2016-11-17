# This class can be used install neo4j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::neo4j': }
#
class profiles::neo4j {
  class { '::neo4j' :
    install_java   => false,
  }
}