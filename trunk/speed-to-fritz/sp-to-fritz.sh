#!/bin/bash
export PATH=$PATH:/sbin
#dont change names of variables because some of the names are used in other files as well!
##########################################################################
# Date of current version:
# TODO: LC_ALL= LANG= LC_TIME= svn info . | awk '/^Last Changed Date: / {print $4}'
#dont chang this line formwat is used in ./start to get script version into Firmware.conf
Tag="17"; Monat="01"; Jahr="10"
export SKRIPT_DATE="$Tag.$Monat.$Jahr"
export SKRIPT_DATE_ISO="$Jahr.$Monat.$Tag"
export SKRIPT_REVISION="$Jahr$Monat$Tag"
export MODVER="${SKRIPT_DATE}-multi"
##########################################################################
# Set this to "y" if you run the skript within CYGWIN, only used with -p option
# For more info, look into file includefunction
export CYGWIN=""
ERR_LOGFILE="0_error.log"
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
ENABLE_EXT2="n"
MOVE_ALL_to_OEM="n"
# normal no second image
SRC2_IMG=""
USE_SOURCE2_WEBMNUE="n"
USE_SOURCE2_DSLMNUE="n"
SAVE_AVM_DSL="n"
SAVE_SRC2_DSL="n"
SAVE_TCOM_DSL="n"
USE_OWN_DSL="n"
USE_SRC2_DSL="n"
FORCE_TCOM_DSL="n"
FORCE_TCOM_PIGLET="n"
FORCE_TCOM_LEDDRIVER="n"
FORCE_TCOM_FON="n"
COPY_ADDON_TMP="n"
COPY_ADDON_TMP_to_ORI="n"
#just in use for freetz
TYPE_LABOR="n"
TYPE_LABOR_DSL="n"
TYPE_LABOR_GAMING="n"
# normal no compare 
DO_DIFF="n"
DO_FINAL_DIFF="n"
DO_FINAL_DIFF_SRC2="n"
#debug options
DO_NOT_STOP_ON_ERROR="n"
SET_UP="n"
#build own device table, normally not needed
export MAKE_DEV="y"
#pack expanded directory /var.tar > /squashfs-root/usr/var.tar, normally not needed 
export PACK_VARTAR="y"
# My Tools:
#---->
export HOMEDIR="`pwd`"
TOOLS_SUBDIR="tools"
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
export FAKEROOT_TOOL="fakeroot"
export FAKEROOT_DESTDIR="${TOOLS_DIR}/usr"
export FAKEROOT_BIN_DIR="${FAKEROOT_DESTDIR}/bin"
export FAKEROOT_LIB_DIR="${FAKEROOT_DESTDIR}/lib"
export FAKEROOT="${FAKEROOT_BIN_DIR}/${FAKEROOT_TOOL}"
sed -i -e "s|^PREFIX=.*$|PREFIX=${FAKEROOT_DESTDIR}|g" ${FAKEROOT}
sed -i -e "s|^BINDIR=.*$|BINDIR=${FAKEROOT_BIN_DIR}|g" ${FAKEROOT}
sed -i -e "s|^PATHS=.*$|PATHS=${FAKEROOT_LIB_DIR}|g" ${FAKEROOT}
export TICHKSUM_TOOL="tichksum"
export TICHKSUM="${TOOLS_DIR}/${TICHKSUM_TOOL}"
#export TICHKSUM="$TOOLS_DIR/TI-chksum-0.1/tichksum"
export RMTICHKSUM_TOOL="rmtichksum"
export RMTICHKSUM="${TOOLS_DIR}/${RMTICHKSUM_TOOL}"
export TAR_TOOL="oldtar/tar"
#!!!!!
###export TAR_TOOL="tar"
export TAR="${TOOLS_DIR}/${TAR_TOOL}"
export UNTAR="${TOOLS_DIR}/${TAR_TOOL}"
export NEW_WRAP="n"
export TAR_RFS_OPTIONS="--owner=0 --group=0"
export TAR_OPTIONS="--owner=0 --group=0 --mode=0755 --format=oldgnu"
##--> temporarily use system tar to unpack avm images 
#export UNTAR="$(which tar)"
## dont use options
#### lead to 'Puefsummenfeher' if firmware is updatet via GUI
#export TAR_RFS_OPTIONS=""
#export TAR_OPTIONS=""
## set this to y if sp-to-fritz.sh is split in future versions
#export FAKEROOT_WRAP="y"
##<-- temporaril
export MAKEDEVS_TOOL="makedevs"
export MAKEDEVS="${TOOLS_DIR}/${MAKEDEVS_TOOL}"
export MAKEDEVS_FILE="${TOOLS_DIR}/device_table.txt"    
#<--- My Tools
export SQUASHFSROOT="squashfs-root"
# Set default values for output directory 
export FWNEWDIR="Firmware.new"
export NEWDIR="$HOMEDIR/$FWNEWDIR"
export FWORIGDIR="Firmware.orig"
export FWBASE="$HOMEDIR/$FWORIGDIR"
mkdir -p "$NEWDIR" "$FWBASE"
#Set /FWBASE Downloaddirectory to windows partition if existent to free up room needed for working, if andLinux is used 
WinPartitopn="/mnt/win/Firmware.orig"
#echo "WinPartitopn:$WinPartitopn"
if [ -d "$WinPartitopn" ]; then
 export FWORIGDIR="${WinPartitopn##*/}"
 export FWBASE="$WinPartitopn"
 echo -e "\033[1mSpeed-to-fritz download directory is now set to:\033[0m ${WinPartitopn%/*}/${WinPartitopn##*/}" 
fi
#Set /NEWDIR Outputdirectory to windows partition if existent to free up room needed for working, if andLinux is used 
WinPartitopnNew="/mnt/win/Firmware.new"
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
export OEMLIST="avme avm aol 1und1 freenet tcom all congstar otwo"
export OEMLINKS="aol 1und1 freenet tcom congstar otwo"
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
##########################################################################
# function set_model()
# Sets the model dependent parameters
# SPMOD ist the only parameter to be changed according to your hardware 
# Values for SPMOD: "500" (for SI W500V)
#                   "501" (for SP W501V)
#                   "503" (for SP W503V)
#                   "701" (for SP W701V)
#                   "721" (for SP W721V)
#                   "900" (for SP W900V)
#                  "7240" (for AVM 7270)
#                 "7270" (for AVM 7270v3)
#                     "*" (for Any user TYPE)
##########################################################################
function set_model()
{
if [ "$SRC2_IMG" ]; then
 export FILENAME_FBIMG_2_PATH="$(get_item "$SRC2_IMG" "1")"
 export MIRROR_FBIMG_2_PATH="$(get_item "$SRC2_IMG" "2")"
 export FBIMG_2_PATH="$(get_item "$SRC2_IMG" "0")"
 export FBIMG_2="$(echo $FBIMG_2_PATH | sed -e "s/.*\///")"
fi
#image name may be changed by the skript if zip files are used, see file includefunctions
if [ "$TCOM_IMG" ]; then
 export FILENAME_SPIMG_PATH="$(get_item "$TCOM_IMG" "1")" 
 export MIRROR_SPIMG_PATH="$(get_item "$TCOM_IMG" "2")"
 export SPIMG_PATH="$(get_item "$TCOM_IMG" "0")"
 export SPIMG="$(echo $SPIMG_PATH | sed -e "s/.*\///")"
fi
export FILENAME_FBIMG_PATH="$(get_item "$AVM_IMG" "1")" 
export MIRROR_FBIMG_PATH="$(get_item "$AVM_IMG" "2")"
export FBIMG_PATH="$(get_item "$AVM_IMG" "0")"
export FBIMG="$(echo $FBIMG_PATH | sed -e "s/.*\///")"


case "$1" in
"500")
	export SPNUM="500"
	export HWID="91"
	export CLASS="Sinus"
