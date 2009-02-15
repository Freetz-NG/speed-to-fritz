#!/bin/bash
export PATH=$PATH:/sbin
#dont change names of variables because some of the names are used in other files as well!
##########################################################################
# Date of current version:                                          
Tag="15"; Monat="02"; Jahr="09"
export SKRIPT_DATE="$Tag.$Monat.$Jahr"
export SKRIPT_DATE_ISO="$Jahr.$Monat.$Tag"
export SKRIPT_REVISION="$Jahr$Monat$Tag"
export MODVER="${SKRIPT_DATE}-de/en-annexA/B"
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
export FREETZ_REVISION=""
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
FAKEROOT_TOOL="fakeroot"
export FAKEROOT="${TOOLS_DIR}/usr/bin/${FAKEROOT_TOOL}"
sed -i -e "s|^PREFIX=.*$|PREFIX=${TOOLS_DIR}/usr|g" ${FAKEROOT}
sed -i -e "s|^BINDIR=.*$|BINDIR=${TOOLS_DIR}/usr/bin|g" ${FAKEROOT}
sed -i -e "s|^PATHS=.*$|PATHS=${TOOLS_DIR}/usr/lib|g" ${FAKEROOT}
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
export TEMPDIR="${HOMEDIR}/tmp"
export SPDIR="${HOMEDIR}/SPDIR"
export FBDIR="${HOMEDIR}/FBDIR"
export SRC="${FBDIR}/$SQUASHFSROOT"
export DST="${SPDIR}/$SQUASHFSROOT"
export FBDIR_2="${HOMEDIR}/FBDIR2"
export SRC_2="${FBDIR_2}/$SQUASHFSROOT"
# Set default values for output directory 
export	FWNEWDIR="Firmware.new"
# Set default values for use within this script if no options are given via commandline 
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
# It is a bit wirred how the information is carried on to the resulting image,
# usually this information is overwritten by other settings made later on.
# If patch_config_rc.conf is used, the settings from the original rc.init will be used
# but some are set again depending on settings made in 
# ./xxx.init (xxx is the configtype ig. 907) ./xxx.init is called from patch_config_rc.conf  
# Some variabels are rewritten in patch_config_rc.conf from globals to rc.conf
# see patch_config_rc_conf for more details
# At the moment i don't know what variables are really in use by AVM Firmware
# This is just an approach to keep as much information as possible, to be on the safe side    
export USBH="n"
export ATA="y"
export CONFIG_ATA="${ATA}"
export CONFIG_ATA_FULL="n"
export ANNEX="B"
export CONFIG_LED_NO_DSL_LED="n"
export CONFIG_DECT_ONOFF="n"
export CONFIG_VOL_COUNTER="y"
export CONFIG_TR064=""
export CONFIG_TR069=""
export CONFIG_IsdnNT="0" 
export CONFIG_IsdnTE="0" 
export CONFIG_Usb="0" 
export CONFIG_Pots="0"
export CONFIG_UsbHost="0" 
export CONFIG_UsbStorage="0"
export CONFIG_UsbWlan="0"
export CONFIG_UsbPrint="0"
export CONFIG_Debug="0"
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
#                   "920" (for SP W920V)                            
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
export FILENAME_SPIMG_PATH="$(get_item "$TCOM_IMG" "1")" 
export MIRROR_SPIMG_PATH="$(get_item "$TCOM_IMG" "2")"
export SPIMG_PATH="$(get_item "$TCOM_IMG" "0")"
export SPIMG="$(echo $SPIMG_PATH | sed -e "s/.*\///")"
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
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="101"
	export PROD="DECT_W500V"
    	export CONFIG_PRODUKT="Fritz_Box_$PROD"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_8MB_xilinx_1eth_0ab_pots_wlan_dect_35998"
	export CONFIG_XILINX="y"
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
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	[ "$CONFIG_TR064" == "" ] && export CONFIG_TR064="n"
	[ "$CONFIG_TR069" == "" ] && export CONFIG_TR069="n"
	[ "$HOSTNAME" == "" ] && export HOSTNAME="fritz.box"
	[ "$NEWNAME" == "" ] && export NEWNAME="FRITZ!Box Fon WLAN Sinus W 500V"
	;;
