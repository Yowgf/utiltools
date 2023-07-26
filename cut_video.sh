#!/bin/bash

start_time=$1
end_time=$2
input=$3
output=$4

# Cuts video using ffmpeg
#
# Example:
#
# start_time=00:01:00
# end_time=00:02:00
# input=input.mp4
# output=output.mp4
#
ffmpeg -ss "$start_time" -to "$end_time" -i "$input" -c copy "$output"