#	export FBMOD="7150"
#	export FBHWRevision="76"
	[ "$FBMOD" == "" ] && export FBMOD="7150"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="101"
	export PROD="DECT_W500V"
    	export CONFIG_PRODUKT="Fritz_Box_$PROD"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_1eth_0ab_pots_wlan_dect_35998"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_IsdnTE="0" 
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="0"
	export CONFIG_ETH_COUNT="1"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="y"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	export CONFIG_Pots="1"
	export kernel_size="7798784"
	export CONFIG_ATA_FULL="y"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
# is set via menu
#	[ "$CONFIG_TR064" == "" ] && export CONFIG_TR064="n"
#	[ "$CONFIG_TR069" == "" ] && export CONFIG_TR069="n"
	[ "$HOSTNAME" == "" ] && export HOSTNAME="fritz.box"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN Sinus W 500V"
	;;
"501")
	export HWID="93"
	export SPNUM="501"
#	export FBMOD="7140"
#	export FBHWRevision="107"
	[ "$FBMOD" == "" ] && export FBMOD="7140"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="101"
	export CLASS="Speedport"
	export PROD="SpeedportW501V"
    	export CONFIG_PRODUKT="Fritz_Box_$PROD"
	export NEWNAME="FRITZ!Box Fon WLAN ${CLASS} W ${SPNUM}V"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_4MB_1eth_2ab_pots_wlan_28776"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_IsdnTE="0" 
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_Debug="0"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="n"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="1"
        export CONFIG_jffs2_size="3"
	export CONFIG_RAMSIZE="16"
	export CONFIG_ROMSIZE="4"
	export CONFIG_DECT="n"
	export CONFIG_TAM="n"
	export CONFIG_TAM_MODE="0"
	#Mailer2 must be off for older firmwars 
	export CONFIG_MAILER2="n"
	export CONFIG_Pots="1"
	export kernel_size="3866624"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_AB_COUNT="0"
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_Pots="0"
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	export CONFIG_EXPERT="y"
	export CONFIG_FONGUI2="n"
	export CONFIG_IPONE="n"
	export CONFIG_FON_HD="y"
	export CONFIG_CAPI_TE="n"
	export CONFIG_CAPI_XILINX="n"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_PRINT_SERV="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_WLAN_AUTH="n"
	export CONFIG_WLAN_WMM="n"
	export CONFIG_WLAN_WPS="n"
	;;
"701"|"707")
	export SPMOD="707"
	export CLASS="Speedport"
	export SPNUM="701"
	export PROD="SpeedportW701V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_4eth_2ab_isdn_pots_wlan_13200"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="n"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	export CONFIG_IsdnTE="1"
	export CONFIG_Pots="1"
	export kernel_size="7798784"
#aditional not in use on W701 but on 7170	
	export CONFIG_DSL_UR8="n"
        export CONFIG_EXPERT="y"
	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"	
	export CONFIG_IPONE="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_RELEASE="2"
	export CONFIG_SERVICEPORTAL_URL="none"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_STORAGE="y"
	export CONFIG_USB_PRINT_SERV="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_STORAGE_USERS="n"
	export CONFIG_USB_WLAN_AUTH="y"
	export CONFIG_VDSL="n"
	export CONFIG_WLAN="n"
	export CONFIG_WLAN_1130TNET="n"
	export CONFIG_WLAN_1350TNET="n"
	export CONFIG_WLAN_GREEN="n"
	export CONFIG_WLAN_IPTV="n"
	export CONFIG_WLAN_MADWIFI="n"
	export CONFIG_WLAN_OPENWIFI="n"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 

    ;;
"721")
	export SPMOD="721"
	export CLASS="Speedport"
	export SPNUM="721"
	export PROD="SpeedportW721V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="134"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_4eth_2ab_isdn_pots_wlan_13200"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="n"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	#is TE Terminal Equipt
	export CONFIG_IsdnTE="1"
	export CONFIG_Pots="1"
	export kernel_size="7798784"
#additional, not in use on W701 but on 7170
	export CONFIG_DSL_UR8="y"
        export CONFIG_EXPERT="y"
	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"
	export CONFIG_IPONE="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_RELEASE="2"
	export CONFIG_SERVICEPORTAL_URL="none"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_STORAGE="y"
	export CONFIG_USB_PRINT_SERV="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_STORAGE_USERS="n"
	export CONFIG_USB_WLAN_AUTH="y"
	export CONFIG_VDSL="y"
	export CONFIG_VINAX="y"
	export CONFIG_VLYNQ="y"
	export CONFIG_VLYNQ0="0"
	export CONFIG_VLYNQ1="0"
#	export CONFIG_VLYNQ_PARAMS=""
	export CONFIG_WLAN="n"
	export CONFIG_WLAN_1130TNET="n"
	export CONFIG_WLAN_1350TNET="n"
	export CONFIG_WLAN_GREEN="n"
	export CONFIG_WLAN_IPTV="n"
	export CONFIG_WLAN_MADWIFI="n"
	export CONFIG_WLAN_OPENWIFI="n"
	export CONFIG_ATA="y" #no ATA possible with this harware  
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n" # removes internet via LAN1 
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
    ;;
    
"722")
## neds more updating !!!!!
	export SPMOD="722"
	export CLASS="Speedport"
	export SPNUM="721"
	export PROD="SpeedportW722"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="152"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_te_pots_wlan_usb_host_57937"
#
export CONFIG_AB_COUNT="2"
export CONFIG_ETH_COUNT="4"



#
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbWlan="1"
	export CONFIG_UsbPrint="1"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_ROMSIZE="16"
	export CONFIG_RAMSIZE="128"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="n"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	#is TE Terminal Equipt
	export CONFIG_IsdnTE="1"
	export CONFIG_Pots="1"
