#!/bin/bash
#This script should do the complete thing, no extra preparation should be needed if it runs within Ubuntu, andLinux or other 
#debian derivates. 
#It is recommended to run speed-to-fritz prior to this skript with the wanted firmware combinations
#so the firmware-versions in use will be downloaded and can be used by freetz later without copying them by hand.
echo
echo
echo
echo "------------------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------------------"
echo "------------------------------------------------------------------------------------------------------------------"
# dont change variables
export HOMEDIR="`pwd`"
#include variables from last run of speed-to-fritz
. ./incl_var
export FREETZ_DIR="freetz-trunk"
FREETZ_DL_LINK="http://svn.freetz.org/trunk"
#7390 or W722-->
  DO_COPY="y" # n is just for testing - uses the complet addon patch for freetz W722
  if [ "$FBMOD" = "7390" ] || [ "$SPNUM" = "722" ] ; then
    echo -e "\033[32mAlternative trunk is used for 7390 or W722V Type A\033[0m"
    export FREETZ_DIR="freetz-trunk-7390"
    #patches are at the moment for revision 4869
    FREETZREVISION="4869"
    echo -e "\033[31mRevision  is set to: $FREETZREVISION (current patches do need this revision)\033[0m "
    FREETZ_DL_LINK="http://svn.freetz.org/branches/oliver/7390"
  fi    
# 7390 or W722<--
export SVN_VERSION="X${FREETZREVISION}"
if [ "$FIRST_RUN" = "y" ]; then  
echo "" 
echo "" 
 echo "You must invoke './start' first to set up the firmwaretype and some other parameters needed to run freetz!" 
    sleep 8 
    exit 0 
fi
#START
echo "------------------------------------------------------------------------------------------------------------------"
#echo "------------------------------------------------------------------------------------------------------------------"
#echo "------------------------------------------------------------------------------------------------------------------"
#echo "ATTENTION! You must run speed-to-fritz with the correct settings of your Speedport first."
#echo "At the same time you will get the firmwares used with freetz later on."
#echo "------------------------------------------------------------------------------------------------------------------"
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
echo "Installing or updating freetz/trunk"
echo "Updating your LINUX system and installing missing tools needed for freetz"
echo "invoking 'make menuconfig'"
echo "invoking 'make'"
echo "invoking 'speed-to-freetz'" 
#echo
#echo "You must setup the proper fritz type in menuconfig later when menuconfig is started!"
#echo "This must be the same as used before with speed-to-fritz"
#echo "Usually it is the latest version of a 7170 or 7270 firmware or a LABOR version."
#echo "For Sinus W500V it must be a 7150 Firmware."   
#echo "For W920V it must be a 7270 Firmware."   
#echo "With W501 it is only possible to use an older firmware version."
#echo 
echo "---------------------------------------------------------------------------------"
# Removing previous sp2fritz sources if still existent                         
rm -rf "$FBDIR"
rm -rf "$FBDIR_2"
rm -rf "$SPDIR"
rm -rf "$TEMPDIR"

#KEY="x"
#while [ "$KEY" != "y" ]; do
# echo
# echo
# echo -n "  Did you run speed-to-fritz to set up the variables in use' (y/n)? "; read -n 1 -s YESNO; echo
# [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
# [ "$KEY" = "x" ] && echo "wrong key!"
# [ "$YESNO" = "n" ] && ./start
#    #include variables from last run of speed-to-fritz
# [ "$YESNO" = "n" ] &&. ./incl_var
#done

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
if ! [ -e "$HOMEDIR/.freetz_tools_installed" ]; then
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
    touch $HOMEDIR/.freetz_tools_installed
  fi
 done
