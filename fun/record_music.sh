#!/bin/bash

if ! command -v play &> /dev/null
then
    echo "SoX not found. Installing."
    sudo apt-get install sox -y
fi

input_fpath=$1
output_fpath=$2

source constants.sh || exit 1
source $input_fpath

if [ -z "$MUSIC" ]; then
    echo "MUSIC variable not defined by file $input_fpath."
    echo "Please check if its format is as expected"
    exit 1
fi

function sumf {
    echo $1 + $2 | bc
}

next_sleep=0
next_note_delay=0
acc_delay=0
play_delays=
apply_delay_now=false
i=0
while [ $i -lt ${#MUSIC[@]} ]; do
    play_note=${MUSIC[$i]}
    play_delay=${MUSIC[$((i+1))]}
    if [ "$play_note" = "$PAUSE" ]; then
	# Don't add note, just accumulate
	apply_delay_now=false
	acc_delay=$(sumf $acc_delay $play_delay)
	play_delay=0
    else
	# Add note
	play_notes="$play_notes pl $play_note"

	if [ "$apply_delay_now" = "true" ]; then
	    # Apply delay in this note
	    acc_delay=$(sumf $acc_delay $play_delay)
	    play_delays="$play_delays $acc_delay"
	    play_delay=0
	    apply_delay_now=false
	else
	    # Apply delay in the next note
	    play_delays="$play_delays $acc_delay"
	    acc_delay=$(sumf $acc_delay $play_delay)
	fi
    fi
    i=$((i + 2))
done
# Must wait for the last note to complete
acc_delay=$(sumf $acc_delay $play_delay)


echo "Saving music to $output_fpath"
function error_recording_music {
    echo "Error recording music"
    exit 1
}
sox -n -r 16000 -b 16 $output_fpath synth $play_notes delay $play_delays remix - fade 0 $acc_delay .5 norm -1 || error_saving_music
echo "Done"