#additional, not in use on W701 but on 7170
	export CONFIG_DSL_UR8="n"
        export CONFIG_EXPERT="y"
	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"
	export CONFIG_IPONE="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_RELEASE="2"
	export CONFIG_SERVICEPORTAL_URL="none"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_STORAGE="y"
	export CONFIG_USB_PRINT_SERV="y"
	export CONFIG_USB_STORAGE="y"
	export CONFIG_USB_STORAGE_USERS="n"
	export CONFIG_USB_WLAN_AUTH="n"
	export CONFIG_USB_HOST_TI="n"
	export CONFIG_USB_STORAGE_SPINDOWN="n"
	export CONFIG_USB_INTERNAL_HUB="n"
	export CONFIG_DECT2="n"
	export CONFIG_USB="n"
	export CONFIG_CAPI_POTS="y"
	export CONFIG_CAPI_TE="y"
	export CONFIG_CAPI_MIPS="n"
	export CONFIG_CAPI_NT="n"
	export CONFIG_CAPI_XILINX="y"
	export CONFIG_CAPI_UBIK="n"
	export CONFIG_CAPI="y"
	export CONFIG_WLAN_WPS="y"
	export CONFIG_WLAN_TCOM_PRIO="y"
	export CONFIG_WLAN_WDS="y"
	export CONFIG_WLAN_TXPOWER="y"
	export CONFIG_WLAN="y"
	export CONFIG_WLAN_1130TNET="n"
	export CONFIG_WLAN_1350TNET="n"
	export CONFIG_WLAN_GREEN="n"
	export CONFIG_WLAN_IPTV="y"
	export CONFIG_WLAN_MADWIFI="y"
	export CONFIG_WLAN_OPENWIFI="n"
	export CONFIG_VDSL="y"
	export CONFIG_VINAX="y"
	export CONFIG_VLYNQ="n"
	export CONFIG_VLYNQ0="3"
	export CONFIG_VLYNQ1="0"
#	export CONFIG_VLYNQ_PARAMS="vlynq_reset_bit_0"


	export CONFIG_ATA="y" #no ATA possible with this harware  
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n" # removes internet via LAN1 
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	# needs different tool
	export UNSQUASHFS_TOOL="unsquashfs4-lzma"
	export UNSQUASHFS="${TOOLS_DIR}/${UNSQUASHFS_TOOL}"
	export MKSQUASHFS_TOOL="mksquashfs4-lzma"
	export MKSQUASHFS_OPTIONS="-noappend -all-root -info -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	export kernel_start=0x9F020000
	export kernel_size="16121856"
	export filesystem_start="0x9F000000"
	export filesystem_size="0"
	export urlader_start="0x9F000000"
	export urlader_size="131072"
    ;;
    

"7390")
## neds more updating !!!!!
	export SPMOD="7390"
	export CLASS=""
	export SPNUM="7390"
	export PROD="7390"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7390"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="156"
	export HWID="156"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="iks_16MB_xilinx_4eth_2ab_isdn_ nt_te_pots_wlan_usb_host_dect_64415"
#

