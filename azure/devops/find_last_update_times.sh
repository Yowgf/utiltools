#!/bin/bash

projects_dir="${1:-projects}"
cd "$projects_dir"
while read -r project; do
    cd "$project"
    while read -r repo; do
        cd "$repo"
        time_unix=$(git log -1 --format="%at" 2>&1)
        if [ $? = 0 ]; then
            time_iso=$(date -Iseconds -d @$time_unix 2>/dev/null)
        else
            echo "Repo $repo is probably empty (no commits in default branch)" 1>&2
            time_iso=
        fi
        last_update_times="$last_update_times$(printf '%s,%s,%s' "$project" "$repo" "$time_iso")
"
        cd ..
    done <<< $(ls)
    cd ..
done <<< $(ls)
cd ..
echo "$last_update_times"
