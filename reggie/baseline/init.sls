# ============================================================================
# Baseline configuration expected in every reggie server.
# ============================================================================

# Make sure the locale is "en_US.UTF-8". Ubuntu 18.04 defaults to "en_US",
# and the Ubuntu PostgreSQL package uses the system locale to configure the
# database defaults. We require "UTF-8" for our database, so this must be
# run BEFORE the PostgreSQL package is installed.
reggie update-locale LANG="en_US.UTF-8":
  cmd.run:
    - name: update-locale LANG="en_US.UTF-8"
    - unless: grep -q -E "LANG=[\"']?en_US.UTF-8[\"']?" /etc/default/locale
    - order: 0
    - require_in:
      - sls: glusterfs.server
      - sls: glusterfs.client
      - sls: haproxy
      - sls: nginx
      - sls: postgres
      - sls: rabbitmq
      - sls: redis.server
      - sls: reggie.db

# Make sure rsyslog is installed and running
reggie rsyslog installed and running:
  pkg.installed:
    - name: rsyslog

  service.running:
    - name: rsyslog
    - enable: True
    - require:
      - pkg: rsyslog
