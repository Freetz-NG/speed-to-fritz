#!/bin/bash
export SVN_VERSION="XXXX"
#This skript should do the complete thing, no extra preparation should be needed if it runs within Ubuntu, andLinux or other 
#debian derivates. 
#It is recommended to run speed-to-fritz (./707 or any other) prior to this skript with the wanted firmware combinations
#so the firmware-versions in use will be downloaded and can be used by freetz later without copying them by hand.
#---------------------
#here you can change the folder name of freetz
export FREETZ_DIR="freetz-trunk"
# dont change variables
export HOMEDIR="`pwd`"
#include variables from last run of speed-to-fritz
. ./incl_var
if [ "$FIRST_RUN" = "y" ]; then  
echo "" 
echo "" 
echo "" 
echo "" 
 echo "You must invoke './start' first to set up the firmwaretype and some other parameters needed to run freetz!" 
    sleep 8 
    exit 0 
fi
echo
echo 
echo 
echo 
#START
echo
echo
echo
echo "------------------------------------------------------------------------------------------------------------------"
#echo "------------------------------------------------------------------------------------------------------------------"
#echo "------------------------------------------------------------------------------------------------------------------"
#echo "ATTENTION! You must run speed-to-fritz with the correct settings of your Speedport first."
#echo "At the same time you will get the firmwares used with freetz later on."
#echo "------------------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------------------"
echo "Your settings from the last run of speed-to-fritz:"

echo "Speedporttype=W${SPNUM}V"
echo "OEM=${OEM}"
echo "CONFIG_PRODUKT=${CONFIG_PRODUKT}"
echo "ANNEX=${ANNEX}"
echo "Imagename=${NEWIMG}"
echo "AVM Type=${FBMOD}"
echo
echo
#echo "You must have Freetz installed to the proper directory: $FREETZ_DIR "
#echo "You can do this by invoking: 'svn co http://svn.freetz.org/trunk $FREETZ_DIR' via this script as normal user!"
#echo "For more info see:"
#echo "http://wiki.ip-phone-forum.de/skript:freetz_und_speed-to-fritz"
echo
echo "The following script should do this for you:"
echo
echo "Installing or updating the latest freetz/trunk"
echo "Updating your LINUX system and installing missing tools needed for freetz"
echo "invoking 'make menuconfig'"
echo "invoking 'make'"
echo "invoking 'speed-to-freetz'" 
#echo
#echo "You must setup the proper fritz type in menuconfig later when menuconfig is started!"
#echo "This must be the same as used before with speed-to-fritz"
#echo "Usually it is the latest version of a 7170 firmware or a LABOR version."
#echo "For Sinus W500V it must be a 7150 Firmware."   
#echo "For W920V it must be a 7270 Firmware."   
#echo "With W501 it is only possible to use an older firmware version."
#echo 
echo "---------------------------------------------------------------------------------"
# Removing privias sp2fritz sources if still in existant                         
rm -rf "$FBDIR"
rm -rf "$FBDIR_2"
rm -rf "$SPDIR"
rm -rf "$TEMPDIR"

KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo
 echo -n "  Did you run speed-to-fritz to set up the variables in use' (y/n)? "; read -n 1 -s YESNO; echo
 [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 [ "$YESNO" = "n" ] && ./start

done

echo
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "Login as normal user!"
  echo "Speed-to-fritz must be run as normal user as well!" 
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
cd ..
KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo "The update and install procedure has to be repeated until all errors are gone!"
 echo
 echo -n "   Do an update and installation of missing tools? (y/n)? "; read -n 1 -s YESNO; echo
 [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$YESNO" = "n" ] || [ "$YESNO" = "y" ] || echo "wrong key!"
if [ "$YESNO" = "y" ]; then
 #sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade && sudo apt-get -y install subversion gcc g++ binutils autoconf automake automake1.9 automake1.8 libtool make bzip2 libncurses5-dev zlib1g-dev flex bison patch texinfo tofrodos gettext jam pkg-config jikes ecj-bootstrap fastjar realpath perl libstring-crc32-perl ruby ruby1.8 gawk python libusb-dev unzip
 echo "Update ----->"
 sudo apt-get -y update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade &&\
 sudo apt-get -y install gcc g++ binutils autoconf automake automake1.9
 sudo apt-get -y update && sudo apt-get -y upgrade &&\
 sudo apt-get -y install libtool make libncurses5-dev zlib1g-dev flex bison patch texinfo
 sudo apt-get -y update && sudo apt-get -y upgrade &&\
 sudo apt-get -y install tofrodos gettext jam pkg-config jikes fastjar realpath perl
 sudo apt-get -y update && sudo apt-get -y upgrade &&\
 sudo apt-get -y install libstring-crc32-perl ruby ruby1.8 gawk python subversion bzip2
 echo "End update <-----"
 fi
done
KEY="x"
while [ "$KEY" != "y" ]; do
 echo
 echo "Download Freetz the first time, or do a freetz update?"
 echo
 echo "I case of problems do a 'make dirclean' at the commandline this will remove all changes made by you."
 echo "For using the commandline you must change to the freetz-trunk directory first. 'cd ../freetz-trunk'"  
 echo "To download a specific revision of the trunk you would need to set the number via menu option!"
 echo
 
if [ "$FREETZREVISION" ]; then
 echo -n "   Execute: 'svn co http://svn.freetz.org/trunk $FREETZ_DIR' -r $FREETZREVISION (y/n)? "; read -n 1 -s YESNO; echo
else
 echo -n "   Execute: 'svn co http://svn.freetz.org/trunk $FREETZ_DIR'  (y/n)? "; read -n 1 -s YESNO; echo
fi
 [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 if [ "$YESNO" = "y" ]; then 
  rm -fdr ./$FREETZ_DIR/.config
  rm -fdr ./$FREETZ_DIR/Config.in
  rm -fdr ./$FREETZ_DIR/fwmod
  echo "Looking for new freetz version, wait ..."
    if [ "$FREETZREVISION" ]; then
	svn co http://svn.freetz.org/trunk $FREETZ_DIR -r $FREETZREVISION
	export SVN_VERSION="$FREETZREVISION"
    else
	svn co http://svn.freetz.org/trunk $FREETZ_DIR
    fi
  #  export Revision=`svn co http://svn.freetz.org/trunk $FREETZ_DIR | grep 'Checked out revision' | tr -d '[:alpha:]' | tr -d '.'| tr -d ' '`
 fi
 [ -d "$FREETZ_DIR" ] || echo "freetz directory not found in the right place, should be in the same folder as speed-to-fritz!"
 [ -d "$FREETZ_DIR" ] || KEY="x"
done
echo
echo
#Set Freetz /dl Downloaddirectory to windows partition if existent to free up room needed for working, if andLinux is used 
WinPartitopn="/mnt/win/dl"
WinPartitopn=`echo "$WinPartitopn" | tr '/' '\/' `
#echo "WinPartitopn:$WinPartitopn"
[ -d "$WinPartitopn" ] && sed -i -e "s|\(DL_DIR:=\).*$|\1${WinPartitopn}|" "./$FREETZ_DIR/Makefile"
[ -d "$WinPartitopn" ] && echo -e "\033[1mFreetz download directory is now set to windows partition:\033[0m ${WinPartitopn}" 
#get Downloaddirectory settings made in Freetz Makefile
eval `cat ./$FREETZ_DIR/Makefile | grep  'DL_DIR:=' | tr -d ':'`
#echo "DL_DIR:=$DL_DIR"
DL_DIR_ABS=./$FREETZ_DIR/$DL_DIR
`cat ./$FREETZ_DIR/Makefile | grep -q 'DL_DIR:=/'` && DL_DIR_ABS=$DL_DIR
[ -d "$DL_DIR_ABS" ] || mkdir  "$DL_DIR_ABS"
[ -d "$DL_DIR_ABS/fw" ] || mkdir  "$DL_DIR_ABS/fw"
echo
#echo -n "present directory is: "
#pwd
#echo "--->"
#ls | grep "$FREETZ_DIR"
#ls | grep 'speed-to-fritz'
cd $FREETZ_DIR
#echo
#echo -n "present directory is: "
#pwd
#echo "--->"
# ls
echo "--Image files present in '$DL_DIR_ABS/fw':"
ls -l $DL_DIR_ABS/fw/*.image 2>&1 | grep -v 'No such file' 
echo
echo "Now you can run 'make menuconfig', at the first time a lot of warnings will be displayed!"
echo "Select '7170' or '7150' suitable for your speedporttype 'W900, W701 or Sinus 500'"
echo "As next step run 'make'"
echo "But the used firmware has to be copied to the '$DL_DIR_ABS' directory first,"
echo "if it is not present in ./speed-to-fritz/Firmware.orig at the time of starting this script."
echo "If you did invoke speed-to-fritz before with the same firmwares in use, all should be present in:"
echo " '$DL_DIR_ABS/fw' directory without copying the files after this script did run!"
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
 #include variables from last run of speed-to-fritz
. ../speed-to-fritz/incl_var

  echo "Be patient ..."
  #preset freetz to the same type as speed-to-fritz
  sed -i -e "/Hardwaretype/,/---------/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e '/General/a\
comment "Hardwaretype and language settings"\
comment "must be the same as in speed2fritz,"\
comment "annex type is set by speed2fritz!"\
comment "Disable reverse lookup in freetz."\
comment "----------------------------------------"' "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_SUBVERSION_STRING/,/help/{s/default y/default n/}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_FON_WLAN_7270_16MB/,/help/{s/default n/default y/}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_ALIEN_HARDWARE/,/endchoice/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_SPEEDPORT_W501V/,/select FREETZ_DL_OVERRIDE/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e '/default FREETZ_TYPE_FON_7150/d' "./Config.in" 2> /dev/null
              
#echo "LABORTYPE: $TYPE_LABOR_TYPE  LANGUAGE:$avm_Lang  FBMOD:${FBMOD}"
#sleep 5
  sed -i -e "s/default FREETZ_TYPE_LABOR_MI.*/default FREETZ_TYPE_LABOR_$TYPE_LABOR_TYPE/" "./Config.in" 2> /dev/null
  [ "$avm_Lang" = "en" ] && sed -i -e "s/default FREETZ_TYPE_LANG_DE/default FREETZ_TYPE_LANG_EN/" "./Config.in" 2> /dev/null

   #sed -i -e '/is not set/d' "./.config" 2> /dev/null
   #sed -i -e '/ # /d' "./.config" 2> /dev/null
   sed -i -e '/FREETZ_TYPE/d' "./.config" 2> /dev/null
   #sed -i -e '/#/d' "./.config" 2> /dev/null
   #sed -i -e '/FREETZ_TYPE.*=y/d' "./.config" 2> /dev/null
  [ "$SPNUM" = "500" ] && echo "FREETZ_TYPE_WLAN_${FBMOD}=y" >> "./.config" 2> /dev/null
  [ "$SPNUM" = "500" ] || echo "FREETZ_TYPE_FON_WLAN_${FBMOD}=y" >> "./.config" 2> /dev/null
  [ "$avm_Lang" = "de" ] && sed -i -e 's/# FREETZ_TYPE_LANG_DE.*/FREETZ_TYPE_LANG_DE=y/' "./.config" 2> /dev/null
  [ "$avm_Lang" = "de" ] && sed -i -e 's/FREETZ_TYPE_LANG_EN=.*/# FREETZ_TYPE_LANG_DE is not set/' "./.config" 2> /dev/null

  sed -i -e 's/# FREETZ_TYPE_LANG_EN.*/FREETZ_TYPE_LANG_EN=y/' "./.config" 2> /dev/null
  [ "$avm_Lang" = "en" ] && sed -i -e 's/# FREETZ_TYPE_ANNEX_A.*/FREETZ_TYPE_ANNEX_A=y/' "./.config" 2> /dev/null
  [ "$avm_Lang" = "en" ] && sed -i -e 's/FREETZ_TYPE_LANG_DE=.*/# FREETZ_TYPE_LANG_EN is not set/' "./.config" 2> /dev/null
  [ "$avm_Lang" = "en" ] && sed -i -e 's/FREETZ_TYPE_ANNEX_B=.*/# FREETZ_TYPE_ANNEX_A is not set/' "./.config" 2> /dev/null


  [ "$TYPE_LABOR" = "y" ] && echo "FREETZ_TYPE_LABOR=y" >> "./.config" 2> /dev/null
  [ "$TYPE_LABOR" = "y" ] && echo "FREETZ_TYPE_LABOR_$TYPE_LABOR_TYPE=y" >> "./.config" 2> /dev/null

  make menuconfig

  sed -i -e 's/.*FREETZ_DL_OVERRIDE=.*$/FREETZ_DL_OVERRIDE=y/' "./.config" 2> /dev/null
  sed -i -e 's/FREETZ_DL_SITE=.*$/FREETZ_DL_SITE=""/' "./.config" 2> /dev/null
  sed -i -e "s/FREETZ_DL_SOURCE=.*$/FREETZ_DL_SOURCE=$FBIMG/" "./.config" 2> /dev/null
 fi
done
#echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#sed -i -e 's|\(${FIRMWAREVERSION}${SUBVERSION}\).|\1.${SVN_FREETZ_VERSION}.|' "./fwmod" 2> /dev/null
sed -i -e 's|${FIRMWAREVERSION}${SUBVERSION}.|${FIRMWAREVERSION}${SUBVERSION}${SVN_FREETZ_VERSION}.|' "./fwmod" 2> /dev/null
#sed -i -e "s/${FIRMWAREVERSION}\${SUBVERSION}./\${FIRMWAREVERSION}\${SUBVERSION}\${SVN_FREETZ_VERSION}./" "./fwmod" 
#2> /dev/null
sed -i -e "/echo \"export modimage=/d" "./fwmod" 2> /dev/null
sed -i -e "/echo \"export EXPORT_FREETZ_REVISION=/d" "./fwmod" 2> /dev/null
sed -i -e "/SVN_FREETZ_VERSION=/d" "./fwmod" 2> /dev/null
sed -i -e "/modimage=/i\
SVN_FREETZ_VERSION=\"\$\(svnversion . | tr \":\" \"_\"\)\"" "./fwmod" 2> /dev/null
sed -i -e "/modimage=/a\
echo \"export modimage=\\\\\"\${modimage}\\\\\"\" >\.\/freetz_var 2> \/dev\/null\n\
echo \"export EXPORT_FREETZ_REVISION=\\\\\"\${SVN_FREETZ_VERSION}\\\\\"\" >>\.\/freetz_var 2> \/dev\/null" "./fwmod" 2> /dev/null
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
  #copy original firmwares from speed-to-fritz to freetz dl 
  cp -fdprv  "$FWBASE/$FBIMG"   --target-directory=$DL_DIR/fw
  echo "Be patient ..."
  make
 fi
done
#include freetz variables
. ./.config
#include freetz firmware imagename variable 'modimage'
. ./freetz_var
#copy freetz firmwares to speed-to-fritz 
echo "---------------------------------------------------------------------------------------------------------------"
echo "modimage=${modimage}"
if ! [ -f "./images/${modimage}" ]; then
 echo "Something went wrong, Freetzfirmware not found!" 
echo "_______________________________________________________________________________________________________________"
 echo
 echo "If Firmware was created, you may copy the freetz image yourself to:"
 echo "$FWBASE"
 echo "Rename the image to: freetz.image"
 echo "Then start speed-to-fretz setup (./start) again and select freetz.image as AVM LABOR source"
echo "_______________________________________________________________________________________________________________"
else
 rm -fdr $HOMEDIR/Firmware.orig/${FREETZ_TYPE_STRING}_freetz.image
 cp -fdprv  ./images/${modimage}   --target-directory=$FWBASE
 cp -fdprv "$HOMEDIR/${firmwareconf_file_name}" "$HOMEDIR/conf-${SPNUM}-freetz" 2> /dev/null 
 chmod 777 "$HOMEDIR/conf-${SPNUM}-freetz"
 #edit sorce
 sed -i -e "s/# DO_NOT_STOP_ON_ERROR is not set/DO_NOT_STOP_ON_ERROR=y/" "$HOMEDIR/conf-${SPNUM}-freetz"
 sed -i -e "s/AVM_IMG=.*$/AVM_IMG=\"${modimage}\"/" "$HOMEDIR/conf-${SPNUM}-freetz"
 sed -i -e "/SET_UP=y/d" "$HOMEDIR/conf-${SPNUM}-freetz"
 sed -i -e "/DO_LOOKUP_PATCH=y/d" "$HOMEDIR/conf-${SPNUM}-freetz"
 sed -i -e "/ADD_ONLINECOUNTER=y/d" "$HOMEDIR/conf-${SPNUM}-freetz"
 echo "EXPORT_FREETZ_REVISION=\"$EXPORT_FREETZ_REVISION\"" >> "$HOMEDIR/conf-${SPNUM}-freetz"
 #restart speed-to-fretz with freetz.image
 rm -fdr $HOMEDIR/start-${SPNUM}
 echo "#!/bin/bash" > $HOMEDIR/start-${SPNUM}
 echo $Options | grep -q "${firmwareconf_file_name}" && echo "$cml $Options" | sed -e "s/${firmwareconf_file_name}/conf-${SPNUM}-freetz/"  >> $HOMEDIR/start-${SPNUM}
 echo $Options | grep -q "${firmwareconf_file_name}" || echo "$cml $Options -c conf-${SPNUM}-freetz"  >> $HOMEDIR/start-${SPNUM}
 chmod 777 $HOMEDIR/start-${SPNUM}
 cd ..
 cd $HOMEDIR
 KEY="x"
 while [ "$KEY" != "y" ]; do
  echo 
  echo -n "   Invoke 'speed-to-fritz' now? (y/n)? "; read -n 1 -s YESNO; echo
  [ "$YESNO" = "n" ] || [ "$YESNO" = "y" ] &&  KEY="y"
  [ "$KEY" = "x" ] && echo "wrong key!"
  if [ "$YESNO" = "y" ]; then
   echo "Be patient ..."
   ./start-${SPNUM}
  fi
 done
fi
echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0

