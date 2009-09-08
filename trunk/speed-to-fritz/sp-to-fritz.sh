#!/bin/bash
export PATH=$PATH:/sbin
#dont change names of variables because some of the names are used in other files as well!
##########################################################################
# Date of current version:
# TODO: LC_ALL= LANG= LC_TIME= svn info . | awk '/^Last Changed Date: / {print $4}'
Tag="08"; Monat="09"; Jahr="09"
export SKRIPT_DATE="$Tag.$Monat.$Jahr"
export SKRIPT_DATE_ISO="$Jahr.$Monat.$Tag"
export SKRIPT_REVISION="$Jahr$Monat$Tag"
export MODVER="${SKRIPT_DATE}-multi"
##########################################################################
# Set this to "y" if you run the skript within CYGWIN, only used with -p option
# For more info, look into file includefunction
export CYGWIN=""
export ERR_LOGFILE="0_error.log"
# only used with push option
# If adam IP address is changed after use of recover or clear mtd3/mtd4
# in some cases this address may be changed to 192.168.2.1 or 192.168.1.1
export IPADDRESS="192.168.178.1"
#defaults
export ADD_OLD_DECTMENU="n"
export ADD_7150_DECTMNUE="n"
export REMOVE_MENU_ITEM="n"
export COPY_HEADER="n"
export REMOVE_HELP="n"
export REMOVE_KIDS="n"
export ATA_ONLY="n"
export FREETZ_REVISION="" # this is the real revision used
export FREETZREVISION="" # this is selectet via mene
export ENABLE_EXT2="n"
export MOVE_ALL_to_OEM="n"
# normal no second image
export SRC2_IMG=""
export USE_SOURCE2_WEBMNUE="n"
export USE_SOURCE2_DSLMNUE="n"
export SAVE_AVM_DSL="n"
export SAVE_SRC2_DSL="n"
export SAVE_TCOM_DSL="n"
export USE_OWN_DSL="n"
export USE_SRC2_DSL="n"
export FORCE_TCOM_DSL="n"
export FORCE_TCOM_PIGLET="n"
export FORCE_TCOM_LEDDRIVER="n"
export FORCE_TCOM_FON="n"
export COPY_ADDON_TMP="n"
export COPY_ADDON_TMP_to_ORI="n"
#just in use for freetz
export TYPE_LABOR="n"
export TYPE_LABOR_DSL="n"
export TYPE_LABOR_GAMING="n"
# normal no compare 
export DO_DIFF="n"
export DO_FINAL_DIFF="n"
export DO_FINAL_DIFF_SRC2="n"
#debug options
export DO_NOT_STOP_ON_ERROR="n"
export SET_UP="n"
#build own device table, normally not needed
export MAKE_DEV="y"
#pack expanded directory /var.tar > /squashfs-root/usr/var.tar, normally not needed 
export PACK_VARTAR="y"
# My Tools:
#---->
export HOMEDIR="`pwd`"
export TOOLS_SUBDIR="tools"
export TOOLS_DIR="${HOMEDIR}/${TOOLS_SUBDIR}"
export include_modpatch="${TOOLS_DIR}/freetz_patch"
export UNSQUASHFS_TOOL="unsquashfs3-lzma"
export UNSQUASHFS="${TOOLS_DIR}/${UNSQUASHFS_TOOL}"
export FINDSQUASHFS_TOOL="find-squashfs"
export FINDSQUASHFS="${TOOLS_DIR}/${FINDSQUASHFS_TOOL}"
#neuer mksquashfs-lzma macht reboot Ursache nicht bekannt
export MKSQUASHFS_TOOL="mksquashfs-lzma"
export MKSQUASHFS_OPTIONS="-le -noappend -all-root -info"
export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
export FAKEROOT_NAME="fakeroot"
export FAKEROOT_DESTDIR="${TOOLS_DIR}/usr"
export FAKEROOT_BIN_DIR="${FAKEROOT_DESTDIR}/bin"
export FAKEROOT_LIB_DIR="${FAKEROOT_DESTDIR}/lib"
export FAKEROOT_TOOL="${FAKEROOT_BIN_DIR}/${FAKEROOT_NAME}"
sed -i -e "s|^PREFIX=.*$|PREFIX=${FAKEROOT_DESTDIR}|g" ${FAKEROOT_TOOL}
sed -i -e "s|^BINDIR=.*$|BINDIR=${FAKEROOT_BIN_DIR}|g" ${FAKEROOT_TOOL}
sed -i -e "s|^PATHS=.*$|PATHS=${FAKEROOT_LIB_DIR}|g" ${FAKEROOT_TOOL}
export TICHKSUM_TOOL="tichksum"
export TICHKSUM="${TOOLS_DIR}/${TICHKSUM_TOOL}"
#export TICHKSUM="$TOOLS_DIR/TI-chksum-0.1/tichksum"
export RMTICHKSUM_TOOL="rmtichksum"
export RMTICHKSUM="${TOOLS_DIR}/${RMTICHKSUM_TOOL}"
export TAR_TOOL="tar"
export TAR="${TOOLS_DIR}/${TAR_TOOL}"
export MAKEDEVS_TOOL="makedevs"
export MAKEDEVS="${TOOLS_DIR}/${MAKEDEVS_TOOL}"
export MAKEDEVS_FILE="${TOOLS_DIR}/device_table.txt"    
#<---
export SQUASHFSROOT="squashfs-root"
# Set default values for output directory 
export FWNEWDIR="Firmware.new"
export NEWDIR="$HOMEDIR/$FWNEWDIR"
export FWORIGDIR="Firmware.orig"
export FWBASE="$HOMEDIR/$FWORIGDIR"
mkdir -p "$NEWDIR" "$FWBASE"
#Set /FWBASE Downloaddirectory to windows partition if existent to free up room needed for working, if andLinux is used 
export WinPartitopn="/mnt/win/Firmware.orig"
#echo "WinPartitopn:$WinPartitopn"
if [ -d "$WinPartitopn" ]; then
 export FWORIGDIR="${WinPartitopn##*/}"
 export FWBASE="$WinPartitopn"
 echo -e "\033[1mSpeed-to-fritz download directory is now set to:\033[0m ${WinPartitopn%/*}/${WinPartitopn##*/}" 
