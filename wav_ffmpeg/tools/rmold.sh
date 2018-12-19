#!/bin/bash
while read file;  do
    name=$(basename $file .amr)
    dir=$(dirname $file)
    maybenb=${file}_nb_7.amr
    rm -v $file $maybenb
done
exit 0
