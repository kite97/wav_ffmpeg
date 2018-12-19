#!/bin/bash
allfilenames=$1
split -l 100 -d -a 5 ${allfilenames} tasks/${allfilenames}_
files=$(find tasks/ -type f -name "${allfilenames}*")
for file in ${files}; do
	basename ${file} >> ${allfilenames}_task.index
done
