#!/bin/bash
#place your comment for this uptade here:
comment=""




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
echo "-------------------------------------------------------------------------------------------------------------"
#insert comment into "info.txt"
if SVN_VERSION="$(svnversion . )"; then
 let "SVN_VERSION=$(echo ${SVN_VERSION##*:} | tr -d '[:alpha:]') + 1"
 #echo "Subversion=$SVN_VERSION"
fi
date=$(date +%Y%m%d-%H%M)
#DSTI="./trunk/speed-to-fritz/info.txt"
#grep -q "${comment}" ${DSTI} || sed -i -e "/### --- START --- ###/a\
#${date}-r-$SVN_VERSION\n    - ${comment}" "${DSTI}"
DSTISP2FR="./trunk/speed-to-fritz"
DSTI="$DSTISP2FR/sp-to-fritz.sh"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d) 
sed -i -e "s/Tag=\"..\"; Monat=\"..\"; Jahr=\"..\"/Tag=\"${Day}\"; Monat=\"${Month}\"; Jahr=\"${Year}\"/" "${DSTI}"
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit
sed -i -e "/Subversion Log:/,/ENDE/d" "$DSTISP2FR/info.txt"
echo " Subversion Log:" >>"$DSTISP2FR/info.txt"
echo "------------------------------------------------------------------------" >>"$DSTISP2FR/info.txt"


#svn delete --force ./download_speed-to-fritz.sh
#svn delete --force ./patch.diff
#svn add * --force
#svn propedit svn:ignore trunk
cd trunk
#sleep 20
#svn delete --force ./speed-to-fritz/info.txt
#svn delete --force ./speed-to-fritz/info.txt.r79
#svn delete --force ./speed-to-fritz/info.txt.mine
#svn delete --force ./speed-to-fritz/info.txt.r130
#svn delete --force ./speed-to-fritz/info.txt.r131
#svn delete --force ./speed-to-fritz/conf-920-freetz
#svn delete --force ./speed-to-fritz/start-920

#svn delete --force ./speed-to-fritz/alien/add_dect_7150.inc
#svn delete --force ./speed-to-fritz/alien/subscripts/500.init
#svn delete --force ./speed-to-fritz/alien/subscripts/501.init
#svn delete --force ./speed-to-fritz/alien/subscripts/701.init
#svn delete --force ./speed-to-fritz/alien/subscripts/900.init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_dect.47.sh
#svn delete --force ./speed-to-fritz/alien/subscripts/inc_func_init
#svn delete --force ./speed-to-fritz/alien/subscripts/add_settings.sh
#svn delete --force ./speed-to-fritz/alien/patches/add_tam_en.47.patch
#svn delete --force ./speed-to-fritz/alien/patches/add_tamhelp_en.47.patch
#svn delete --force ./speed-to-fritz/subscripts2/copy_tr064_files

#svn revert 
svn add * --force

svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"
[ "$YESNO" = "y" ] && sed -i -e "s/svn diff .*$/svn diff -r $SVN_VERSION  > \.\.\/$SVN_VERSION-to-local.diff/" -e "s/cat  \.\..*$/cat  \.\.\/$SVN_VERSION-to-local.diff/" "./diff.sh"

