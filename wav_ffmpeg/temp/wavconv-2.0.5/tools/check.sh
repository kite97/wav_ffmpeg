#!/bin/bash

while read file; do
    name=$(basename $file .amr)
    dir=$(dirname $file)
    nbfile=${dir}/${name}_7.amr
    wbfile=${dir}/${name}_wb_8.amr
    if [ ! -e $nbfile ]; then
        echo  "Error: $nbfile not exist"
    fi
    if [ ! -e $wbfile ]; then
        echo  "Error: $wbfile not exist"
    fi
    if [ -e $nbfile -a -e $wbfile ]; then 
        echo "Pass: $file trans succ"
    fi
done
exit 0
