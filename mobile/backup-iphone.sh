#!/bin/bash

idevicepair pair
mkdir ~/iphone
ifuse ~/iphone/
idevicebackup2 backup ~/iphone-backup
idevicebackup2 info ~/iphone-backup

# Note: you need the libraries from `apt install libimobiledevice-utils ifuse`

# To unmount, run `fusermount -u ~/iphone`
