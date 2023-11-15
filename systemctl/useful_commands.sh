# Check all services that are enabled (will be started upon boot)
sudo systemctl list-unit-files --type=service --state=enabled --all

# Follow system logs
journalctl --system -f
