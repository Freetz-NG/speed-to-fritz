#!/bin/bash
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d)
DVERSION="20$Year$Month$Day"
echo "DVERSION: $DVERSION"
#DVERSION="20100615"
## get patches
#[ -f linux-2.6.33.4-co-$DVERSION.patch.gz ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/linux-2.6.33.4-co-$DVERSION.patch.gz"
#[ -f patches-2.6.33.4-$DVERSION.tgz ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/patches-2.6.33.4-$DVERSION.tgz"
## download latest source devel from svn
echo "Wait for connection coLinux svn ..."
svn co http://colinux.svn.sourceforge.net/svnroot/colinux/branches/devel colinux-${DVERSION}
## or get alternativ source
## [ -f ./colinux-0.7.8-20100520.src.tgz ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-20100520/colinux-0.7.8-20100520.src.tgz"
## tar xzf colinux-0.7.8-20100520.src.tgz
## cd colinux-20100520
cd colinux-${DVERSION}
#tar xzf ../linux-2.6.33.4-co-$DVERSION.patch.gz
###tar vxzf ../patches-2.6.33.4-$DVERSION.tgz
###cat *.patch | patch -p0
## remove inside patch -- has to be done but needed
#sleep 20
cd ..
echo "Pack source again ..."
# pack for use with prepacked stuff 
tar -zcf colinux-0.7.8-${DVERSION}.src.tgz colinux-${DVERSION}
cd colinux-${DVERSION}
./configure && make clean && make && make package
cd ..
echo "!!ENDE!!"
sleep 1000
