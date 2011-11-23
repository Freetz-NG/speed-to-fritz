#!/bin/bash
HOME="$(pwd)"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d)
DVERSION="20$Year$Month$Day"
echo "DVERSION: $DVERSION"
#DVERSION="20100615"

## download latest source devel from svn
echo "Wait for connection coLinux svn ..."
svn co http://colinux.svn.sourceforge.net/svnroot/colinux/branches/devel-64bit colinux64-${DVERSION}
cd colinux64-${DVERSION}
#sleep 20
cd ..
# echo "Pack source again ..."
# pack for use with prepacked stuff 
# tar -zcf colinux-0.7.8-${DVERSION}.src.tgz colinux-${DVERSION}
cd colinux64-${DVERSION}
./configure --target=x86_64-w64-mingw32 \
    --downloaddir=$HOME/MinGW64/downloads \
    --prefix=$HOME/MinGW64/gcc445 \
&& make download && make clean && make && make package
cd ..
echo "!!ENDE!!"
sleep 1000
