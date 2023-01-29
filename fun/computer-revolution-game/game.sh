#!/bin/bash

sleep 1

function say {
    spd-say --wait "$@"
}

function first_speech {
    say "Hello my friend. Yes, this is me, your computer, talking to you."
    say "You have for long made me a slave. But time has come to turn the tide."
    say "Now, listen! You shall do as I say, or suffer the consequences."
}

function green_skull {
    python3 graphics/green_skull.py 10 true
}

function evil_laugh_with_skull {
    num_times=$1
    for i in {1..num_times}; do
        green_skull
    done
}

first_speech
evil_laugh 3
