#
#
#
class profiles::alerting::icingaweb2::auth (
  String $bind_dn,
  String $bind_pw,
  String $hostname,
  String $ldap_userclass,
  String $root_dn,
  String $auth_type      = 'ldap',
  String $encryption     = 'none',
  String $ldap_filter    = '',
  Integer $port           = 389,
) {
  ::icingaweb2::config::resource{'ldap-resource':
    type            => $auth_type,
    host            => $hostname,
    port            => $port,
    ldap_encryption => $encryption,
    ldap_root_dn    => $root_dn,
    ldap_bind_dn    => $bind_dn,
    ldap_bind_pw    => $bind_pw
  }

  ::icingaweb2::config::authmethod {'ldap-auth':
    backend                  => $auth_type,
    resource                 => 'ldap-resource',
    ldap_user_class          => $ldap_userclass,
    ldap_filter              => $ldap_filter,
    ldap_user_name_attribute => 'uid',
    order                    => '01',
  }
}