"501")
	export HWID="93"
	export SPNUM="501"
	- Annex B = HWR 106
#	export FBMOD="7140"
#	export FBHWRevision="107"
	[ "$FBMOD" == "" ] && export FBMOD="7170"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="94"
	export HWID="101"
	export CLASS="Speedport"
	export PROD="SpeedportW501V"
    	export CONFIG_PRODUKT="Fritz_Box_$PROD"
	export NEWNAME="FRITZ!Box Fon WLAN ${CLASS} W ${SPNUM}V"
	export HWRevision="${HWID}.1.1.0"
	export CONFIG_INSTALL_TYPE="ar7_4MB_1eth_2ab_pots_wlan_28776"
	export CONFIG_XILINX="y"
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
	  export CONFIG_Pots="0"
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_DSL="n"
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
	  export CONFIG_DSL="n"
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
	export CONFIG_IsdnNT="1"
	export CONFIG_Pots="1"
	export kernel_size="7798784"
#aditional not in use on W701 but on 7170	
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
#	export CONFIG_VLYNQ="y"
#	export CONFIG_VLYNQ0="0"
#	export CONFIG_VLYNQ1="0"
#	export CONFIG_VLYNQ_PARAMS=""
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
	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
    ;;
    
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
	  export CONFIG_DSL="n"
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
	  export CONFIG_DSL="n"
	  export CONFIG_DSL_MULTI_ANNEX="n"
	  export CONFIG_VDSL="n"
	  export CONFIG_LABOR_DSL="n"
	fi 
	export kernel_size="7798784"
	;;
"920") 
	export SPMOD="920"
	export CLASS="Speedport"
	export SPNUM="920"
	export PROD="DECT_W920V" 
    	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="7270"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="135"
	export HWRevision="${HWID}.1.0.6"
	#export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_mimo_usb_host_dect_40456"
	export CONFIG_INSTALL_TYPE="ur8_16MB_xilinx_4eth_2ab_isdn_nt_te_pots_wlan_mimo_usb_host_dect_multiannex_13589"
	export CONFIG_XILINX="y"
	export CONFIG_jffs2_size="132"
	export CONFIG_RAMSIZE="64"
	export CONFIG_ROMSIZE="16"
	export CONFIG_DIAGNOSE_LEVEL="1"
	#----dsl menu selection
	export CONFIG_ATA_FULL="n"
	export CONFIG_DSL_UR8="n"
	export CONFIG_DSL="y"
	export CONFIG_DSL_MULTI_ANNEX="y"
	export CONFIG_MULTI_LANGUAGE="y"
	export CONFIG_LABOR_DSL="y"
	export CONFIG_VDSL="y"
	export CONFIG_VINAX="y"
	export CONFIG_VINAX_TRACE="y"
	#export CONFIG_VINAX_TRACE="n"
	export CONFIG_LIBZ="y"
	#export CONFIG_LIBZ="n"
	export CONFIG_VOL_COUNTER="y"
	#export CONFIG_VOL_COUNTER="n"

#	export CONFIG_VLYNQ_PARAMS="vlynq_reset_bit_0"
#	export CONFIG_VLYNQ="n"
#	export CONFIG_VLYNQ0="3"
#	export CONFIG_VLYNQ1="0"
	if [ "$ATA_ONLY" = "y" ]; then
	  export CONFIG_ATA="n"  
	  export CONFIG_ATA_FULL="y"
	  export CONFIG_DSL="n"
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
	export kernel_size="16121856"
	# nees diffent tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;
	
*)

	echo "'$1' is an invalid argument for '-m': Choose '500', '501', '503', '701', '721', '707', '900', '907' or '920'." 
	sleep 20
	exit 1
	;;
