# Reset PATH with only the linux definitions. This is useful for WSL if you
# don't want all the windows PATH to be appended to your WSL PATH.
export PATH=$(echo "$PATH" | sed 's#/mnt/c/[^:]*:\?##g')