fi
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
  echo -n "   Execute: 'svn co $FREETZ_DL_LINK $FREETZ_DIR' -r $FREETZREVISION (y/n)? "; read -n 1 -s YESNO; echo
 else
  echo -n "   Execute: 'svn co $FREETZ_DL_LINK $FREETZ_DIR'  (y/n)? "; read -n 1 -s YESNO; echo
 fi
 [ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
 [ "$KEY" = "x" ] && echo "wrong key!"
 if [ "$YESNO" = "y" ]; then 
  rm -fdr ./$FREETZ_DIR/.config
  rm -fdr ./$FREETZ_DIR/Config.in
  rm -fdr ./$FREETZ_DIR/toolchain/Config.in
  rm -fdr ./$FREETZ_DIR/patches/196-usbstorage.sh
  rm -fdr ./$FREETZ_DIR/patches/220-assistant.sh
  rm -fdr ./$FREETZ_DIR/make/linux/kernel.mk
  rm -fdr ./$FREETZ_DIR/fwmod
  rm -fdr ./$FREETZ_DIR/patches/722A
  rm -fdr ./$FREETZ_DIR/make/linux/patches/2.6.19.2/722A_04.76
  rm -fdr ./$FREETZ_DIR/make/linux/Config.iks-16mb_26.722A_04.76
  echo "Looking for new freetz version, wait ..."
  if [ "$FREETZREVISION" ]; then
	svn co $FREETZ_DL_LINK $FREETZ_DIR -r $FREETZREVISION
	export SVN_VERSION="$FREETZREVISION"
  else
	svn co $FREETZ_DL_LINK $FREETZ_DIR
  fi
  #  export Revision=`svn co http://svn.freetz.org/trunk $FREETZ_DIR | grep 'Checked out revision' | tr -d '[:alpha:]' | tr -d '.'| tr -d ' '`
 fi
 [ -d "$FREETZ_DIR" ] || echo "freetz directory not found in the right place, should be in the same folder as speed-to-fritz!"
 [ -d "$FREETZ_DIR" ] || KEY="x"
done
echo
echo
#Set Freetz /dl downloaddirectory to windows partition if existent to free up space needed for working.
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
cd $FREETZ_DIR
echo "--Image files present in '$DL_DIR_ABS/fw':"
ls -l $DL_DIR_ABS/fw/*.image 2>&1 | grep -v 'No such file' 
echo
echo "Now you can run 'make menuconfig', at the first time a lot of warnings will be displayed!"
echo "Select '7270', '7170' or other type suitable for your router 'W920, W900, W701 Sinus 500 or other.'"
echo "As next step run 'make'"
echo "Firmware has to be copied to '$DL_DIR_ABS' directory first,"
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
 # menuconfig qestion -->
 if [ "$YESNO" = "y" ]; then
  #include variables from last run of speed-to-fritz
  . ../speed-to-fritz/incl_var
  echo "Be patient ..."
  #7390 or W722-->
  if [ "$FBMOD" = "7390" ] || [ "$SPNUM" = "722" ] ; then
	# only W722 Config files
	PATCH="$HOMEDIR/w722/W722_Config.diff"
	# add all W722 files 
	[ "$DO_COPY" != "y" ] && PATCH="$HOMEDIR/w722/W722V_Type_A_files.diff"
  	patch -d . -p0 -N --no-backup-if-mismatch < "$PATCH" 2>&1
  fi  # 7390 or W722<--
  #preset freetz to the same type as speed-to-fritz
  sed -i -e "/Hardwaretype/,/---------/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e '/General/a\
comment "Hardwaretype and language settings must be the same as in speed2fritz."\
comment "Annex type is set by speed2fritz in a second run afrer freetz."\
comment "----------------------------------------"' "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_SUBVERSION_STRING/,/help/{s/default y/default n/}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_FON_WLAN_7270_16MB/,/help/{s/default n/default y/}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_ALIEN_HARDWARE/,/endchoice/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e "/config FREETZ_TYPE_SPEEDPORT_W501V/,/select FREETZ_DL_OVERRIDE/{/.*/d}" "./Config.in" 2> /dev/null
  sed -i -e '/default FREETZ_TYPE_FON_7150/d' "./Config.in" 2> /dev/null
              
  #echo "LABORTYPE: $TYPE_LABOR_TYPE  LANGUAGE:$avm_Lang  FBMOD:${FBMOD}"
  #sleep 5
  [ "$avm_Lang" = "en" ] && sed -i -e "s/default FREETZ_TYPE_LANG_DE/default FREETZ_TYPE_LANG_EN/" "./Config.in" 2> /dev/null
  [ "$avm_Lang" = "de" ] && sed -i -e "s/default FREETZ_TYPE_LANG_EN/default FREETZ_TYPE_LANG_DE/" "./Config.in" 2> /dev/null
  sed -i -e '/FREETZ_TYPE/d' "./.config" 2> /dev/null
  #[ "$avm_Lang" = "de" ] && sed -i -e 's/# FREETZ_TYPE_LANG_DE.*/FREETZ_TYPE_LANG_DE=y/' "./.config" 2> /dev/null
  #[ "$avm_Lang" = "de" ] && sed -i -e 's/FREETZ_TYPE_LANG_EN=.*/# FREETZ_TYPE_LANG_DE is not set/' "./.config" 2> /dev/null

  #sed -i -e 's/# FREETZ_TYPE_LANG_EN.*/FREETZ_TYPE_LANG_EN=y/' "./.config" 2> /dev/null
  #[ "$avm_Lang" = "en" ] && sed -i -e 's/# FREETZ_TYPE_ANNEX_A.*/FREETZ_TYPE_ANNEX_A=y/' "./.config" 2> /dev/null
  #[ "$avm_Lang" = "en" ] && sed -i -e 's/FREETZ_TYPE_LANG_DE=.*/# FREETZ_TYPE_LANG_EN is not set/' "./.config" 2> /dev/null
  #[ "$avm_Lang" = "en" ] && sed -i -e 's/FREETZ_TYPE_ANNEX_B=.*/# FREETZ_TYPE_ANNEX_A is not set/' "./.config" 2> /dev/null
  #7570 -->
  if [ "$SPNUM" = "7570" ]; then
  echo "7570 is now suported within Freetz!"
  #7570 <--
  fi
  #7390 -->
  if [ "$FBMOD" = "7390" ] || [ "$SPNUM" = "722" ] ; then
   echo "---------------------------------------------"
   echo "FREETZ_TYPE_FON_WLAN_7390=y" >> "./.config" 2> /dev/null
   #done ins in trunk now 4835
   grep -q " -be" "./fwmod" && echo -e "\033[31mBig endianness option found!\033[0m"
   if [ "$SPNUM" = "722" ] ; then
    DISABLE_MODUL_AND_KERNEL_BILDING="n"
    if [ "$DISABLE_MODUL_AND_KERNEL_BILDING" = "y" ] ; then
     #--> diabele building of modules and kernel
     sed -i -e "s/kernel-precompiled: pkg-echo-start.*$/kernel-precompiled: pkg-echo-start pkg-echo-done/" "./make/linux/kernel.mk"
     grep -q "kernel-precompiled: pkg-echo-start pkg-echo-done" "./make/linux/kernel.mk" && echo -e "\033[31mMake kernel is disabled!\033[0m" 
     # disable error display if modules dir is not present
     sed -i -e 's|cd "${KERNEL_REP_DIR}/modules-${FREETZ_KERNEL_LAYOUT}-${FREETZ_KERNEL_REF}-${FREETZ_AVM_VERSION_STRING}"|cd "${KERNEL_REP_DIR}/modules-${FREETZ_KERNEL_LAYOUT}-${FREETZ_KERNEL_REF}-${FREETZ_AVM_VERSION_STRING}" 2>/dev/null|' "./fwmod"
     # preselect W722
    fi #<-- 
     # freetz revision 4844 
     echo "FREETZ_TYPE_SPEEDPORT_722A=y" >> "./.config" 2> /dev/null
     if [ "$DO_COPY" == "y" ]; then
     # copy patches to be usable with 7390 Source and w722 firmware
     	rm ./patches/7390/140-rc.S-no_avm_exit.patch
     	rm ./patches/7390/290-replace_websrv-remove_igdd.patch
     	rm ./patches/7390/301-remove_smbd.patch
     	rm ./patches/7390/de/*
     	rm ./patches/cond/usbstorage_7390.patch
     	cp $HOMEDIR/w722/patches/722A/*.patch ./patches/7390
     	cp $HOMEDIR/w722/patches/722A/de/* ./patches/7390/de
     	cp $HOMEDIR/w722/patches/722A/cond/* ./patches/cond
     	cp -fdrp $HOMEDIR/w722/patches/722A --target-directory="./patches"
     	cp -fdrp $HOMEDIR/w722/make --target-directory="."
     #cp -fdrpv $HOMEDIR/w722/make/linux/Config.iks-16mb_26.722A_04.76 ./make/linux/Config.iks-16mb_26.722A_04.76
     fi
   fi # <-- 722
   # add tcom as HTML directory as well, if a original tcom firmware is in use we only have tcom
   sed -i -e "s|for i in all avme/en avme|for i in all avme/en avme tcom|" "./fwmod"
  # 7390 <--
  else
    [ "$SPNUM" = "500" ] && echo "FREETZ_TYPE_WLAN_${FBMOD}=y" >> "./.config" 2> /dev/null
    [ "$SPNUM" = "500" ] || echo "FREETZ_TYPE_FON_WLAN_${FBMOD}=y" >> "./.config" 2> /dev/null
    #woraround if Final was selected as Labor
    if [ "$TYPE_LABOR_TYPE" != "7270_13486" ] && [ "$TYPE_LABOR_TYPE" != "58" ] && [ "$TYPE_LABOR_TYPE" != "59" ] && [ "$TYPE_LABOR_TYPE" != "67" ] && [ "$TYPE_LABOR_TYPE" != "70" ]; then
     [ "$TYPE_LABOR" = "y" ] && sed -i -e "s/default FREETZ_TYPE_LABOR_MI.*/default FREETZ_TYPE_LABOR_$TYPE_LABOR_TYPE/" "./Config.in" 2> /dev/null
     [ "$TYPE_LABOR" = "y" ] && echo "FREETZ_TYPE_LABOR=y" >> "./.config" 2> /dev/null
     [ "$TYPE_LABOR" = "y" ] && echo "FREETZ_TYPE_LABOR_$TYPE_LABOR_TYPE=y" >> "./.config" 2> /dev/null
    fi  
  fi    

  make menuconfig

  [ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SOURCE=.*$/FREETZ_DL_KERNEL_SOURCE=$KERNEL_SOURCE/" "./.config" 2> /dev/null
  [ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SITE=.*$/FREETZ_DL_KERNEL_SITE=$KERNEL_SITE/" "./.config" 2> /dev/null
  [ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SOURCE_MD5=.*$/FREETZ_DL_KERNEL_SOURCE_MD5=\"\"/" "./.config" 2> /dev/null

  sed -i -e 's/.*FREETZ_DL_OVERRIDE=.*$/FREETZ_DL_OVERRIDE=y/' "./.config" 2> /dev/null
  [ -n "$FBIMG" ] && sed -i -e 's/FREETZ_DL_SITE=.*$/FREETZ_DL_SITE=""/' "./.config" 2> /dev/null
  [ -n "$FBIMG" ] && sed -i -e "s/FREETZ_DL_SOURCE=.*$/FREETZ_DL_SOURCE=$FBIMG/" "./.config" 2> /dev/null
 fi
done
#echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#sed -i -e 's|\(${FIRMWAREVERSION}${SUBVERSION}\).|\1.${SVN_FREETZ_VERSION}.|' "./fwmod" 2> /dev/null
sed -i -e 's|${FIRMWARE
[21~VERSION}${SUBVERSION}.|${FIRMWAREVERSION}${SUBVERSION}${SVN_FREETZ_VERSION}.|' "./fwmod" 2> /dev/null
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
  [ ! -e "$DL_DIR/fw/$FBIMG" ] && cp -fdprv  "$FWBASE/$FBIMG"   --target-directory=$DL_DIR/fw
  echo "Be patient ..."
  make 2>&1 | tee $HOMEDIR/make_freetz.log
 fi
done
#include freetz variables
. ./.config
#include freetz firmware imagename variable 'modimage'
[ -f "./freetz_var" ] && . ./freetz_var
#copy freetz firmwares to speed-to-fritz 
echo "---------------------------------------------------------------------------------------------------------------"
echo "modimage=${modimage}"
if ! [ -f "./images/${modimage}" ]; then
echo "_______________________________________________________________________________________________________________"
 echo "Something went wrong, Freetzfirmware not found!" 
echo "_______________________________________________________________________________________________________________"
 echo
 echo "If Firmware was created, you may copy the freetz image yourself to:"
 echo "$FWBASE"
 echo "Then start speed-to-fretz setup (./start) again and select freetz image as AVM LABOR source"
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
