#!/bin/bash

input_file=$1
output_file=$2

# Convert file with hexadecimal characters to a file with binary format
xxd -r -p $input_file $output_file
