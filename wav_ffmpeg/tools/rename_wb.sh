#!/bin/bash
while read file;  do
    name=$(basename $file .amr)
    dir=$(dirname $file)
    wbfile=${dir}/${name}_wb_8.amr
    errwbfile=${file}_wb_8.amr

    if [ -e $wbfile ]; then
        echo "Warn: $wbfile already exist"
        if [ -e $errwbfile ]; then
            echo "Error: $errwbfile also exist"
        fi
    else
        mv -v $errwbfile $wbfile
    fi
done
exit 0
