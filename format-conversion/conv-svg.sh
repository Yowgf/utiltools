#!/usr/bin/env bash

set -ex

in_files="$@"

echo "In files: $in_files"

# Works for inkscape v1.0+
for in_file in $in_files; do
    out_file="${in_file%.svg}.png"
    inkscape --export-background-opacity=0 -w 1024 -h 1024 "$PWD/${in_file}" -o "$PWD/${out_file}"
done