esac

return 0
}
# get commandline options to variables
. $inc_DIR/processcomline
# menuconfig uses .config as Firmwareconfigfile and export must be adjusted
sed -i -e 's|EXPORT_|export |' $HOMEDIR/${firmwareconf_file_name}
. $inc_DIR/includefunctions
echo "Firmware configuration taken from: ${firmwareconf_file_name}"
. ${firmwareconf_file_name}
# restore optionname
sed -i -e 's|export |EXPORT_|' $HOMEDIR/${firmwareconf_file_name}
[ "$ANNEX" != "B" ] && [ "$ANNEX" != "A" ] && echo "Commandline annex parameter -x is: '$ANNEX' but must be 'A' or 'B'" && exit 0  
kernel_args="annex=${ANNEX}" 
export kernel_args="${kernel_args} idle=4"
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
#START
# delete privias Firmware of 11500 if needed
  $sh2_DIR/del_zip "${AVM_DSL_11500}" "${AVM7270_DSL_11500}" "13014" 
# delete privias Firmware of 13014 if needed
  $sh2_DIR/del_zip "${AVM_AIO_13014}" "${AVM7270_AIO_13014}" "13014" 
# extract source
. $inc_DIR/get_workingbase
# create backup for final compare
[ "$DO_FINAL_DIFF" = "y" ] && mkdir -p "${TEMPDIR}"
[ "$DO_FINAL_DIFF" = "y" ] && cp -fdpr "${FBDIR}"/*  --target-directory="${TEMPDIR}"  
# do a compare of source 1 and 2
[ "$DO_DIFF" = "y" ] && ./0diff "${FBDIR}" "${FBDIR_2}" "./logAVMto3"
# do a compare of tcom source 1 and 2
[ "$DO_DIFF_TCOM" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logTCOMto3"
#
[ "$DO_NOT_STOP_ON_ERROR" = "n" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}" || rm -f "${HOMEDIR}/${ERR_LOGFILE}"
# get version from etc/.version into variables
. $inc_DIR/getversion
# get produkt from etc/default.F* into variables FBMOD, CONFIG_PRODUKT and CONFIG_SORCE
. $inc_DIR/getprodukt
# compose Filename for new .tar ended File
if SVN_VERSION="$(svnversion . | tr ":" "_")"; then
 [ "${SVN_VERSION:0:6}" == "export" ] && SVN_VERSION=""
 [ "$SVN_VERSION" != "" ] && SVN_VERSION="-r-$SVN_VERSION"
 SKRIPT_DATE+="$SVN_VERSION"
fi
[ ${FREETZ_REVISION} ] && FREETZ_REVISION="-freetz-${FREETZ_REVISION}"
[ "$ORI" != "y" ] && export NEWIMG="fw_${CLASS}_W${SPNUM}V_${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}_OEM-${OEM}_Annex${ANNEX}_${avm_Lang}.image"
[ "$ORI" = "y" ] && export NEWIMG="${SPIMG}_OriginalTcomAdjustedForAnnex${ANNEX}_${avm_Lang}.image"
[ "$ATA_ONLY" = "y" ] && export NEWIMG="fw_${CLASS}_W${SPNUM}V_${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}_OEM-${OEM}_ATA-ONLY_${avm_Lang}.image"
# print some info on screen
. $inc_DIR/print_settings
# save some variabels to incl_var
. $sh2_DIR/settings
#print some Hardware setting found in the two firmwares in use
$sh2_DIR/dedect_HW
# make sure all is set to correct rights
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 .
#[ ${FAKEROOT_ON} = "y" ] && $FAKEROOT chmod -R 755 .
echo "********************************************************************************"
echo -e "\033[1mPhase 3:\033[0m Copy sources."
echo "********************************************************************************"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
# Flashing original firmware image ...                               
if [ "$ORI" != "y" ]; then
 #prepare for use of Freetz 7170 Firmware 
 [ "$MOVE_ALL_to_OEM" = "y" ] && $sh_DIR/move_all_to_OEM.sh "${SRC}" || $sh_DIR/remake_link_avm.sh "${SRC}"
 # Please dont add conditions on models in any external file
 #enable ext2
 [ "$ENABLE_EXT2" = "y" ] && $sh2_DIR/patch_ext2 "${SRC}" "${DST}"
 if [ "$SPMOD" = "920" ]; then
 . Speedport920
 fi
 if [ "$SPMOD" = "907" ]; then
 . Speedport907
 fi
 if [ "$SPMOD" = "707" ]; then
 . Speedport707
 fi
 if [ "$SPMOD" = "721" ]; then
 . Speedport721
 fi
 if [ "$SPMOD" = "500" ]; then
 . Speedport500
 fi
 if [ "$SPMOD" = "501" ]; then
 . Speedport501
 fi
 if [ "$SPMOD" = "503" ]; then
 . Speedport503
 fi
 #remove help 
 [ "$REMOVE_HELP" = "y" ] && $sh_DIR/rmv_help.sh "${SRC}"
 #Add modinfo
 $sh_DIR/add_modinfobutton.sh "${SRC}"
 #relace banner
 [ $COPY_HEADER = "y" ] && $sh_DIR/rpl_header.sh "${SRC}"
 #add addons
 [ "$COPY_ADDON_TMP" = "y" ] &&  cp -fdpr  ./addon/tmp/squashfs-root/*  --target-directory="${SRC}"
 #patch download url and add menuitem support
 [ "$ADD_SUPPORT" = "y" ] && $sh2_DIR/patch_url "${SRC}" "${OEMLIST}"
 #add dsl expert pages support
 [ "$ADD_DSL_EXPERT_MNUE" = "y" ] && $sh_DIR/add_dsl_expert.sh "${SRC}" "${OEMLIST}"
 #add omlinecounter pages 
 [ "$ADD_ONLINECOUNTER" = "y" ] && $sh_DIR/add_onlinecounter.sh "${SRC}" "${OEMLIST}"
 #relpace assistent menuitem with enhenced settings 
 [ "$RPL_ASSIST" = "y" ] && $sh2_DIR/rpl_ass_menuitem "${SRC}" "${OEMLIST}" 
 #patch DSL bug of 11500
 ([ "$TYPE_DSL_11500" = "y" ] || [ "$AVM_IMG" = "$AVM_DSL_11500" ]) &&  $sh2_DIR/fix_DSLlab "${SRC}" "${OEMLIST}" 
 #patch ut-8 bug of 11945
 ([ "$BUGFIX_FONCONFIG" = "y" ] || [ "$TYPE_DSL_11945" = "y" ] || [ "$AVM_IMG" = "$AVM_AIO_11945" ]) &&  $sh_DIR/conv_iso8859.sh "${SRC}" "${OEMLIST}" 
 #tam bugfix remove tams    
 $sh_DIR/patch_tam.sh "${SRC}"
 ##gsm    
 [ "$DO_GSM_PATCH" = "y" ] && $sh_DIR/disply_gsm.sh "${SRC}" "${OEMLIST}"
 # reverse phonebook lookup
 [ "$DO_LOOKUP_PATCH" = "y" ] && $sh2_DIR/patch_fc "${SRC}"
 # remove tcom and some other oem dirs and add link instead to enable other brands.
 $sh2_DIR/add_tcom_link "${SRC}"
 #add kaid for xbox 
 [ "$ADD_KAID" = "y" ] && $sh2_DIR/add_kaid
 #exchange kernel 
 [ "$XCHANGE_KERNEL" = "y" ] && cp -rfv "${SPDIR}/kernel.raw" "${FBDIR}/kernel.raw"
  #remove signature
 $sh_DIR/rmv_signatur.sh "${SRC}"
 $sh_DIR/remove_autoupdatetab.sh "${SRC}"
 # patch update pages 
 $sh_DIR/patch_tools.sh "${SRC}"	
 #packing takes place on SPDIR
 export SPDIR="${FBDIR}"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
 echo "********************************************************************************"
 echo -e "\033[1mPhase 9:\033[0m Patch install."
 echo "********************************************************************************"
else
 #add addons
 export OEM="tcom"
 [ "$COPY_ADDON_TMP_to_ORI" = "y" ] &&  cp -fdpr  ./addon/tmp/squashfs-root/*  --target-directory="${DST}"
 #exchange kernel 
 [ "$XCHANGE_KERNEL" = "y" ] && cp -rfv "${FBDIR}/kernel.raw" "${SPDIR}/kernel.raw"
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
fi
$sh_DIR/patch_install.sh "${SPDIR}"
if [ "$VERBOSE" = "-v" ]; then
echo "Ready for packing... Press 'ENTER' to continue..."
 while !(read -s);do
    sleep 1
 done
fi
. $inc_DIR/testerror
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 "${FBDIR}"
echo "********************************************************************************"
echo -e "\033[1mPhase 10:\033[0m Pack and deliver."
echo "********************************************************************************"
#do a final compare
[ "$DO_FINAL_DIFF" = "y" ] && ./0diff "${SPDIR}" "${TEMPDIR}" "./logFINALtoAVM"
[ "$DO_FINAL_DIFF_SRC2" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logFINALto3"
[ "$DO_STOP_ON_ERROR" = "y" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}"
if [ "$SET_UP" = "n" ]; then
 #wrap all up again
 fw_pack "$SPDIR" "${NEWDIR}" "${NEWIMG}"
 . $inc_DIR/testerror
	echo "********************************************************************************"
	echo
	echo "New firmware image completed successfully!"
	echo "You may now use it in regular firmware upgrade process."
	echo "Use at your own risk!!!"
	echo
	echo "      kernel.image - and " 
	echo "      ${NEWIMG}"
	echo "are now in output directory:"
	echo "      ${NEWDIR}"
	echo
	echo "********************************************************************************"
 if [ "$PUSHCONF" = "y" ]; then
	echo "Flashing firmware image $NEWDIR/kernel.image..."
	echo "********************************************************************************"
	echo
 	#FTP kann nicht mit zwei Parametern von quote uebergeben,  ${kernel_args} verursacht Fehlermeldung	
	pushconfig "${NEWDIR}" "${OEM}" "${CONFIG_PRODUKT}" "${HWRevision}" "${ETH_IF}" "${IPADDRESS}" "${CONFIG_jffs2_size}" "annex=${ANNEX}" "${ANNEX}"
#	pushconfig "${NEWDIR}" "${OEM}" "${CONFIG_PRODUKT}" "${HWRevision}" "${ETH_IF}" "${IPADDRESS}" "${CONFIG_jffs2_size}" "console=ttyS0,38400" "${ANNEX}"
	echo
	echo "Finished transfering kernel.image to Speedport. Enjoy!"
	echo
	echo "********************************************************************************"
 else
	echo "********************************************************************************"
	echo
	echo " Continue with upload of new kernel.image to speedport via ftp ..."
	echo " 1. Login to 192.168.178.1 as adam2 (pw adam2)"
	echo " 2. Issue commands:   bin, passiv, quote MEDIA FLSH"
	echo " 3. Transfer file:    put kernel.image mtd1"
	echo " 4. Change branding:  quote SETENV firmware_version ${OEM}"
	echo " 5. Change branding:  quote SETENV kernel_args annex=${ANNEX}"
	echo " 6. Reboot speedport: quote REBOOT"
	echo " 7. Exit ftp:         quit "
	echo
	echo " You can use ./ftpXXX 'ENTER' to do the above, if you have a functional "
	echo " netconnection on this LINUX System to your Speedport, no additional settings are needed."
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
