spd-say "Hello"

espeak

while true; do play -q -v 100 -n synth  .$(( $RANDOM % 51 ))1  sine $((200 + $RANDOM % 4000 )) &> /dev/null; done
