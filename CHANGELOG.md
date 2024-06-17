# Changelog

## 4.0.0

- Update tp PDK 2.7
- Adding deep merge strategies for consul, icinga and grafana_agent
- Added version layer to hiera data
- Added incinga director
- Added sd and firewall settings for alertmanager
- icingaweb improvements
- Icingaweb plugin implementations
- Adding keepalived, network and systemd management
- Disk mount defined type
- Added example profile
- Added systctl entry defined type
- removed etcd profile
- Added sd and firewall settings for mongodb
- Added mongodb db defined type
- Added sd and firewall settings for mysql
- Added mysql db and user defined types
- Added sd and firewall settings for neo4j
- Added disk, sd and firewall settings for postgresql
- Added pgsql db and user defined types
- Added Loki and grafana-agent profile
- prometheus profile improvements
- blackbox_exporter profile
- graphite_exporter profile
- node_exporter profile
- pushgateway profile
- statsd_exporter profile
- promtail profile
- bolt profile
- consul profile improvements
- g10k and puppetboard profiles
- foreman profile improvements
- puppetdb improvements
- nexus profile
- runtime profile improvements
- nomad profile improvements
- template improvements

## 3.1.0

- Splitting resolv from dnsmasq.

## 3.0.0

- Conversion to PDK 1.11.
- Bumping version to $lastest for several technologies.
- Adding puppet 6 support.
- New bind, nomad, traefik and vault profiles.
- Adding data lookup options.
- Adding icingaweb auth, director and grafana functionality
- Adding fail2ban to firewall
- Adding firewall entry defined type.
- Adding toml and vault integration to puppetserver.
- Removing K8s stack.
- Adding HBA rules to pgsql.
- Updated grafana profile.
- Rewrites of aprlty, consul, foreman, php, rundeck profiles.
- Adding php-fpm and cachetool functionality to php.
- Moving dnsmasq out of consul into bootstrap.

## 2.1.0

- Modulesync update.
- Bumping version to $lastest for several technologies.
- Dropping puppet 3,4 support
- New dsnmasq, fail2ban, smashing profiles.
- Adding group support to accounts.
- Updates to aptly, ELK, puppet, prometheus, rundeck and icinga profiles.
- Added options to manage hiera.yaml, nginx streams and timezones.

## 2.0.0

- Modulesync update.
- Merging stacks and profiles modules into profiles.
- New aptly, consul, k8s and lets-encrypt profiles.

## 1.0.2

- Modulesync update.
- Allow empty accounts hash.
- Cleaning up inline docs.
- Adding metrics stack, including carbon, carbon_relay, statsd, graphite, grafana, uwsgi.
- Adding debian repositories.
- Bumping version to $lastest for several technologies.
- Rewrite of icinga, php, nginx, mongodb and foreman profiles.
- New docker and time profiles.

## 1.0.0

Initiial release of this module.