export CONFIG_FONBOOK2="y"
export CONFIG_T38="y"
export CONFIG_WLAN_TXPOWER="y"
export CONFIG_WEBSRV="y"
export CONFIG_DSL_UR8="n"
export CONFIG_BASIS="y"
export CONFIG_NTFS="y"
export CONFIG_FTP="y"
export CONFIG_USB="n"
export CONFIG_AB_COUNT="2"
export CONFIG_MEDIASRV="y"
export CONFIG_PRODUKT_NAME="FRITZ!Box Fon WLAN 7390"
export CONFIG_WLAN_GREEN="y"
export CONFIG_AUDIO="n"
export CONFIG_CODECS_IN_PCMROUTER="n"
# is set via menu
#[ "$CONFIG_TR064" == "" ] && export CONFIG_TR064="n"
#[ "$CONFIG_TR069" == "" ] && export CONFIG_TR069="n"
export CONFIG_CAPI_POTS="y"
export CONFIG_CAPI_TE="y"
export CONFIG_USB_INTERNAL_HUB="n"
export CONFIG_LOGD="n"
export CONFIG_SQLITE_VIDEO="y"
export CONFIG_MEDIACLI="n"
export CONFIG_CAPI_MIPS="n"
export CONFIG_FAXSUPPORT="y"
export CONFIG_SAMBA="y"
export CONFIG_DECT_PICTURED="n"
export CONFIG_ETH_COUNT="4"
export CONFIG_FONQUALITY="y"
export CONFIG_LED_NO_DSL_LED="y"
export CONFIG_JFFS2="n"
export CONFIG_SPEECH_FEEDBACK="n"
export CONFIG_USB_STORAGE_USERS="n"
export CONFIG_FAX2MAIL="y"
export CONFIG_MTD_MAIL="y"
export CONFIG_UTF8="y"
export CONFIG_LED_EVENTS="y"
export CONFIG_FON_HD="y"
export CONFIG_TAM_MODE="1"
export CONFIG_CONFIGD="y"
export CONFIG_WLAN_WEATHER_CAC="n"
export CONFIG_IGD="y"
export CONFIG_HOSTNAME="fritz.fonwlan.box"
export CONFIG_ATA_NOPASSTHROUGH="n"
export CONFIG_DECT_14488="y"
export CONFIG_MAILER2="y"
export CONFIG_NQOS="y"
export CONFIG_ECO="y"
export CONFIG_GDB_FULL="y"
export CONFIG_XILINX="y"
export CONFIG_USB_STORAGE="y"
export CONFIG_MTD_RSS="y"
export CONFIG_IPTV_4THOME="y"
export CONFIG_MAILD="y"
export CONFIG_GDB="y"
export CONFIG_VPN_CERTSRV="n"
export CONFIG_NEUERUL="y"
export CONFIG_SRTP="n"
export CONFIG_WLAN_RADIOSENSOR="y"
export CONFIG_I2C="n"
export CONFIG_TAM_ONRAM="n"
export CONFIG_SERVICEPORTAL_URL=""
export CONFIG_USB_HOST="y"
export CONFIG_VOIP_ENUM="n"
export CONFIG_DECT_MONI_EX="y"
export CONFIG_WLAN_1350TNET="n"
export CONFIG_TAM="y"
export CONFIG_BOX_FEEDBACK="n"
export CONFIG_CAPI="y"
export CONFIG_ANNEX="B"
export CONFIG_DECT="y"
export CONFIG_DSL="y"
export CONFIG_DECT_CATIQ20="n"
export CONFIG_REMOTE_HTTPS="y"
export CONFIG_BLUETOOTH_CTP="n"
export CONFIG_KIDS="y"
export CONFIG_USB_PRINT_SERV="y"
export CONFIG_USB_GSM="y"
export CONFIG_SQLITE="y"
export CONFIG_SWAP="n"
export CONFIG_PLUGIN="n"
export CONFIG_VLYNQ0="3"
export CONFIG_ACCESSORY_URL=""
export CONFIG_QOS_METER="y"
# is set via menu
#export CONFIG_TR069="y"
export CONFIG_WLAN_OPENWIFI="n"
export CONFIG_LUA="n"
export CONFIG_ATA_FULL="n"
export CONFIG_WLAN_WDS="y"
export CONFIG_BLUETOOTH="n"
export CONFIG_UDEV="n"
export CONFIG_WLAN_EACS="y"
export CONFIG_DECT_MONI="y"
export CONFIG_VOL_COUNTER="y"
export CONFIG_EXT2="y"
export CONFIG_VLYNQ_PARAMS="vlynq_reset_bit_0"
export CONFIG_ASSIST="y"
export CONFIG_AURA="y"
export CONFIG_PROV_DEFAULT="y"
export CONFIG_ONLINEHELP_URL=""
export CONFIG_DIAGNOSE_LEVEL="0"
export CONFIG_VDSL="y"
export CONFIG_FONGUI2="y"
export CONFIG_UBIK2="n"
export CONFIG_WLAN_TCOM_PRIO="n"
export CONFIG_VPN="y"
export CONFIG_OEM_DEFAULT="avm"
export CONFIG_SESSIONID="y"
export CONFIG_BUTTON="y"
export CONFIG_MULTI_LANGUAGE="y"
export CONFIG_VLYNQ1="0"
export CONFIG_ONLINEHELP="y"
export CONFIG_CDROM="n"
export CONFIG_FON_IPPHONE="y"
export CONFIG_DECT_ONOFF="n"
export CONFIG_MINI="n"
export CONFIG_WEBCM_INTERPRETER="y"
export CONFIG_UPNP="y"
export CONFIG_NAND="y"
export CONFIG_NFS="n"
export CONFIG_FIRMWARE_URL=""
export CONFIG_YAFFS2="y"
export CONFIG_WLAN_WPS="y"
export CONFIG_DSL_VENDORID=""
export CONFIG_ECO_SYSSTAT="y"
export CONFIG_USB_HOST_TI="n"
export CONFIG_INETD="y"
export CONFIG_TELEKOM_KOFFER="n"
export CONFIG_WLAN_WMM="y"
export CONFIG_USB_WLAN_AUTH="y"
export CONFIG_CAPI_NT="y"
export CONFIG_LFS="y"
export CONFIG_MORPHSTICK="n"
export CONFIG_GDB_SERVER="y"
export CONFIG_STOREUSRCFG="y"
export CONFIG_LIB_MATH="y"
export CONFIG_HOMEI2C="n"
export CONFIG_WEBDAV="y"
export CONFIG_WLAN_MADWIFI="y"
export CONFIG_MAILER="n"
export CONFIG_LIBZ="y"
export CONFIG_WLAN="y"
export CONFIG_CAPI_UBIK="n"
export CONFIG_WLAN_SAVEMEM="n"
export CONFIG_DSL_MULTI_ANNEX="y"
export CONFIG_ONLINEPB="y"
export CONFIG_LABOR_DSL="n"
export CONFIG_VLYNQ="n"
export CONFIG_WLAN_1130TNET="n"
export CONFIG_ATA="y"
export CONFIG_CHRONY="y"
export CONFIG_WLAN_IPTV="y"
export CONFIG_DECT2="y"
export CONFIG_USB_HOST_AVM="n"
export CONFIG_CAPI_XILINX="y"
export CONFIG_DECT_AUDIOD="y"
export CONFIG_MEDIASRV_MOUNT="n"
export CONFIG_MULTI_COUNTRY="y"
export CONFIG_CDROM_FALLBACK="n"
export CONFIG_SQLITE_BILDER="y"
export CONFIG_OPENSSL="n"
export CONFIG_UNIQUE_PASSWD="n"
export CONFIG_FON="y"
export CONFIG_USB_STORAGE_SPINDOWN="y"
export CONFIG_EWETEL_SMARTMETER="n"
export CONFIG_ANNEX="B"

export CONFIG_AB_COUNT="2"
export CONFIG_ETH_COUNT="4"
#
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
	export CONFIG_IsdnNT="1" 
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbWlan="1"
	export CONFIG_UsbPrint="1"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_ROMSIZE="16"
	export CONFIG_RAMSIZE="128"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_ATA="y" #no ATA possible with this harware  
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n" # removes internet via LAN1 
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	# needs different tool
	export UNSQUASHFS_TOOL="unsquashfs4-lzma"
	export UNSQUASHFS="${TOOLS_DIR}/${UNSQUASHFS_TOOL}"
	export MKSQUASHFS_TOOL="mksquashfs4-lzma"
	export MKSQUASHFS_OPTIONS="-noappend -all-root -info -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	export kernel_start=0x9F020000
	export kernel_size="15597568"
	export filesystem_start="0x9F000000"
	export filesystem_size="0"
	export urlader_start="0x9F000000"
	export urlader_size="131072"
    ;;
#mtd0	0x9F000000,0x9F000000
#mtd1	0x9F020000,0x9FF00000
#mtd2	0x9F000000,0x9F020000
#mtd3	0x9FF00000,0x9FF80000
#mtd4	0x9FF80000,0xA0000000

"503")
	export SPMOD="503"
	export CLASS="Speedport"
	export SPNUM="503"
	export PROD="SpeedportW503V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="122"
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	export HWID="136"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ur8_8MB_xilinx_4eth_2ab_isdn_pots_wlan_25488"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_IsdnNT="0" 
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="n"
	export CONFIG_DECT2="n"
	export CONFIG_DECT_MONI="n"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	#is TE Terminal Equipt
	export CONFIG_IsdnTE="1"
	export CONFIG_Pots="1"
	export kernel_size="7798784"

	export CONFIG_DSL_UR8="y"
	export CONFIG_CAPI_NT="n"
        export CONFIG_EXPERT="y"
	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"
	export CONFIG_IPONE="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_RELEASE="2"
	export CONFIG_SERVICEPORTAL_URL="none"
	export CONFIG_REMOTE_HTTPS="n"
	export CONFIG_MEDIASERVER="n"
	export CONFIG_MEDIASRV="n"
	export CONFIG_USB_HOST="n"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_PRINT_SERV="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_STORAGE_USERS="n"
	export CONFIG_USB_WLAN_AUTH="n"
	export CONFIG_VDSL="n"
	export CONFIG_VINAX="n"
	export CONFIG_VLYNQ="y"
	export CONFIG_VLYNQ0="0"
	export CONFIG_VLYNQ1="0"
	export CONFIG_VLYNQ_PARAMS=" "
	export CONFIG_WLAN_SAVEMEM="n"
	export CONFIG_WLAN_TCOM_PRIO="y"
	export CONFIG_WLAN_TXPOWER="y"
	export CONFIG_WLAN_WMM="y"
	export CONFIG_WLAN_WDS="y"

	export CONFIG_WLAN="y"
	export CONFIG_WLAN_1130TNET="n"
	export CONFIG_WLAN_1350TNET="n"
	export CONFIG_WLAN_GREEN="n"
	export CONFIG_WLAN_IPTV="y"
	export CONFIG_WLAN_MADWIFI="y"
	export CONFIG_WLAN_OPENWIFI="n"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
    ;;

