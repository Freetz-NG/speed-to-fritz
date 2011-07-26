#!/bin/bash
export PATH=$PATH:/sbin
##########################################################################
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
#build own device table, use tools device_table.txt looks like it is not needed if complete sp-to-fritz.sh script rans as root or fakeroot
#We dont use aditional divices like freetz, so it is easyer not to maintine a upto date device_table.txt
export MAKE_DEV="y"
#pack expanded directory /var.tar > /squashfs-root/usr/var.tar, normally not needed 
export PACK_VARTAR="y"
# My Tools:
#---->
export HOMEDIR="`pwd`"
TOOLS_SUBDIR="tools"
export TOOLS_DIR="${HOMEDIR}/${TOOLS_SUBDIR}"
export include_modpatch="${TOOLS_DIR}/freetz_patch"
export include_isfreetz="${TOOLS_DIR}/freetz_functions"
export UNSQUASHFS_TOOL="unsquashfs3-lzma"
export UNSQUASHFS="${TOOLS_DIR}/${UNSQUASHFS_TOOL}"
export FINDSQUASHFS_TOOL="find-squashfs"
export FINDSQUASHFS="${TOOLS_DIR}/${FINDSQUASHFS_TOOL}"
export MKSQUASHFS_TOOL="mksquashfs-lzma"
export MKSQUASHFS_OPTIONS="-le -noappend -all-root -info"
export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
export TICHKSUM_TOOL="tichksum"
export TICHKSUM="${TOOLS_DIR}/${TICHKSUM_TOOL}"
#export TICHKSUM="$TOOLS_DIR/TI-chksum-0.1/tichksum"
export RMTICHKSUM_TOOL="rmtichksum"
export RMTICHKSUM="${TOOLS_DIR}/${RMTICHKSUM_TOOL}"
export TAR_TOOL="oldtar/tar"
export TAR="${TOOLS_DIR}/${TAR_TOOL}"
export UNTAR="${TOOLS_DIR}/${TAR_TOOL}"
export NEW_WRAP="n"
export TAR_RFS_OPTIONS="--owner=0 --group=0"
export TAR_OPTIONS="--owner=0 --group=0 --mode=0755 --format=oldgnu"
##--> temporarily use system tar to unpack avm images 
#export UNTAR="$(which tar)"
## dont use options
#### lead to 'Puefsummenfeher' if firmware is updated via GUI
#export TAR_RFS_OPTIONS=""
#export TAR_OPTIONS=""
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
export FREETZPATCH_DIR="$HOMEDIR/alien/freetz/patches"
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
# Don't change any parameters below here
# This parameters are used in the resulting Speedport image
export CONFIG_ACCESSORY_URL=""
export CONFIG_FIRMWARE_URL="http://www.t-com.de/downloads"
# Set defaults for branding ('avm') and hostname ('fritz.box')
export OEMLIST="avme avm aol 1und1 freenet hansenet tcom all congstar otwo"
export OEMLINKS="aol 1und1 freenet hansenet tcom all congstar otwo"
export OEM="avm"
export CONFIG_OEM_DEFAULT="avm"
export HOSTNAME=""
export NEWNAME=""
export FBHWRevision=""
# Preset if no specified lat
# This as the default up to 29.04.80.
export flash_start="0x1f000000"
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
export CONFIG_DECT_14488="n"
#export ANNEX="B"
export ECHO_ROT="\033[31m"
export ECHO_GRUEN="\033[32m"
export ECHO_BOLD_GRUEN="\033[47m\033[32m"
export ECHO_GELB="\033[33m"
export ECHO_BLAU="\033[34m"
export ECHO_BOLD_BLAU="\033[47m\033[34m"
export ECHO_LILA="\033[35m"
export ECHO_TUERKIS="\033[36m"
export ECHO_HELL_GRAU="\033[37m"
export ECHO_BOLD="\033[1m"
export ECHO_END="\033[0m"
export _Y="\\033[33m"
export __Y="\033[33m"
export _N="\\033[m"
export __N="\033[m"

# function set_model()
# Sets the model dependent parameters
# SPMOD ist the only parameter to be changed according to your hardware 
# Values for SPMOD: "500" (for SI W500V)
#                   "501" (for SP W501V)
#                   "503" (for SP W503V)
#                   "701" (for SP W701V)
#                   "721" (for SP W721V)
#                   "900" (for SP W900V)
#                  "7240" (for AVM 7240v2)
#                 "7271" (for AVM 7270v1)
#                 "7272" (for AVM 7270v2)
#                 "7273" (for AVM 7270v3)
#                 "7570" (for AVM 7570)
#                 "757H" (for HN 7570)
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
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7150"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
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
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7140"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
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
	export HWID="101"
	export PROD="SpeedportW701V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
