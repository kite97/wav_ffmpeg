#!/bin/bash
TIME="2016-03-01 00:00:00 +0800"
touch -d "${TIME}" timestamp.$$
find $@ -type f -newer timestamp.$$ > ~/filelist.20160324
rm timestamp.$$
exit 0