"900"|"907") 
	export SPMOD="907"
	export CLASS="Speedport"
	export SPNUM="900"
	export PROD="DECT_W900V" 
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="102"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_usb_host_dect_37264"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_UsbWlan="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="y"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	export CONFIG_Pots="1"
	#has S0 NT
	export CONFIG_IsdnNT="1"
	export CONFIG_IsdnTE="1"
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"

	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	export kernel_size="7798784"
	;;
"920"|"7570") 
  if [ "$1" == "920" ]; then
	export CLASS="Speedport"
	export SPNUM="920"
	export PROD="DECT_W920V" 
	export HWID="135"
  else
	export CLASS=""
	export SPNUM="7570"
	export PROD="7570"
	export HWID="146"
  fi
	export SPMOD="$1"
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_mimo_usb_host_dect_multiannex_13589"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_XILINX="y"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
	export CONFIG_DIAGNOSE_LEVEL="1"
#	export CONFIG_DIAGNOSE_LEVEL="0"
	#----dsl menu selection
	export CONFIG_ATA_FULL="n"
	export CONFIG_DSL_UR8="n"
	export CONFIG_DSL="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_VDSL="y"
	export CONFIG_VINAX="y"
# 	export CONFIG_VLYNQ0="3"
	export CONFIG_VINAX_TRACE="n"
	export CONFIG_LIBZ="y"
#	export CONFIG_LIBZ="n"
#	export CONFIG_VOL_COUNTER="y"
	export CONFIG_VOL_COUNTER="n"
	export CONFIG_PROV_DEFAULT="y"
#	export CONFIG_TAM_ONRAM="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
#	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
 	  export CONFIG_LABOR_DSL="n"
	fi 
	#----
	export CONFIG_LED_NO_DSL_LED="y"
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_DECT="y"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	export CONFIG_Pots="1"
	export CONFIG_IsdnNT="1"
	export CONFIG_IsdnTE="1"
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
#	export kernel_start="0x90010000"
	export kernel_start="0x90020000"
	export kernel_size="16121856"
#	export filesystem_start="0x90000000"
#	export filesystem_size="0"
	export urlader_start="0x90000000"
#	export urlader_size="65536"
	export urlader_size="131072"

	# needs differnet tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;
"7273")
	export CLASS=""
	export SPNUM="7270"
	export PROD="7270plus" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7270 v3"
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="145"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_usb_host_dect_plus_55266"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
	export CONFIG_DIAGNOSE_LEVEL="1"
	export CONFIG_DECT_14488="y"
	export CONFIG_ATA_NOPASSTHROUGH="y"
	export CONFIG_PROV_DEFAULT="y"
	export CONFIG_FON_IPPHONE="y"
	export CONFIG_VERSION_MAJOR="74"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_VDSL="n"
 	  export CONFIG_LABOR_DSL="n"
	fi 
	#----
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_Pots="1"
	export CONFIG_IsdnNT="1"
	export CONFIG_IsdnTE="1"
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
	export kernel_start="0x90020000"
	export kernel_size="16121856"
	export urlader_start="0x90000000"
	export urlader_size="131072"

	# needs different tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;
"7240")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7240"
	export PROD="7240"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7240"
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="144"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_dect_isdn_pots_wlan_33906"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
#	export CONFIG_DIAGNOSE_LEVEL="1"
	export CONFIG_DECT_14488="y"
	export CONFIG_ATA_NOPASSTHROUGH="y"
	export CONFIG_PROV_DEFAULT="y"
	export CONFIG_FON_IPPHONE="y"
	export CONFIG_CAPI="y"
	export CONFIG_CAPI_POTS="n"
	export CONFIG_CAPI_NT="n"
	export CONFIG_CAPI_TE="n"
	export CONFIG_VERSION_MAJOR="73"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_VDSL="n"
 	  export CONFIG_LABOR_DSL="n"
	fi 
	#----
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="4"
	export CONFIG_Pots="0"
	export CONFIG_IsdnNT="0"
	export CONFIG_IsdnTE="0"
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
	export kernel_start="0x90020000"
	export kernel_size="16121856"
	export urlader_start="0x90000000"
	export urlader_size="131072"

	# needs different tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;
"7141")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7141"
	export PROD="7141"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7141"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="108"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_1eth_2ab_isdn_te_pots_wlan_usb_host_49780"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_ATA_NOPASSTHROUGH="n"
	export CONFIG_FON_IPPHONE="y"
	export CONFIG_CAPI="y"
	export CONFIG_CAPI_NT="n"
	export CONFIG_CAPI_POTS="y"
	export CONFIG_CAPI_TE="y"
	export CONFIG_VERSION_MAJOR="40"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_VDSL="n"
 	  export CONFIG_LABOR_DSL="n"
	fi 
	#----
	export CONFIG_AB_COUNT="2"
	export CONFIG_ETH_COUNT="1"
	export CONFIG_Pots="1"
	export CONFIG_IsdnNT="0"
	export CONFIG_IsdnTE="1"
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
	export kernel_size="7798784"
	;;

*)
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="$1"
	export PROD="$1" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="$1"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="139"
	export HWRevision="${HWID}.1.0.6"
	PROD2="${PROD:0:2}"
	export kernel_size="7798784"
	if [ "$PROD2" == "72" ]; then
	    # 72XX firmwares needs differnet tool
	    export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	    export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	    export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	    export kernel_size="16121856"
	fi
	;;
	
esac

