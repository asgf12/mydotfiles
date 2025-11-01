#!/usr/bin/env bash

name=$(pwd | awk -F '/' '{print $NF}')

fd -t d | while IFS= read -r l; do
    L=${l:0:-1}
    n=$name"_"$L".pdf"
    echo "processing: $n"
    cd "$l"
    magick *.jpg -auto-orient "../$n"
    cd ..
done
