#!/bin/bash
FILELIST="${HOME}/filelist.20160324"
#cat ${FILELIST}|xargs -i{} cp $HOME/ring/amrbak/{} $HOME/ring/amr/{}
cat ${FILELIST}|xargs -i{} cp llll/{} test/{}
exit 0
