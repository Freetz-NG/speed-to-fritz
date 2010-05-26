#!/bin/bash
#do compile -->
## download devel from svn
#svn co http://colinux.svn.sourceforge.net/svnroot/colinux/devel devel
## or get alternativ source
## [ -f ./colinux-0.7.8-20100520.src.tgz ] || wget "http://www.henrynestler.com/colinux/autobuild/devel-20100520/colinux-0.7.8-20100520.src.tgz"
## tar xzf colinux-0.7.8-20100520.src.tgz
## cd colinux-20100520
cd devel
## get patches
# [ -f linux-2.6.33-co-$DVERSION.patch.gz ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/linux-2.6.33-co-$DVERSION.patch.gz"
# [ -f patches-2.6.33-$DVERSION.tgz ] || wget "http://www.henrynestler.com/colinux/testing/kernel-2.6.33/patches-2.6.33-$DVERSION.tgz"
# tar xzf linux-2.6.33-co-$DVERSION.patch.gz
# tar xzf patches-2.6.33-$DVERSION.tgz
# (cat *.patch | patch -p0)
## remove patch -- has to be done 
#sleep 1000
./configure && make clean && make && make package
cd ..
sleep 1000
