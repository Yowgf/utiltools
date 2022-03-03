file_suffix=$1

find ./ -path ./.git -prune -o -type f -name "*${file_suffix}" -exec wc -l {} \; |
    awk 'BEGIN{sum=0}; {sum += $1} END{print sum}'