#	FBMOD variable is read later from 2nd Firmware
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
if [ "$KEEP_USB" = "y" ]; then
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbWlan="1"
	export CONFIG_UsbPrint="1"
	export CONFIG_USB_HOST_AVM="y"
	export CONFIG_USB_PRINT_SERV="y"
	export CONFIG_USB_STORAGE="y"
	export CONFIG_USB_STORAGE_USERS="y"
	export CONFIG_USB_WLAN_AUTH="y"
else
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="0" 
	export CONFIG_UsbStorage="0"
	export CONFIG_UsbWlan="0"
	export CONFIG_UsbPrint="0"
	export CONFIG_USB_HOST_AVM="n"
	export CONFIG_USB_PRINT_SERV="n"
	export CONFIG_USB_STORAGE="n"
	export CONFIG_USB_STORAGE_USERS="n"
	export CONFIG_USB_WLAN_AUTH="n"
fi
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
#	FBMOD variable is read later from 2nd Firmware
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
	export SPMOD="722"
	export CLASS="Speedport"
	export SPNUM="722"
	export PROD="SpeedportW722V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7390"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="154"
	export HWID="152"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_te_pots_wlan_usb_host_57937"
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
	export CONFIG_USB_WLAN_AUTH="y"
	export CONFIG_USB_HOST_TI="n"
	export CONFIG_USB_STORAGE_SPINDOWN="y"
	export CONFIG_USB_INTERNAL_HUB="n"
	export CONFIG_DECT2="n"
	export CONFIG_USB="n"
	export CONFIG_CAPI_POTS="y"
	export CONFIG_CAPI_TE="y"
	export CONFIG_CAPI_MIPS="n"
	export CONFIG_CAPI_NT="y"
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
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	export MKSQUASHFS_OPTIONS="-be -noappend -all-root -info -no-progress -no-exports -no-sparse"
# results in zlib error -3
#	export MKSQUASHFS_TOOL="mksquashfs4-lzma"
#	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
#	export MKSQUASHFS_OPTIONS="-noappend -all-root -info -no-progress -no-exports -no-sparse"
	export kernel_start="0x9F020000"
	export kernel_size="15597568"
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
#	FBMOD variable is read later from 2nd Firmware
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
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	export MKSQUASHFS_OPTIONS="-be -noappend -all-root -info -no-progress -no-exports -no-sparse"
# results in zlib error -3
#	export MKSQUASHFS_TOOL="mksquashfs4-lzma"
#	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
#	export MKSQUASHFS_OPTIONS="-noappend -all-root -info -no-progress -no-exports -no-sparse"
	export kernel_start="0x9F020000"
	export kernel_size="15597568"
	export filesystem_start="0x9F000000"
	export filesystem_size="0"
	export urlader_start="0x9F000000"
	export urlader_size="131072"
	export flash_start="520093696"
    ;;
"503")
	export SPMOD="503"
	export CLASS="Speedport"
	export SPNUM="503"
	export PROD="SpeedportW503V"
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="122"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	export HWID="136"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ur8_8MB_xilinx_4eth_2ab_isdn_pots_wlan_25488"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"
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

	export CONFIG_DECT_MONI="n"
	export CONFIG_DECT_AUDIOD="n"
	export CONFIG_DECT_CATIQ20="n"
	export CONFIG_DECT_ONOFF="n"
	export CONFIG_DECT="n"
	export CONFIG_DECT_NO_EMISSION="n"
	export CONFIG_DECT_MONI_EX="n"
	export CONFIG_DECT2="n" # Eintrag unter Anschlsse verschwindet
	export CONFIG_DECT_14488="n"

	export CONFIG_TAM="n"
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
	export CONFIG_AUDIO="n"
	export CONFIG_AURA="n"
	export CONFIG_SAMBA="n"
	export CONFIG_KIDS="n"
	export CONFIG_WEBUSB="n"
	#--> 7270
	export CONFIG_PROV_DEFAULT="y"
	export CONFIG_KIDS_CONTENT="n"
	#export CONFIG_IPV6="y"
	export CONFIG_EXT2="n"
	#export CONFIG_MTD_MAILSEND="y"
	export CONFIG_USB_GSM_VOICE="n"
	export CONFIG_RAMDISK="n"
	export CONFIG_DOCSIS_CLI="n"
	#export CONFIG_DOCSIS="n"
	export CONFIG_NAS="n"
	#export CONFIG_EWETEL_SMARTMETER="n"
	#export CONFIG_WLAN_WEATHER_CAC="n"
	#export CONFIG_WLAN_GUEST="n"
	#export CONFIG_SPEECH_FEEDBACK="y"
	#export CONFIG_DOCSIS_PCD_NO_REBOOT="n"
	#<-- 7270
	export CONFIG_VDSL="n"
	export CONFIG_VINAX="n"
	export CONFIG_VLYNQ="y"
#	export CONFIG_VLYNQ0="0"
	export CONFIG_VLYNQ0="3"
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
	# needs different tool
