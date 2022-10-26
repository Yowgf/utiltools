#!/bin/bash

prefix=$1

services=$(systemctl list-unit-files --type service --all | awk '{if (NR>1) print $1}' | grep "^${prefix}.*")
for service in $services; do sudo systemctl disable $service; done
