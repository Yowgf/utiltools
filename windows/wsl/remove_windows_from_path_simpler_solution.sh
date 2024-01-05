# Reset PATH with only the linux definitions. This is useful for WSL if you
# don't want all the windows PATH to be appended to your WSL PATH.
#
# Put this before any custom extensions of the PATH variable
export PATH=
export PATH=$(cat /etc/login.defs | \
  grep -E '^ENV_PATH\s+PATH=.+' | \
  awk '{$1="";print $0}' | \
  sed 's/^[ \t\r\n]*//')