##	export UNSQUASHFS_TOOL="unsquashfs4-lzma"
##	export UNSQUASHFS="${TOOLS_DIR}/${UNSQUASHFS_TOOL}"
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	export MKSQUASHFS_OPTIONS="-le -noappend -all-root -info -no-progress -no-exports -no-sparse"
# results in zlib error -3
#	export MKSQUASHFS_TOOL="mksquashfs4-lzma"
#	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
#	export MKSQUASHFS_OPTIONS="-noappend -all-root -info -no-progress -no-exports -no-sparse"
    ;;
"900"|"907") 
	export SPMOD="907"
	export CLASS="Speedport"
	export SPNUM="900"
	export PROD="DECT_W900V" 
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="102"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_usb_host_dect_37264"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"

	export CONFIG_DECT_ONOFF="y"
	export CONFIG_DECT="y"
	export CONFIG_DECT_NO_EMISSION="n"
	export CONFIG_DECT_MONI_EX="n"
	export CONFIG_DECT2="y" # Eintrag unter Anschlsse verschwindet
	export CONFIG_DECT_14488="n"

	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"
	export CONFIG_GDB_SERVER="n"
	export CONFIG_PLUGIN="n"
	
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
"920"|"7570"|"757H")
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
  if [ "$1" == "757H" ]; then
	export CLASS=""
	export SPNUM="7570"
	export PROD="7570_HN"
	export HWID="153"
	#export FBHWRevision="153"
  fi
	export SPMOD="$1"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	echo $AVM_IMG | grep -q "v1" && [ "$FBHWRevision" == "139" ] && export FBHWRevision="122"
	echo $AVM_IMG | grep -q "7570" && [ "$FBHWRevision" == "139" ] && export FBHWRevision="145"
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
	export CONFIG_VOL_COUNTER="y"
#	export CONFIG_VOL_COUNTER="n"
	export CONFIG_PROV_DEFAULT="y"
#	export CONFIG_TAM_ONRAM="n"
#	export CONFIG_DSL_MULTI_ANNEX="n"
#--> 7270 uses this
	#export CONFIG_WEBUSB="y"
	#export CONFIG_KIDS_CONTENT="n"
	#export CONFIG_IPV6="y"
	#export CONFIG_DECT_CATIQ20="n"
	#export CONFIG_EXT2="y"
	#export CONFIG_MTD_MAILSEND="y"
	#export CONFIG_USB_GSM_VOICE="n"
	#export CONFIG_RAMDISK="y"
	#export CONFIG_DOCSIS_CLI="n"
	#export CONFIG_DECT_NO_EMISSION="y"
	#export CONFIG_DOCSIS="n"
	export CONFIG_NAS="y"
	#export CONFIG_EWETEL_SMARTMETER="n"
	#export CONFIG_WLAN_WEATHER_CAC="n"
	#export CONFIG_WLAN_GUEST="n"
	#export CONFIG_SPEECH_FEEDBACK="y"
	#export CONFIG_DOCSIS_PCD_NO_REBOOT="n"
## <--
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
	# needs differnet tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
#	export filesystem_size="0"
#	export filesystem_start="0x90000000"
	export urlader_start="0x90000000"
#	export urlader_size="65536"  #0x10000
	export urlader_size="131072" #0x20000
#	export kernel_start="0x90010000"
	export kernel_start="0x90020000" 
	export kernel_size="16121856" #0xF60000
if [ "$1" == "757H" ]; then
	export urlader_size="262144" #0x40000
	export kernel_start="0x90040000"
	export kernel_size="7995392" #0x7A0000 Original Eintrg bei alice
	#angepasst braucht Freetz kernel
	[ "$TYPE_HN_7570_8_16" == "y" ] && export kernel_size="15990784" #0xF40000
fi
#7570
#HN env.          size 
#    mtd0:         0000          0x90000000,0x90000000 # "rootfs"
#    mtd2:      0x40000          0x90000000,0x90040000 # "urlader"
#    mtd1:     0x7A0000          0x90040000,0x907E0000 # "kernel"
#    mtd5:     0x7A0000          0x907E0000,0x90F80000 # "rootfs" +  "kernel" #(6bd500 + e2b00 = 7A0000)
#    mtd3:      0x40000          0x90F80000,0x90FC0000 # "tffs (1)"
#    mtd4:      0x40000          0x90FC0000,0x91000000 # "tffs (2)"
# cat /proc/mtd sagt das hier:
#dev:    size   erasesize  name
#mtd0: 006bd500 00020000 "rootfs" 
#mtd2: 00040000 00020000 "urlader"
#mtd1: 000e2b00 00020000 "kernel" # (6bd500 + e2b00 = 7A0000)
#mtd5: 01000000 00020000 "reserved" # size dez: 16777216
#mtd3: 00040000 00020000 "tffs (1)"
#mtd4: 00040000 00020000 "tffs (2)"
    ;;
