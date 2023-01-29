# For more DNS-related commands, see folder 'dns' under project root.

dig

gping <address>

host <address>

netstat -p tcp

nslookup <address>

ping <address>

traceroute <address>

whois <address>

ip a

# Disable ipv6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
