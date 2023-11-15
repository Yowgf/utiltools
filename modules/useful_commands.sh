# See currently loaded modules
lsmod

# See all modules
find /lib/modules/$(uname -r) -type -f -name "*.ko"

# Load module. Replace "rtw88_8821ce" with module name
sudo modprobe rtw88_8821ce
