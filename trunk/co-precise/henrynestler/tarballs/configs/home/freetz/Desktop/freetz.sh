#!/bin/bash
##enable this if if you want to use the stabil freetz version
#FREETZ_DIR="freetz-1.1"
##enable this if if you want to use the latest version
FREETZ_DIR="trunk"
## insert the revision if you want to use a specific revision
#FREETZREVISION="XXXX"
#This skript should do the complete thing, no extra preparation should be needed if it runs within Ubuntu, andLinux or other 
#debian derivates. 
# dont change variables
export HOMEDIR="`pwd`"
echo
echo "The following script should do this for you:"
echo
echo "Installing or updating freetz"
echo "Updating your LINUX system and installing missing tools needed for freetz"
echo "invoking 'make menuconfig'"
echo "invoking 'make'"
#echo
echo "---------------------------------------------------------------------------------"

KEY="x"
echo
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "Login as normal user!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo "The update and install procedure has to be repeated until all errors are gone!"
 echo
 echo -n "   Do an update and installation of missing tools? (y/n)? "; read -n 1 -s YESNO; echo
 [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$YESNO" = "n" ] || [ "$YESNO" = "y" ] || echo "wrong key!"
 if [ "$YESNO" = "y" ]; then
	export EXTRAPKG=intltool
	. $HOMEDIR/install-tools2
 fi
done
KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo "Download freetz the first time, or do a freetz update?"
 echo
 echo "I case of problems do a 'make dirclean' at the commandline this will remove all changes made by you."
 echo "For using the commandline you must change to the $FREETZ_DIR directory first. 'cd $FREETZ_DIR'"  
 echo "To download a specific revision of the trunk you would need to set FREETZREVISION in advance!"
 echo
 
if [ "$FREETZREVISION" ]; then
 echo -n "   Execute: 'svn co http://svn.freetz.org/$FREETZ_DIR $FREETZ_DIR' -r $FREETZREVISION (y/n)? "; read -n 1 -s YESNO; echo
else
 echo -n "   Execute: 'svn co http://svn.freetz.org/$FREETZ_DIR $FREETZ_DIR'  (y/n)? "; read -n 1 -s YESNO; echo
fi
 [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 if [ "$YESNO" = "y" ]; then 
  rm -fr $HOMEDIR/$FREETZ_DIR/.config
  rm -fr $HOMEDIR/$FREETZ_DIR/Config.in
  rm -fr $HOMEDIR/$FREETZ_DIR/fwmod
  echo "Looking for new freetz version, wait ..."
    if [ "$FREETZREVISION" ]; then
	svn co http://svn.freetz.org/trunk $HOMEDIR/$FREETZ_DIR -r $FREETZREVISION
	export SVN_VERSION="$FREETZREVISION"
    else
	svn co http://svn.freetz.org/trunk $HOMEDIR/$FREETZ_DIR
    fi
 fi
 [ -d "$HOMEDIR/$FREETZ_DIR" ] || echo "freetz directory not found in the right place!"
 [ -d "$HOMEDIR/$FREETZ_DIR" ] || KEY="x"
done
echo
echo
#Set Freetz /dl Downloaddirectory to windows partition if existent to free up space needed for working, if andLinux is used 
WinPartitopn="/mnt/win/dl"
WinPartitopn=`echo "$WinPartitopn" | tr '/' '\/' `
[ -d "$WinPartitopn" ] || mkdir  "$WinPartitopn"
#echo "WinPartitopn:$WinPartitopn"
[ -d "$WinPartitopn" ] && sed -i -e "s|\(DL_DIR:=\).*$|\1${WinPartitopn}|" "$HOMEDIR/$FREETZ_DIR/Makefile"
[ -d "$WinPartitopn" ] && echo -e "\033[1mFreetz download directory is now set to windows partition:\033[0m ${WinPartitopn}" 
#get Downloaddirectory settings made in Freetz Makefile
eval `cat $HOMEDIR/$FREETZ_DIR/Makefile | grep  'DL_DIR:=' | tr -d ':'`
#echo "DL_DIR:=$DL_DIR"
DL_DIR_ABS=$HOMEDIR/$FREETZ_DIR/$DL_DIR
`cat $HOMEDIR/$FREETZ_DIR/Makefile | grep -q 'DL_DIR:=/'` && DL_DIR_ABS=$DL_DIR
[ -d "$DL_DIR_ABS" ] || mkdir  "$DL_DIR_ABS"
[ -d "$DL_DIR_ABS/fw" ] || mkdir  "$DL_DIR_ABS/fw"
echo
cd $HOMEDIR/$FREETZ_DIR
echo "--Image files present in '$DL_DIR_ABS/fw':"
ls -l $DL_DIR_ABS/fw/*.image 2>&1 | grep -v 'No such file' 
echo
echo "Now you can run 'make menuconfig', at the first time a lot of warnings will be displayed!"
echo "As next step run 'make'"
echo "Needed AVM firmware has to be copied to the '$DL_DIR_ABS/fw' directory first!"
echo
KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo "If started:" 
 echo "Ignore WARNINGS, especially the first time this tool is started!"
 echo
 echo -n "   Invoke 'make menuconfig' now? (y/n)? "; read -n 1 -s YESNO; echo
 [ "$YESNO" = "n" ] || [ "$YESNO" = "y" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 if [ "$YESNO" = "y" ]; then
  make menuconfig
 fi
done
KEY="x"
while [ "$KEY" != "y" ]; do
 echo 
 echo "If started:" 
 echo "Ignore WARNINGS, especially the first time this tool is started!"
 echo "Be prepared that the first time this could take one hour or more!"
 echo 
 echo -n "   Invoke 'make' now? (y/n)? "; read -n 1 -s YESNO; echo
 [ "$YESNO" = "n" ] || [ "$YESNO" = "y" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 if [ "$YESNO" = "y" ]; then
  make
 fi
done
echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0

