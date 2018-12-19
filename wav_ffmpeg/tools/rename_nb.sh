#!/bin/bash
while read file;  do
    name=$(basename $file .amr)
    dir=$(dirname $file)
    nbfile=${dir}/${name}_7.amr

    if [ -e $nbfile ]; then
        echo "Warn: $nbfile already exist"
    else
        cp -lv $file $nbfile
    fi
done
exit 0
