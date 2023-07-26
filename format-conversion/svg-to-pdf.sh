#!/bin/bash

in=$1
out=$2

[ -z "$in" ] && exit 1
[ -z "$out" ] && exit 1

rsvg-convert -f pdf -o "$out" "$in"
