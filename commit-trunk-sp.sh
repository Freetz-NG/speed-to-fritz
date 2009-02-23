#!/bin/bash
#place your comment for this uptade here:
comment="W900/W701: update config.in to fritz_box-labor-13679.zip "




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
echo "-------------------------------------------------------------------------------------------------------------"
#insert comment into "info.txt"
if SVN_VERSION="$(svnversion . | tr ":" "_")"; then
 [ "${SVN_VERSION:0:6}" == "export" ] && SVN_VERSION=""
 [ "$SVN_VERSION" != "" ] && SVN_VERSION="-r-$SVN_VERSION"
fi
date=$(date +%Y%m%d-%H%M)
DSTI="./trunk/speed-to-fritz/info.txt"
grep -q "${comment}" ${DSTI} || sed -i -e "/Dont remove this line, becaus it is used for autoinserting/a\
${date}$SVN_VERSION\n    - ${comment}" "${DSTI}"
DSTI="./trunk/speed-to-fritz/sp-to-fritz.sh"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d) 
sed -i -e "s/Tag=\"..\"; Monat=\"..\"; Jahr=\"..\"/Tag=\"${Day}\"; Monat=\"${Month}\"; Jahr=\"${Year}\"/" "${DSTI}"
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit

svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk

cd trunk
#svn delete --force ./speed-to-fritz/ftp192
#svn delete --force ./speed-to-fritz/info.txt.r77
#svn delete --force ./speed-to-fritz/info.txt.r79
#svn delete --force ./speed-to-fritz/info.txt.mine
#svn delete --force ./speed-to-fritz/info.txt.r130
#svn delete --force ./speed-to-fritz/info.txt.r131

#svn delete --force ./speed-to-fritz/alien/add_dect_7150.inc
#svn delete --force ./speed-to-fritz/alien/subscripts/500.init
#svn delete --force ./speed-to-fritz/alien/subscripts/501.init
#svn delete --force ./speed-to-fritz/alien/subscripts/701.init
#svn delete --force ./speed-to-fritz/alien/subscripts/900.init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_dect.47.sh
#svn delete --force ./speed-to-fritz/alien/subscripts/inc_func_init
#svn delete --force ./speed-to-fritz/alien/patches/add_tam_en.47.patch
#svn delete --force ./speed-to-fritz/alien/patches/add_tamhelp_en.47.patch

#svn revert 
svn add * --force

svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"