return 0
}
# get commandline options to variables
. $inc_DIR/processcomline
# make sure both downloadlinks are used 
## sed -i -e 's|http://download.avm.de/|@AVM/|g' $HOMEDIR/Config.in
## sed -i -e 's|ftp://ftp.avm.de/|@AVM/|g' $HOMEDIR/Config.in
# menuconfig uses Firmware.conf as Firmwareconfigfile and export must be adjusted
eval "$(sed -e 's|EXPORT_|export |' $HOMEDIR/${firmwareconf_file_name})"
echo "Firmware configuration taken from: ${firmwareconf_file_name}"
. $inc_DIR/includefunctions
# make sure Annex is set to A or B (muli uses B as default)
[ "$ANNEX" != "B" ] && [ "$ANNEX" != "A" ] && echo "Commandline annex parameter -x is: '$ANNEX' but must be 'A' or 'B'" && exit 0  
export kernel_args="annex=${ANNEX}" 
#[ "$CONFIG_DSL_MULTI_ANNEX" == "y" ] && export kernel_args="console=ttyS0,38400"
export CONFIG_ANNEX="${ANNEX}"
# set above variables according to your hardware
set_model "$SPMOD"
# set service portal url
export CONFIG_SERVICEPORTAL_URL="http://www.avm.de/de/Service/Service-Portale/Service-Portal/index.php?portal=FRITZ!Box_Fon_WLAN_$FBMOD"
echo
echo
echo
echo "********************************************************************************"
echo -e "\033[1mSpeed-to-Fritz version: ${MODVER}\033[0m"
echo "--------------------------------------------------------------------------------"
# ensure that scripts in sh_DIR, sh2_dir are executable because svn does not store unix metadata ;(
chmod +x "$sh_DIR"/* "$sh2_DIR"/*
# ensure that certain directories are in place
mkdir -p "$FWNEWDIR" "$FWORIGDIR"
#START
# delete privias Firmware of 11500 if needed
$sh2_DIR/del_zip "${AVM_DSL_7170_11500}" "${AVM_DSL_7270_11500}" "13014" 
# delete privias Firmware of 13014 if needed
$sh2_DIR/del_zip "${AVM_AIO_7170_13014}" "${AVM_AIO_7270_13014}" "13014" 
# extract source
. $inc_DIR/get_workingbase
# move avm to $OEM
[ "$MOVE_AVM_to_OEM" = "y" ] && $sh_DIR/move_avm_to_OEM.sh
# create backup for final compare
[ "$DO_FINAL_DIFF" = "y" ] || [ "$DO_FINAL_KDIFF3_2" = "y" ] || [ "$DO_FINAL_KDIFF3_3" = "y" ] && mkdir -p "${TEMPDIR}" && cp -fdpr "${FBDIR}"/*  --target-directory="${TEMPDIR}"  
# do a compare of AVM and AVM 2nd
[ -n "$TYPE_LOCAL_MODEL" ] && [ "$TYPE_LOCAL_MODEL" == "y" ] && [ "$DO_KDIFF3_3" = "y" ] && kdiff3 "${FBDIR}" "${FBDIR_2}"
# do a compare of TCOM and AVM
if [ -n "$TYPE_LOCAL_MODEL" ] || [ "$TYPE_LOCAL_MODEL" != "y" ]; then
    [ "$DO_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR}"
fi
# do a compare of source 1 (TCOM) , 2 (AVM) and 3
if [ -n "$TYPE_LOCAL_MODEL" ] || [ "$TYPE_LOCAL_MODEL" != "y" ]; then
    [ "$DO_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR_2}" "${FBDIR}"
fi
# do a compare of avm and 3
[ "$DO_DIFF" = "y" ] && ./0diff "${FBDIR}" "${FBDIR_2}" "./logAVMto3"
# do a compare of tcom and 3
[ "$DO_DIFF_TCOM" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logTCOMto3"
#
[ "$DO_NOT_STOP_ON_ERROR" = "n" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}" || rm -f "${HOMEDIR}/${ERR_LOGFILE}"
# get version from etc/.version into variables
. $inc_DIR/getversion
# get produkt from etc/default.F* into variables FBMOD, CONFIG_PRODUKT and CONFIG_SORCE
. $inc_DIR/getprodukt
# save some variabels to incl_var
. $sh2_DIR/settings
#print some Hardware setting found in the two firmwares in use
$sh2_DIR/dedect_HW
if SVN_VERSION="$(svnversion . | tr ":" "_")"; then
 [ "${SVN_VERSION:0:6}" == "export" ] && SVN_VERSION=""
 [ "$SVN_VERSION" != "" ] && SVN_VERSION="-r-$SVN_VERSION"
 SKRIPT_DATE+="$SVN_VERSION"
fi
# make sure all is set to correct rights
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 .
#[ ${FAKEROOT_ON} = "y" ] && $FAKEROOT chmod -R 755 .
echo "********************************************************************************"
echo -e "\033[1mPhase 3:\033[0m Copy sources."
echo "********************************************************************************"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
# Flashing original firmware image ...
if [ "$ORI" != "y" ]; then
 #prepare for use of Freetz Firmware 
 [ "$MOVE_ALL_to_OEM" = "y" ] && $sh_DIR/move_all_to_OEM.sh "${SRC}" || $sh_DIR/remake_link_avm.sh "${SRC}"
 # Please dont add conditions on models in any external file
 #enable ext2
 [ "$ENABLE_EXT2" = "y" ] && $sh2_DIR/patch_ext2 "${SRC}" "${DST}"
 case "$SPMOD" in
 "7570")
 . SxAVMx7570;;
 "920")
 . Speedport920;;
 "907")
 . Speedport907;;
 "707")
 . Speedport707;;
 "721")
 . Speedport721;;
 "500")
 . Speedport500;;
 "501")
 . Speedport501;;
 "503")
 . Speedport503;;
 "7141")
 . SxAVMx7141;;
 "7240")
 . SxAVMx7240v2;;
 "7273")
 . SxAVMx7270v3;;
 "7390")
 . SxAVMx7390;;
 *)
 . SxxxAVM;;
 esac
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 #copy Firmware.conf into image
 cp -f $firmwareconf_file_name .unstripped
 . FirmwareConfStrip
 #count bytes in Firmware.conf
 let act_firmwareconf_size="$(wc -c < "$firmwareconf_file_name")"
 cp $firmwareconf_file_name "${SRC}"/etc/Firmware.conf
 #tar Firmware.conf 
 [ -f "${SRC}"/etc/Firmware.conf ] && tar --owner=0 --group=0 --mode=0755 -cf "./Firmware.conf.tar" "$firmwareconf_file_name"
 mv -f .unstripped $firmwareconf_file_name
 #bug in home.js, causes mailfunction with tcom firmware, status page is empty
 [ "$DONT_ADD_HOMEFIX" != "y" ] && $sh_DIR/fix_homebug.sh
 #add missing files for tr064
 [ "$CONFIG_TR064" = "y" ] && $sh_DIR/copy_tr064_files.sh
 #remove help 
 [ "$REMOVE_HELP" = "y" ] && $sh_DIR/rmv_help.sh "${SRC}"
 #Add modinfo
 [ "$DONT_ADD_MODINFO" != "y" ] && $sh_DIR/add_modinfobutton.sh "${SRC}"
 #relace banner
 [ $COPY_HEADER = "y" ] && $sh_DIR/rpl_header.sh "${SRC}"
 #add addons
 if [ "$COPY_ADDON_TMP" = "y" ]; then
 	find ./addon/tmp/squashfs-root/ | while read file; do
		file="${file##./addon/tmp/squashfs-root/}"
		file="${SRC}"/"$file"
		[ -d "$file" ] || rm -f "$file"
	done
 	cp -fdpr  ./addon/tmp/squashfs-root/*  --target-directory="${SRC}"
 fi
 #patch p_maxTimeout on intenet page
 [ "$SET_PMAXTIMEOUT" = "y" ] && $sh_DIR/patch_pmaxTimeout.sh "${SRC}" "${OEMLIST}"
 #patch download url and add menuitem support
 [ "$ADD_SUPPORT" = "y" ] && $sh2_DIR/patch_url "${SRC}" "${OEMLIST}"
 #add dsl expert pages support
 [ "$ADD_DSL_EXPERT_MNUE" = "y" ] && $sh_DIR/add_dsl_expert.sh "${SRC}" "${OEMLIST}"
 #add omlinecounter pages 
 [ "$ADD_ONLINECOUNTER" = "y" ] && $sh_DIR/add_onlinecounter.sh "${SRC}" "${OEMLIST}"
 #replace assistent menuitem with enhanced settings 
 [ "$RPL_ASSIST" = "y" ] && $sh2_DIR/rpl_ass_menuitem "${SRC}" "${OEMLIST}" 
 #tam bugfix remove tams
 [ "$DONT_PATCH_TAMFIX" != "y" ] && $sh_DIR/patch_tam.sh "${SRC}"
 #gsm page    
 [ "$DO_GSM_PATCH" = "y" ] && $sh_DIR/disply_gsm.sh "${SRC}" "${OEMLIST}"
 #enable all providers
 [ "$SET_ALLPROVIDERS" = "y" ] && $sh_DIR/set_allproviders.sh
 #set expert view
 [ "$SET_EXPERT" = "y" ] && $sh_DIR/set_expertansicht.sh
 # reverse phonebook lookup
 [ "$DO_LOOKUP_PATCH" = "y" ] && $sh2_DIR/patch_fc "${SRC}"
 # add MAC settings to internet page
 [ "$ADD_MACSETTING" = "y" ] && $sh_DIR/add_MAC_settings.sh  "${SRC}" "${OEMLIST}"
 # remove tcom and some other oem dirs and add link instead to enable other brands.
 [ "$DONT_LINK_OENDIRS" != "y" ] && $sh2_DIR/add_tcom_link "${SRC}"
 #add kaid for xbox 
 [ "$ADD_KAID" = "y" ] && $sh2_DIR/add_kaid
 #exchange kernel 
 if [ "$XCHANGE_KERNEL" = "y" ]; then 
 	echo "-- Take Speedport kernel for new image"
 	cp -rfv "${SPDIR}/kernel.raw" "${FBDIR}/kernel.raw"
 elif [ "$SRC2_KERNEL" = "y" ]; then
 	echo "-- Take kernel from 2nd AVM source for new image"
	cp -rfv "${FBDIR_2}/kernel.raw" "${FBDIR}/kernel.raw"
 #else
 #	echo "-- Take AVM kernel for new image"
 fi
 #remove signature
 [ "$DONT_REM_SIGNATUR" != "y" ] && $sh_DIR/rmv_signatur.sh "${SRC}"
 #remove autoupdate tab
 [ "$DONT_REM_AUTOUPDATETAB" != "y" ] && $sh_DIR/remove_autoupdatetab.sh "${SRC}"
 # add_regext in GUI
 [ "$ADD_REGEXT_GUI" == "y" ] && $sh_DIR/add_ext_in_gui.sh "${SRC}"
 # patch update pages 
 [ "$DONT_PATCH_TOOLS" != "y" ] && $sh_DIR/patch_tools.sh "${SRC}"
 # update modules dependencies
 [ "$UPDATE_DEPMOD" = y ] && $sh_DIR/update-module-deps.sh "${SRC}" "${KernelVersion}"
 # add info to /usr/bin/system_status
 [ "$DONT_ADD_MODINFO" != "y" ] && $sh2_DIR/patch_system_status "${SRC}"
 #export download links
 $HOMEDIR/extract_rpllist.sh
 # set OEM via rc.S not via environment
 [ "$PATCH_OEM" = "y" ] && $sh2_DIR/patch_OEMandMyIP "${SRC}"
 #packing takes place on SPDIR
 export SPDIR="${FBDIR}"
 #--> Add patches here if the shold not be applayed with Option restore original!
 # If patches should only be applyed to a special type, then add this patches
 # on the end of individual files like "Speedport920".
 #<-- Add patches here - end!
 echo "********************************************************************************"
 echo -e "\033[1mPhase 9:\033[0m Patch install."
 echo "********************************************************************************"
else
 # --> Only Tcom firmware with otion "restore original"
 # get OEM from original Firmware
 readConfig "OEM_DEFAULT" "OEM" "${DST}/etc/init.d"
 [ -d "${DST}/usr/www/avme" ] &&  export OEM="avme"
 [ -d "${DST}/usr/www/tcom" ] &&  export OEM="tcom"
 [ -d "${DST}/usr/www/congstar" ] &&  export OEM="congstar"
 # add addons
 [ "$COPY_ADDON_TMP_to_ORI" = "y" ] &&  cp -fdpr  ./addon/tmp/squashfs-root/*  --target-directory="${DST}"
 # exchange kernel
 [ "$XCHANGE_KERNEL" = "y" ] && cp -rfv "${FBDIR}/kernel.raw" "${SPDIR}/kernel.raw"
 [ "$SRC2_KERNEL" = "y" ] && cp -rfv "${FBDIR_2}/kernel.raw" "${FBDIR}/kernel.raw"
 echo "Assembling original TCOM Firmware for transfer via FTP and Webinterface ..."
 echo
 echo "Some changes are made to the original tar file, so it can be used on "
 echo "Speedports with AVM Web GUI to flash back to the original T-COM firmware."
 echo "This is always a downgrade, and depending on the amount of difference it is"
 echo "not for sure that it will work in every case, if the router is rebooting after"
 echo "a downgrade via webinterface, you must use a recover tool or CLEAR_ENV"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 # patch update pages 
 $sh_DIR/patch_tools.sh "${DST}"
 # set OEM via rc.S not via environment
 [ "$PATCH_OEM" = "y" ] && $sh2_DIR/patch_OEMandMyIP "${DST}"
 # Copy stripped Firmware.conf to Firmware.conf.tar
 cp -f $firmwareconf_file_name .unstripped
 . FirmwareConfStrip
 [ -f $firmwareconf_file_name ] && tar --owner=0 --group=0 --mode=0755 -cf "./Firmware.conf.tar" "$firmwareconf_file_name"
 mv -f .unstripped $firmwareconf_file_name
 # <-- Only Tcom
fi
#-->All firmwares, if patches added here the are applied to tcom firmware with option "restore original" as well!
# patch portrule to enable forwarding to box itself
#--------------------------------------------------------------------------------------------------------------- 
# add s2f config file
[ "$ADD_S2F_CONF" = "y" ] && subscripts2/add_s2f_configfile "${SRC}" && $TAR xvzf packages/s2f_flash.tgz -C "${SRC}" 2> /dev/null
# add default route
[ "$PATCH_PORTRULE" = "y" ] && $sh2_DIR/patch_portrule "${SRC}"
# add own files 
[ "$ADD_OWN" = "y" ] && $TAR c -C custom/rootfs . 2>/dev/null | $TAR x -C "${SRC}" 2> /dev/null
# add dropbear files 
[ "$ADD_PKG_DROPBEAR" = "y" ] && $TAR xvzf packages/dropbear.tgz -C "${SRC}" 2> /dev/null
# dont set kernel annex args, if it is a multi annex firmware
readConfig "DSL_MULTI_ANNEX" "DSL_MULTI_ANNEX" "${SRC}/etc/init.d"
[ "$DSL_MULTI_ANNEX" == "y" ] && export kernel_args="console=ttyS0,38400"
# make firmware installable via GUI
$sh_DIR/patch_install.sh "${SPDIR}"
# first approach to make external SIP registration configurable on WebUI
[ "$PATCH_EXT_SIP" = "y" ] && $sh2_DIR/patch_sip_from_extern "${SRC}"
#<--All firmwares
#. $inc_DIR/testerror
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 "${FBDIR}"
echo "********************************************************************************"
echo -e "\033[1mPhase 10:\033[0m Pack and deliver."
echo "********************************************************************************"
# do a final compare
exec 2> /dev/null
[ "$DO_FINAL_DIFF" = "y" ] && ./0diff "${SPDIR}" "${TEMPDIR}" "./logFINALtoAVM"
[ "$DO_FINAL_DIFF_SRC2" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logFINALto3"
if [ -n "$TYPE_LOCAL_MODEL" ] || [ "$TYPE_LOCAL_MODEL" != "y" ];then
    [ "$DO_FINAL_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${TEMPDIR}"
fi
[ "$DO_FINAL_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR_2}" "${TEMPDIR}"
#[ "$TYPE_LOCAL_MODEL" == "y" ] && [ "$DO_FINAL_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${TEMPDIR}"
[ "$DO_NOT_STOP_ON_ERROR" = "n" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}"
# compose filename for new .tar file
[ "7570" == "${TYPE_LABOR_TYPE:0:4}" ] && AVM_SUBVERSION="7570-$AVM_SUBVERSION"
[ "y" == "${TYPE_TCOM_7570_70}" ] && TCOM_SUBVERSION="7570-$TCOM_SUBVERSION"
[ ${FREETZ_REVISION} ] && FREETZ_REVISION="-freetz-${FREETZ_REVISION}"
PANNEX="_annex${ANNEX}"
[ "$DSL_MULTI_ANNEX" == "y" ] && PANNEX=""
readConfig "MULTI_LANGUAGE" "MULTI_LANGUAGE" "${SRC}/etc/init.d"
#Language="_${FORCE_LANGUAGE}"
Language="_${avm_Lang}"
[ "$MULTI_LANGUAGE" == "y" ] && Language=""
[ "$FORCE_CLEAR_FLASH" == "y" ] && CLEAR="C_" || CLEAR="" 
[ "$CLASS" != "" ] && CLASS+="_"
[ "$SPNUM" != "" ] && SPNUM+="_"
[ "$ORI" != "y" ] && export NEWIMG="fw_${CLEAR}${CLASS}${SPNUM}${TCOM_VERSION_MAJOR}.${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}-${act_firmwareconf_size}_OEM-${OEM}${PANNEX}${Language}.image"
[ "$ORI" == "y" ] && export NEWIMG="${SPIMG}_OriginalTcomAdjusted${PANNEX}${Language}.image"
[ "$ATA_ONLY" = "y" ] && export NEWIMG="fw_${CLEAR}${CLASS}${SPNUM}${TCOM_VERSION_MAJOR}.${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}-${act_firmwareconf_size}_OEM-${OEM}_ATA-ONLY${Language}.image"
#only AVM + 2nd AVM Firmware was in use
[ "$TYPE_LOCAL_MODEL" == "y" ] && export NEWIMG="fw_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_2_VERSION_MAJOR}.${AVM_2_VERSION}-${AVM_2_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}-${act_firmwareconf_size}_OEM-${OEM}${PANNEX}${Language}.image"
echo "export MULTI_LANGUAGE=\"${MULTI_LANGUAGE}\"" >> incl_var
echo "export kernel_args=\"${kernel_args}\"" >> incl_var
echo "export NEWIMG=\"${NEWIMG}\"" >> incl_var
# print some info on screen
. $inc_DIR/print_settings
if [ "$VERBOSE" = "-v" ]; then
echo "Ready for packing... Press 'ENTER' to continue..."
 while !(read -s);do
    sleep 1
 done
fi
if [ "$SET_UP" = "n" ]; then
 #wrap all up again
 echo "Creating filesystem image, be patient ..."
 printprogress "build_firmware" "DontWaitForStart"
 [ ${FAKEROOT_ON} == "y" ] && export MAKE_DEV="y"
 [ ${FAKEROOT_ON} == "y" ] && $FAKEROOT $inc_DIR/build_firmware "$SPDIR" "${NEWDIR}" "${NEWIMG}" &
 [ ${FAKEROOT_ON} != "y" ] && $inc_DIR/build_firmware "$SPDIR" "${NEWDIR}" "${NEWIMG}" &
 printprogress "build_firmware" "WaitForStart"
 echo
 . $inc_DIR/testerror
 # build recover
 [ "$BUILDRECOVER" = "y" ] && $HOMEDIR/build_new_recover_firmware
	echo "********************************************************************************"
 if [ "$PUSHCONF" = "y" ]; then
	echo "Flashing firmware image $NEWDIR/kernel.image..."
	echo "********************************************************************************"
	echo
 	#FTP kann nicht mit zwei Parametern von quote uebergeben,  ${kernel_args} verursacht Fehlermeldung	
	pushconfig "${NEWDIR}" "${OEM}" "${CONFIG_PRODUKT}" "${HWRevision}" "${ETH_IF}" "${IPADDRESS}" "${CONFIG_jffs2_size}" "${kernel_args}" "${ANNEX}"
	echo
	echo "Finished transfering kernel.image to Speedport. Enjoy!"
	echo
	echo "********************************************************************************"
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
# Strip Firmware.conf only if all was completed without error
# a control C brack will keep the unstripped Firmware.conf 
# Firmware.conf.tar was generated earlyer.
## . FirmwareConfStrip
echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0