"7271")
	export CLASS=""
	export SPNUM="7270"
	export PROD="7270" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7270 v1"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="122"
	export HWID="122"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ur8_8MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_usb_host_dect_05265"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="8"
	export CONFIG_DIAGNOSE_LEVEL="1"
	export CONFIG_DECT_14488="n"
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
	export kernel_start="0x90010000"
	export kernel_size="7798784"
	export urlader_start="0x90000000"
	export urlader_size="65536"
	# needs different tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;
"7272")
	export CLASS=""
	export SPNUM="7270"
	export PROD="7270" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7270 v2"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="139"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_usb_host_dect_61056"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
	export CONFIG_DIAGNOSE_LEVEL="1"
	export CONFIG_DECT_14488="n"
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
"7273")
	export CLASS=""
	export SPNUM="7270"
	export PROD="7270plus" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7270 v3"
#	FBMOD variable is read later from 2nd Firmware
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
#	FBMOD variable is read later from 2nd Firmware
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
"7140")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7140"
	export PROD="7140"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7140"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="95"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_4eth_2ab_isdn_te_pots_wlan_usb_host_62068"
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
	export CONFIG_ETH_COUNT="4"
	export CONFIG_Pots="1"
	export CONFIG_IsdnNT="0"
	export CONFIG_IsdnTE="1"
	export CONFIG_Usb="0" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
	export kernel_size="7798784"
	;;
"7141")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7141"
	export PROD="7141"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN 7141"
#	FBMOD variable is read later from 2nd Firmware
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
	export CONFIG_Usb="1" 
	export CONFIG_UsbHost="1" 
	export CONFIG_UsbStorage="1"
	export CONFIG_UsbPrint="1"
	export kernel_size="7798784"
	;;
"5to2")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7270"
	export PROD="7570_HN"
	export HWID="153"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7570"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="153"
	export HWRevision="${HWID}.1.0.6"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
	export CONFIG_DIAGNOSE_LEVEL="1"
	export CONFIG_DECT_14488="n"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_VDSL="n"
 	  export CONFIG_LABOR_DSL="n"
	fi 
	export CONFIG_AB_COUNT="3"
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
"5to7")
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="7150"
	export PROD="7150"
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="106" #128 Annex A
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_1eth_0ab_pots_isdn_te_usb_host_wlan_dect_57042"
	export CONFIG_XILINX="y"
	export CONFIG_BOX_FEEDBACK="n"
	export CONFIG_LED_NO_DSL_LED="n"

	export CONFIG_DECT_ONOFF="y"
	export CONFIG_DECT="y"
	export CONFIG_DECT_NO_EMISSION="n"
	export CONFIG_DECT_MONI_EX="n"
	export CONFIG_DECT2="y" # Eintrag unter Anschlsse verschwindet
	export CONFIG_DECT_14488="n"

	export CONFIG_GDB="n"
	export CONFIG_GDB_FULL="n"
	export CONFIG_GDB_SERVER="n"
	export CONFIG_PLUGIN="n"
	
	export CONFIG_VOL_COUNTER="y"
# is set via menu
#	export CONFIG_TR064=""
#	export CONFIG_TR069=""
	export CONFIG_UsbWlan="0"
	export CONFIG_Debug="0"
	export CONFIG_jffs2_size="32"
	export CONFIG_RAMSIZE="32"
	export CONFIG_ROMSIZE="8"
	export CONFIG_AB_COUNT="0"
	export CONFIG_ETH_COUNT="1"
	export CONFIG_MAILER="y"
	export CONFIG_UPNP="y"
	export CONFIG_TAM="y"
	export CONFIG_TAM_MODE="1"
	export CONFIG_MAILER2="y"
	export CONFIG_Pots="1"
	#has S0 NT
	export CONFIG_IsdnNT="0"
	export CONFIG_IsdnTE="1"
	export CONFIG_USB="y"
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
	kernel_start="0x90010000"
	urlader_start="0x90000000"
	urlader_size="65536"
	;;
*)
	export SPMOD="$1"
	export CLASS=""
	export SPNUM="$1"
	export PROD="$1" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
#	FBMOD variable is read later from 2nd Firmware
	[ "$FBMOD" == "" ] && export FBMOD="$1"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="139"
	export HWRevision="${HWID}.1.0.6"
	PROD2="${PROD:0:2}"
	export kernel_size="16121856"
	if [ "$PROD2" == "72" ]; then
	    # 72XX firmwares needs differnet tool
	    export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	    export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	    export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	    export kernel_size="16121856"
	fi
	;;
