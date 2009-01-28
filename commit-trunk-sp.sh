#!/bin/bash
#place your comment for this uptade here:
comment="W920: 7270 menuoption PHONE used for prerelaese, to be compatibel with freetz"




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
date=$(date +%Y%m%d-%H%M)
DSTI="./trunk/speed-to-fritz/info.txt"
grep -q "${comment}" ${DSTI} || sed -i -e "/Dont remove this line, becaus it is used for autoinserting/a\
${date}\n    - ${comment}" "${DSTI}"
DSTI="./trunk/speed-to-fritz/sp-to-fritz.sh"
Year=$(date +%y)
Month=$(date +%m)
Day=$(date +%d)
sed -i -e "s/Tag=\"..\"; Monat=\"..\"; Jahr=\"..\"/Tag=\"${Day}\"; Monat=\"${Month}\"; Jahr=\"${Year}\"/" "${DSTI}"
echo "-------------------------------------------------------------------------------------------------------------"
sleep 2
#exit

#svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
#svn update https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk trunk
cd trunk
svn add * --force
#svn delete --force ./speed-to-fritz/ftp192
#svn revert 
#svn add speed-to-fritz
svn status
svn diff > ../patch.diff
cat ../patch.diff
echo -n "   Execute Commit?'  (y/n)? "; read -n 1 -s YESNO; echo
([ "$YESNO" = "y" ] || [ "$YESNO" = "n" ]) || echo "wrong key!"
[ "$YESNO" = "y" ] &&   svn commit --message "${date} - ${comment}"


 