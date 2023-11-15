## MODULES #####################################################################

# See currently loaded modules
lsmod

# See all modules
find /lib/modules/$(uname -r) -type -f -name "*.ko"

# Load module. Replace "rtw88_8821ce" with module name
sudo modprobe rtw88_8821ce

## PCI #########################################################################

# Find wireless PCIs
lspci | grep -i wireless

# Find specific PCI
lspci -v -s 01:00.0

# Show internet devices and their status
ip link show
