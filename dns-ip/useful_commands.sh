#!/usr/env sh

# Check BIND configuration files for syntax errors.
named-checkconf

# Check BIND zone files for syntax errors.
named-checkzones

# Resolve domain names, IPV4 and IPv6 addresses, DNS resource records, and
# services; introspect and reconfigure the DNS resolver.
#
# Equivalent to `resolvectl`
systemd-resolve
