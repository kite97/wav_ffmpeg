#!/bin/bash
FILELIST="${HOME}/filelist.20160324"
#cat ${FILELIST}|xargs -i{} dirname {}|xargs -i{} mkdir -p $HOME/ring/amr/{}
cat ${FILELIST}|xargs -i{} dirname {}|xargs -i{} mkdir -p ./test/{}
exit 0