fi
#Set /NEWDIR Outputdirectory to windows partition if existent to free up room needed for working, if andLinux is used 
export WinPartitopnNew="/mnt/win/Firmware.new"
#echo "WinPartitopnNew:$WinPartitopnNew"
if [ -d "$WinPartitopnNew" ]; then
 export FWNEWDIR="${WinPartitopnNew##*/}"
 export NEWDIR="$WinPartitopnNew"
 echo -e "\033[1mSpeed-to-fritz output directory is now set to:\033[0m ${WinPartitopnNew%/*}/${WinPartitopnNew##*/}" 
fi
export P_DIR="$HOMEDIR/alien/patches"
export sh_DIR="$HOMEDIR/alien/subscripts"
export inc_DIR="$HOMEDIR/includes"
export sh2_DIR="$HOMEDIR/subscripts2"
# Temporary directories for unpacked/modified images
export TEMPDIR="${HOMEDIR}/FBDIRori"
export SPDIR="${HOMEDIR}/SPDIR"
export FBDIR="${HOMEDIR}/FBDIR"
export SRC="${FBDIR}/$SQUASHFSROOT"
export DST="${SPDIR}/$SQUASHFSROOT"
export FBDIR_2="${HOMEDIR}/FBDIR2"
export SRC_2="${FBDIR_2}/$SQUASHFSROOT"
# Set default values for output directory 
export	FWNEWDIR="Firmware.new"
# Set default values if no options are given 
export firmwareconf_file_name="Firmware.conf"
export ORI="n"
export SPMOD="701"
export DO_LOOKUP_PATCH="n"
export TARIMG="n"
export PUSHCONF="n"
export UPDATETAM="y"
export VERBOSE="-v"
export ETH_IF=""
export ANNEX="B"
export VPI="1"
export VCI="32"
export KAPSELUNG="1"
# Commandline
export cml="$0"
export Options="$*"
# Don't change any parameters below here
# This parameters are used in the resulting Speedport image
export CONFIG_ACCESSORY_URL=""
export CONFIG_FIRMWARE_URL="http://www.t-com.de/downloads"
# Set defaults for branding ('avm') and hostname ('fritz.box')
export OEMLIST="avme avm aol 1und1 freenet tcom all congstar"
export OEMLINKS="aol 1und1 freenet tcom congstar"
export OEM="avm"
export CONFIG_OEM_DEFAULT="avm"
export HOSTNAME=""
export NEWNAME=""
export FBHWRevision=""
# Not all variables are used later on.
# It is a bit wiered how the information is carried on to the resulting image,
# usually this information is overwritten by other settings made later on.
# Some are set again depending on settings made later.
# Some variabels are rewritten in patch_config_rc.conf from globals to rc.conf
# see patch_config_rc_conf for more details
# At the moment i don't know what variables are really in use by AVM Firmware
# This is just an approach to keep as much information as possible to be safe
export USBH="n"
export ATA="y"
export CONFIG_ATA="${ATA}"
export CONFIG_ATA_FULL="n"
#export ANNEX="B"
#---------------------------------------------------------------------------------------------
# get commandline options to variables
. $inc_DIR/processcomline
# main script
[ ${FAKEROOT_ON} = "n" ] && $HOMEDIR/modfw.sh
[ ${FAKEROOT_ON} != "n" ] && $FAKEROOT_TOOL $HOMEDIR/modfw.sh
. incl_var
if [ "$SET_UP" = "n" ]; then
	echo "********************************************************************************"
 if [ "$PUSHCONF" = "y" ]; then
	echo "Flashing firmware image $NEWDIR/kernel.image..."
	$HOMEDIR/ftpXXX
	exit 0
 else
	echo "********************************************************************************"
	echo -e "You may now use it in regular \033[1mfirmware upgrade\033[0m process."
	echo "Or:"
	echo " Continue with upload of new kernel.image to speedport via ftp ..."
	echo " 1. Login to 192.168.178.1 as adam2 (pw adam2)"
	echo " 2. Issue commands:     bin, passiv, quote MEDIA FLSH"
	echo " 3. Transfer file:      put kernel.image mtd1"
	echo " 4. Change branding:    quote SETENV firmware_version ${OEM}"
	echo " 5. Change kernel_args: quote SETENV kernel_args ${kernel_args}"
	echo " 6. Reboot speedport:   quote REBOOT"
	echo " 7. Exit ftp:           quit "
	echo "Or:"
	echo -e " Use \033[1m./ftpXXX 'ENTER'\033[0m to do the above, if you have a functional netconnection "
	echo " on this LINUX System to your Speedport, no additional settings are needed."
	echo "********************************************************************************"
 fi
else
 echo "No output generated, because this was specified via setup! "
fi
echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0
