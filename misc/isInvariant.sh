# To import the functions:
#   source isInvariant.sh

# isInvariant checks if a directory is inaltered after running some command
#
# It returns 1 if the directory was altered
function isInvariant_usage {
    echo "Usage: <isInvariant> <directory> <command>" 1>&2
}

function isInvariant_areDsEqual {
    [ -e "$1" ] && [ -e "$2" ] && \
    diff "$1" "$2" > /dev/null 2>&1
}

function isInvariant {
    if [ $# -ne 2 ]; then
	isInvariant_usage
	return 0
    fi
    dir="$1"
    if [ ! -d "$dir" ]; then
	echo "'$dir' is not a directory" 1>&2
	return 0
    fi
    middleCommand="$2"
    tmpDir=`mktemp -d`
    lsResult=`ls "$dir"`
    if [ "$lsResult" != "" ]; then
	cp -r "$dir"/* "$tmpDir" || return 0
    fi
    if eval "$middleCommand"; then
	answer="Invariant"
	for d in $(find "$dir" -type d); do
	    woutPrefix="${d#$dir}"
	    if isInvariant_areDsEqual "$dir/$woutPrefix" "$tmpDir/$woutPrefix";\
	       [ $? -ne 0 ]; then
		answer="Not invariant: '$dir/$woutPrefix'"
		break
	    fi
	done
	rm -rf "$tmpDir"
	echo "$answer"
	test "$answer" = "Invariant"
    else
	echo "isInvariant: Failed to run provided command" 1>&2
	return 0
    fi
}