esac
if [ "${ENFORCE_HWREVISION}" == "y" ]; then
 middle_newHWver=${HWRevision%.*}; middle_newHWver=${middle_newHWver#*.} # dazwischen
 minor_newHWver=${HWRevision##*.} # ab dem letzten Punkt
 echo "New HW revision: \"${FBHWRevision}.${middle_newHWver}.${minor_newHWver}\""
 export HWRevision="${FBHWRevision}.${middle_newHWver}.${minor_newHWver}"
fi
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
echo -e "\033[1mSpeed-to-Fritz revision: ${SVN_REVISION}\033[0m"
echo "--------------------------------------------------------------------------------"
# ensure that scripts in sh_DIR, sh2_dir are executable because svn does not store unix metadata ;(
chmod +x "$sh_DIR"/* "$sh2_DIR"/*
# ensure that certain directories are in place
mkdir -p "$FWNEWDIR" "$FWORIGDIR"
#START
# delete privias Firmware of 11500 if needed
$sh2_DIR/del_zip "${AVM_DSL_7170_11500}" "${AVM_DSL_7272_11500}" "13014" 
# delete privias Firmware of 13014 if needed
$sh2_DIR/del_zip "${AVM_AIO_7170_13014}" "${AVM_AIO_7272_13014}" "13014" 
# extract source
echo "********************************************************************************"
echo -e "\033[1mPhase 1:\033[0m Download or check firmware images"
echo "********************************************************************************"
. $inc_DIR/get_workingbase
# move avm to $OEM
[ "$MOVE_AVM_to_OEM" = "y" ] && $sh_DIR/move_avm_to_OEM.sh
# create backup for final compare
#[ "$DO_FINAL_DIFF" = "y" ] || [ "$DO_FINAL_KDIFF3_2" = "y" ] || [ "$DO_FINAL_KDIFF3_3" = "y" ] && 
[ -d "${FBDIR}" ] && mkdir -p "${TEMPDIR}" && cp -fdpr "${FBDIR}"/*  --target-directory="${TEMPDIR}"
# do a compare of AVM and AVM 2nd
[ -n "$TYPE_SXXX_MODEL" ] && [ "$TYPE_SXXX_MODEL" == "y" ] && [ "$DO_KDIFF3_3" = "y" ] && kdiff3 "${FBDIR}" "${FBDIR_2}"
# do a compare of TCOM and AVM
if [ -n "$TYPE_SXXX_MODEL" ] || [ "$TYPE_SXXX_MODEL" != "y" ]; then
    [ "$DO_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR}"
fi
# do a compare of source 1 (TCOM) , 2 (AVM) and 3
if [ -n "$TYPE_SXXX_MODEL" ] || [ "$TYPE_SXXX_MODEL" != "y" ]; then
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
# make sure all is set to correct rights
#[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 . #&& echo "Scrit is executed as root, 777 set to all files."
# Flashing original firmware image ...
if [ "$ORI" != "y" ]; then
 #add patches taken from freetz without adaptions
 [ "$FREETZ_SCRIPTS" == "y" ] && $sh2_DIR/add_freetz_type_patches.sh "${SRC}" "${DST}"
 #move avm or freenet, hansenet, avm or avme dir, if $OEM dir is missing
 $sh_DIR/move_avm_to_OEM.sh "${SRC}"
 #prepare for use with Freetz Firmware, replace oem dirs with links to $OEM
 [ "$MOVE_ALL_to_OEM" = "y" ] && $sh_DIR/move_all_to_OEM.sh "${SRC}" || $sh_DIR/remake_link_avm.sh "${SRC}"
 [ -d "${SRC}"/usr/www/$OEM ] && export OEMLINK=$OEM
 # looks like there is no need for using device-table.txt if the complete sp-fritz.sh is wraped with fake root
 cp -fdrp "${DST}/dev" "${SRC}/dev" && export MAKE_DEV="n" && echo "-- merged source and destination /dev directory"
 #enable ext2
 [ "$ENABLE_EXT2" = "y" ] && $sh2_DIR/patch_ext2 "${SRC}" "${DST}"
 echo "********************************************************************************"
 echo -e "\033[1mPhase 2:\033[0m Apply modell dependend changes"
 echo "********************************************************************************"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 case "$SPMOD" in
 "920" | "7570" | "757H")
 . Speedport920;;
 "907")
 . Speedport907;;
 "707")
 . Speedport707;;
 "721")
 . Speedport721;;
 "722")
 . Speedport722;;
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
# "7271")
# . SxAVMx7270v1;;
# "7272")
# . SxAVMx7270v2;;
 "7273")
 . SxAVMx7270v3;;
 "7390")
 . SxAVMx7390;;
 "5to2")
 . 7570to7270;;
 "5to7")
 . 7150to7170;;
 *)
 . SxxxAVM;;
 esac
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 echo "********************************************************************************"
 echo -e "\033[1mPhase 3:\033[0m Apply modell independet changes"
 echo "********************************************************************************"
 #tar Firmware.conf
 . FirmwareConfArch
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
 [ "$SET_PMAXTIMEOUT" = "y" ] && $sh_DIR/patch_pmaxTimeout.sh "${SRC}" "${OEM}"
 #patch download url and add menuitem support , and freetz
 [ "$ADD_SUPPORT" == "y" ] && $sh2_DIR/patch_url "${SRC}"
 #add dsl expert pages support
 [ "$ADD_DSL_EXPERT_MNUE" = "y" ] && $sh_DIR/add_dsl_expert.sh "${SRC}" "${OEM}"
 #add omlinecounter pages 
 [ "$ADD_ONLINECOUNTER" = "y" ] && $sh_DIR/add_onlinecounter.sh "${SRC}"
 #replace assistent menuitem with enhanced settings 
 [ "$RPL_ASSIST" = "y" ] && $sh2_DIR/rpl_ass_menuitem "${SRC}" 
 #tam bugfix remove tams
 [ "$DONT_PATCH_TAMFIX" != "y" ] && $sh_DIR/patch_tam.sh "${SRC}"
 #gsm page    
 [ "$DO_GSM_PATCH" = "y" ] && $sh_DIR/disply_gsm.sh "${SRC}" "${OEM}"
 #enable all providers
 [ "$SET_ALLPROVIDERS" = "y" ] && $sh_DIR/set_allproviders.sh
 #enable provider AON
 [ "$ADD_PROVIDER_AON" = "y" ] && $sh_DIR/add_provider_aon.sh
 #set expert view
 [ "$SET_EXPERT" = "y" ] && $sh_DIR/set_expertansicht.sh
 # reverse phonebook lookup
 [ "$DO_LOOKUP_PATCH" = "y" ] && $sh2_DIR/patch_fc "${SRC}"
 # add MAC settings to internet page
 [ "$ADD_MACSETTING" = "y" ] && $sh_DIR/add_MAC_settings.sh  "${SRC}" "${OEM}"
 # add tcom link
 [ "$DONT_LINK_OENDIRS" != "y" ] && $sh2_DIR/add_tcom_link "${SRC}"
 #add kaid for xbox 
 [ "$ADD_KAID" = "y" ] && $sh2_DIR/add_kaid
 #exchange kernel 
 if [ "$XCHANGE_KERNEL" = "y" ]; then 
 	echo "-- take Speedport kernel for new image"
 	cp -rfv "${SPDIR}/kernel.raw" "${FBDIR}/kernel.raw"
 elif [ "$SRC2_KERNEL" = "y" ]; then
 	echo "-- take kernel from 2nd AVM source for new image"
	cp -rfv "${FBDIR_2}/kernel.raw" "${FBDIR}/kernel.raw"
 #else
 #	echo "-- Take AVM kernel for new image"
 fi
 #remove signature
 [ "$DONT_REM_SIGNATUR" != "y" ] && $sh_DIR/rmv_signatur.sh "${SRC}"
 #remove autoupdate tab
 [ "$DONT_REM_AUTOUPDATETAB" != "y" ] && $sh_DIR/remove_autoupdatetab.sh "${SRC}"
 # patch update pages 
 [ "$DONT_PATCH_TOOLS" != "y" ] && $sh_DIR/patch_tools.sh "${SRC}"
 # update modules dependencies
 [ "$UPDATE_DEPMOD" = y ] && $sh_DIR/update-module-deps.sh "${SRC}" "${KernelVersion}"
 # add info to /usr/bin/system_status
 [ "$DONT_ADD_MODINFO" != "y" ] && $sh2_DIR/patch_system_status "${SRC}"
 #export download links
 $HOMEDIR/extract_rpllist.sh
 # add oem links all, ...
 $sh_DIR/make_oem_links.sh "${SRC}"
 # set OEM via rc.S not via environment
 [ "$PATCH_OEM" = "y" ] && $sh2_DIR/patch_OEMandMyIP "${SRC}"
 # fix default route
 [ "$ADD_DEFAULT_ROUTE_FIX" = "y" ] && $sh_DIR/patch_default_route_fix.sh "${SRC}"
 # replace inittab as it is done with freetz, not executed on 7390, 722
 $sh_DIR/rpl_inittab.sh "${SRC}"
 #packing takes place on SPDIR
 export SPDIR="${FBDIR}"
 #--> Add patches here if this patches shold not be applayed with option restore original!
 # If patches should only be applyed to a special type, then add this patches
 # on the end of individual files like "Speedport920".
 #<-- Add patches here - end!
else
 # --> Only Tcom firmware with otion "restore original"
 readConfig "DSL_MULTI_ANNEX" "DSL_MULTI_ANNEX" "${DST}/etc/init.d"
 readConfig "MULTI_LANGUAGE" "MULTI_LANGUAGE" "${DST}/etc/init.d"
 # get OEM from original Firmware
 readConfig "OEM_DEFAULT" "OEM" "${DST}/etc/init.d"
 [ -d "${DST}/usr/www/avme" ] && export OEM="avme"
 [ -d "${DST}/usr/www/tcom" ] && export OEM="tcom"
 [ -d "${DST}/usr/www/hansenet" ] && export OEM="hansenet"
 for BRANDING in congstar 1und1 ; do 
  if [ -d "${DST}/usr/www/$BRANDING" ]; then
    KEY="x"
    while [ "$KEY" != "y" ]; do
	echo
	echo
	echo -n "  This firmware can be used with diffent brandings. Use '$BRANDING' as brandung (y/n)? "; read -n 1 -s YESNO; echo
	[ "$YESNO" = "y" ] || [ "$YESNO" = "n" ] &&  KEY="y"
        [ "$KEY" = "x" ] && echo "wrong key!"
	[ "$YESNO" = "y" ] && export OEM="$BRANDING"
    done
  fi
 [ "$YESNO" = "y" ] && break
 done
 # adjust Firmware.conf to the correct OEM 
 sed -i -e "s|EXPORT_OEM=.*$|EXPORT_OEM=${OEM}|" $firmwareconf_file_name
 # add addons
 if [ "$COPY_ADDON_TMP_to_ORI" = "y" ]; then
	find ./addon/tmp/squashfs-root/ -type d -name .svn | xargs rm -rf
	find ./addon/tmp/squashfs-root/ | while read file; do
		file="${file##./addon/tmp/squashfs-root/}"
		file="${DST}"/"$file"
		[ -d "$file" ] || rm -f "$file"
	done
 	cp -fdprv  ./addon/tmp/squashfs-root/*  --target-directory="${DST}"
 fi
 #exchange kernel 
 if [ "$XCHANGE_KERNEL" = "y" ] ; then 
 	echo "-- take AVM kernel for new image"
 	cp -rfv "${FBDIR}/kernel.raw" "${SPDIR}/kernel.raw"
 elif [ "$SRC2_KERNEL" = "y" ]; then
 	echo "-- take kernel from 2nd AVM source for new image"
	cp -rfv "${FBDIR_2}/kernel.raw" "${SPDIR}/kernel.raw"
 #else
 #	echo "-- take T-com kernel for new image"
 fi
 echo "Assembling original firmware for transfer via FTP and Webinterface ..."
 echo
 echo "Some changes are made to the original tar file, so it can also be used on"
 echo "Speedports with AVM Web GUI to flash to the selected firmware."
 echo "If the router is rebooting because something went wrong, do the flashing"
 echo "via push ftp again, dont restart the PC to keep your network settings."
 echo "********************************************************************************"
 echo -e "\033[1mPhase 3:\033[0m Apply modell independet  changes"
 echo "********************************************************************************"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 # patch update pages 
 $sh_DIR/patch_tools.sh "${DST}"
 # set OEM via rc.S not via environment
 [ "$PATCH_OEM" = "y" ] && $sh2_DIR/patch_OEMandMyIP "${DST}"
 # Copy stripped Firmware.conf ...
 #FWCT_DIR="$NEWDIR/conf/${SPIMG}_OriginalFirmwareAdjusted${ANNEX}${Language}_Firmware.conf.tar"
 . FirmwareConfArch
 # <-- Only Tcom
fi
#-->All firmwares, if patches added here the are applied to tcom firmware with option "restore original" as well!
#--------------------------------------------------------------------------------------------------------------- 
# add s2f config file
[ "$ADD_S2F_CONF" = "y" ] && subscripts2/add_s2f_configfile "${SRC}" && $TAR xvzf packages/s2f_flash.tgz -C "${SRC}" 2> /dev/null
# patch portrule to enable forwarding to box itself
# add default route
[ "$PATCH_PORTRULE" = "y" ] && $sh2_DIR/patch_portrule "${SRC}"
# add own files 
[ "$ADD_OWN" = "y" ] && $TAR c -C custom/rootfs . 2>/dev/null | $TAR x -C "${SRC}" 2> /dev/null
# add dropbear files 
[ "$ADD_PKG_DROPBEAR" = "y" ] && $TAR xvzf packages/dropbear.tgz -C "${SRC}" 2> /dev/null
# dont set kernel annex args, if it is a multi annex firmware
readConfig "DSL_MULTI_ANNEX" "DSL_MULTI_ANNEX" "${SRC}/etc/init.d"
[ "$DSL_MULTI_ANNEX" == "y" ] && export kernel_args="console=ttyS0,38400"
# w722 - 7390 need this: export kernel_args="console=ttyS0,115200n8r"
# make firmware installable via GUI
$sh_DIR/patch_install.sh "${SPDIR}"
#<--All firmwares
#[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 "${FBDIR}"
echo "********************************************************************************"
echo -e "\033[1mPhase 4:\033[0m Pack and deliver"
echo "********************************************************************************"
# do a final compare
exec 2> /dev/null
[ "$DO_FINAL_DIFF" = "y" ] && ./0diff "${SPDIR}" "${TEMPDIR}" "./logFINALtoAVM"
[ "$DO_FINAL_DIFF_SRC2" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logFINALto3"
if [ -n "$TYPE_SXXX_MODEL" ] || [ "$TYPE_SXXX_MODEL" != "y" ];then
    [ "$DO_FINAL_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${TEMPDIR}"
fi
[ "$DO_FINAL_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR_2}" "${TEMPDIR}"
#[ "$TYPE_SXXX_MODEL" == "y" ] && [ "$DO_FINAL_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${TEMPDIR}"
[ "$DO_NOT_STOP_ON_ERROR" = "n" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}"
# compose filename for new .tar file
[ "7570" == "${TYPE_LABOR_TYPE:0:4}" ] && AVM_SUBVERSION="7570-$AVM_SUBVERSION"
[ "y" == "${TYPE_TCOM_7570_70}" ] && TCOM_SUBVERSION="7570-$TCOM_SUBVERSION"
[ ${FREETZ_REVISION} ] && FREETZ_REVISION="_freetz-${FREETZ_REVISION}"
readConfig "PRODUKT" "PR"  "${SRC}/etc/init.d"
readConfig "MULTI_LANGUAGE" "MULTI_LANGUAGE" "${SRC}/etc/init.d"
Language="_${avm_Lang}"
Pannex="_annex${ANNEX}"
[ "$MULTI_LANGUAGE" == "y" ] && Language="" && Pannex=""
[ "$FORCE_CLEAR_FLASH" == "y" ] && CLEAR="C_" || CLEAR=""
[ "$CLASS" != "" ] && CLASS+="_"
[ "$SPNUM" != "" ] && SPNUM+="_"
[ "$ATA_ONLY" = "y" ] && Pannex="_ATA-ONLY"
X2="${FREETZ_REVISION}_sp2fr-${SVN_REVISION}-${act_firmwareconf_size}_OEM_${OEM}${Pannex}${Language}.image"
[ "$ORI" == "y" ] && export NEWIMG="${SPIMG}_OriginalFirmwareAdjusted${Pannex}${Language}.image"
[ "$ORI" != "y" ] && export NEWIMG="fw_${CLEAR}${CLASS}${SPNUM}${TCOM_VERSION_MAJOR}.${TCOM_VERSION}-${TCOM_SUBVERSION}_${PR}_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}${X2}"
#only AVM + 2nd AVM Firmware was in use
[ "$TYPE_SXXX_MODEL" == "y" ] && export NEWIMG="fw_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}_${PR}_${AVM_2_VERSION_MAJOR}.${AVM_2_VERSION}-${AVM_2_SUBVERSION}${X2}"
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
 $inc_DIR/build_firmware "$SPDIR" "${NEWDIR}" "${NEWIMG}" &
 printprogress
 echo
 . $inc_DIR/testerror
 # build recover
 [ "$BUILDRECOVER" = "y" ] && $HOMEDIR/build_new_recover_firmware
 echo "********************************************************************************"
 if [ "$PUSHCONF" = "y" ]; then
	echo -e "${ECHO_GRUEN}\n\
Don't restart the PC in case the router is or ends up in a reboot loop, \n\
repeat the flashing, or repeat the complete script if it did not work in the \n\
first place. $ECHO_BOLD./ftpXXX 'ENTER'$ECHO_END ${ECHO_GRUEN}restarts the transfer.\n\
There is no need to power of a router that is in a reboot loop even \n\
the script asks you to do this. Nothing is damaged if the router ends up or stays \n\
in a reboot loop, the router is waiting for a firmware on one of the following \n\
FTP IPs 192.168.178.1 or 192.168.2.1. If you have trouble to establish a \n\
connection, add a static IP 192.168.178.2 and \n\
mask 255.255.0.0 gateway IP 192.168.178.1 to your PC network settings.\n\
If a VM machine is in use be sure you did start the VM as administrator.\n\
In case of problems a windows program can also be used to upload a firmware.\n\
Link:  $ECHO_BOLD http://www.hyperbox.org/jpascher/uploader/publish.htm$ECHO_END \n"
	##########################################################################
	echo "********************************************************************************"
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
	echo -e "You may now use it in regular ${ECHO_BOLD}firmware upgrade$ECHO_END process."
	echo "Or:"
	echo -e " Use $ECHO_BOLD./ftpXXX 'ENTER'$ECHO_END to do the upload,"
	echo " no additional settings are needed."
	echo "********************************************************************************"
 fi
else
 echo "No output generated, because this was specified via setup! "
 exit 0
fi
[ "$RUN_PATCH_DECT" == "y" ] && $HOMEDIR/patch_dect.sh
	echo -e "A windows program can also be used to upload a firmware\n\
Link:  $ECHO_BOLD http://www.hyperbox.org/jpascher/uploader/publish.htm$ECHO_END \n\n\
All done .... Press 'ENTER' to return to the calling shell.\n"
while !(read -s); do
    sleep 1
done
exit 0
