#!/bin/bash
version=$(cat ./version)
cd ../../
#assume diricrry is now ../co 
echo "Skriptversion: $version"
echo "---------------------------------------------------------------------------------------------------------------"
[ -d ./co/bfin-colinux ] && rm -R ./co/bfin-colinux
tar cfv /mnt/and/co.1.${version}.tar -C . ./co
ls /mnt/and/co.1.${version}.tar

