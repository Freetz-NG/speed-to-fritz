#!/bin/bash
#place your comment for this uptade here:
comment="W920: Addon of Option sr3 kdsldmod.co, by: abraXxl"




echo "-------------------------------------------------------------------------------------------------------------"
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/W920
echo "-------------------------------------------------------------------------------------------------------------"
#insert comment into "info.txt"
if SVN_VERSION="$(svnversion . )"; then
 let "SVN_VERSION=$(echo ${SVN_VERSION##*:} | tr -d '[:alpha:]') + 1"
 #echo "Subversion=$SVN_VERSION"
fi
date=$(date +%Y%m%d-%H%M)
DSTI="./W920/speed-to-fritz/info.txt"
grep -q "${comment}" ${DSTI} || sed -i -e "/### --- START --- ###/a\
${date}-r-$SVN_VERSION\n    - ${comment}" "${DSTI}"
DSTI="./W920/speed-to-fritz/sp-to-fritz.sh"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d) 
sed -i -e "s/Tag=\"..\"; Monat=\"..\"; Jahr=\"..\"/Tag=\"${Day}\"; Monat=\"${Month}\"; Jahr=\"${Year}\"/" "${DSTI}"
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit


cd trunk
#svn delete --force ./speed-to-fritz/ftp192
#svn delete --force ./speed-to-fritz/info.txt.r77
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

#svn revert 
svn add * --force

svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"
[ "$YESNO" = "y" ] && sed -i -e "s/svn diff .*$/svn diff -r $SVN_VERSION  > \.\.\/$SVN_VERSION-to-local.diff/" -e "s/cat  \.\..*$/cat  \.\.\/$SVN_VERSION-to-local.diff/" "./diff.sh"

