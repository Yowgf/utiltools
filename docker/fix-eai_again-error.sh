# EAI_AGAIN has been caused by DNS issues in the past for me.
#
# Try the following:
#
# Write the following to /etc/docker/daemon.json:
#
# {
#   "dns": ["8.8.8.8", "1.1.1.1"]
# }
#
# Restart docker daemon: `sudo systemctl restart docker`
