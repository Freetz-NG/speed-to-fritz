#!/bin/bash
export PATH=$PATH:/sbin
#dont change names of variables because some of the names are used in other files as well!
##########################################################################
# Date of current version:                                          
# TODO: LC_ALL= LANG= LC_TIME= svn info . | awk '/^Last Changed Date: / {print $4}'
Tag="27"; Monat="06"; Jahr="09"
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
#export ANNEX="B"
export CONFIG_BOX_FEEDBACK="n"
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
	[ "$CONFIG_TR064" == "" ] && export CONFIG_TR064="n"
	[ "$CONFIG_TR069" == "" ] && export CONFIG_TR069="n"
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
#export CONFIG_FONBOOK2="n"
#export CONFIG_T38="n"
#export CONFIG_MEDIASRV="n"
#export CONFIG_AURA="n"
#export CONFIG_AUDIO="n"
#export CONFIG_WLAN_TCOM_PRIO="y"
#export CONFIG_MEDIACLI="n"
#export CONFIG_FAXSUPPORT="n"
#export CONFIG_VPN="n"
#export CONFIG_SAMBA="n"
#export CONFIG_JFFS2="n"
#export CONFIG_ONLINEHELP="n"
#export CONFIG_FAX2MAIL="n"
#export CONFIG_FON_HD="n"
#export CONFIG_TAM_MODE="0"
#export CONFIG_IGD="n"
#export CONFIG_UPNP="n"
#export CONFIG_MAILER2="n"
#export CONFIG_ECO="n"
#export CONFIG_USB_WLAN_AUTH="n"
#export CONFIG_CAPI_NT="n"
#export CONFIG_STOREUSRCFG="n"
#export CONFIG_TAM="n"
#export CONFIG_REMOTE_HTTPS="n"
#export CONFIG_REMOTE_HTTPS="n"
#export CONFIG_ACCESSORY_URL="none"
#export CONFIG_TR064="n"
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

	# nees diffent tool
	export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	;;

*)
	export SPMOD="$1"
	export CLASS=""
	export SPNUM=""
	export PROD="$1" 
	export CONFIG_PRODUKT="Fritz_Box_${PROD}"
	[ "$FBMOD" == "" ] && export FBMOD="$1"
	[ "$FBHWRevision" == "" ] && export FBHWRevision="139"
	export HWID="139"
	export HWRevision="${HWID}.1.0.6"
	PROD2="${PROD:0:2}"
	if [ "$PROD2" == "72" ]; then
	    # 72XX firmwares need diffent tool
	    export MKSQUASHFS_TOOL="mksquashfs3-lzma"
	    export MKSQUASHFS_OPTIONS+=" -no-progress -no-exports -no-sparse"
	    export MKSQUASHFS="${TOOLS_DIR}/${MKSQUASHFS_TOOL}"
	fi
	;;
	
#	echo "'$1' is an invalid argument for '-m': Choose '500', '501', '503', '701', '721', '707', '900', '907' or '920'." 
#	sleep 20
#	exit 1
#	;;
esac

return 0
}
# get commandline options to variables
. $inc_DIR/processcomline
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
# do a compare of TCOM and AVM
[ "$DO_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR}"
# do a compare of source 1 (TCOM) , 2 (AVM) and 3
[ "$DO_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR_2}" "${FBDIR}"
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
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 .
#[ ${FAKEROOT_ON} = "y" ] && $FAKEROOT chmod -R 755 .
echo "********************************************************************************"
echo -e "\033[1mPhase 3:\033[0m Copy sources."
echo "********************************************************************************"
 echo "${SPMOD}/////////////////////////////////////////////////////////////////////////////"
# Flashing original firmware image ...
if [ "$ORI" != "y" ]; then
 #international language - fix patches in advance 
 for FILE in `ls $P_DIR`  ; do
    [ "$OEMLINK" == "avme" ] && sed -i -e "s|/avm/|/$OEMLINK/|" $P_DIR/$FILE 
    [ "$OEMLINK" == "avm" ] && sed -i -e "s|/avme/|/$OEMLINK/|" $P_DIR/$FILE 
 done
 #prepare for use of Freetz Firmware 
 [ "$MOVE_ALL_to_OEM" = "y" ] && $sh_DIR/move_all_to_OEM.sh "${SRC}" || $sh_DIR/remake_link_avm.sh "${SRC}"
 # Please dont add conditions on models in any external file
 #enable ext2
 [ "$ENABLE_EXT2" = "y" ] && $sh2_DIR/patch_ext2 "${SRC}" "${DST}"
 case "$SPMOD" in
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
 *)
 . SxxxAVM;;
 esac
  #bug in home.js, courses mailfunction with tcom firmware, status page is emty  
 $sh_DIR/fix_homebug.sh
  #add missing files for tr064
 [ "$CONFIG_TR064" = "y" ] && $sh_DIR/copy_tr064_files.sh
 #remove help 
 [ "$REMOVE_HELP" = "y" ] && $sh_DIR/rmv_help.sh "${SRC}"
 #Add modinfo
 $sh_DIR/add_modinfobutton.sh "${SRC}"
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
 #patch p_maxTimeout on Intenetpage
 [ "$SET_PMAXTIMEOUT" = "y" ] && $sh_DIR/patch_pmaxTimeout.sh "${SRC}" "${OEMLIST}"
 #patch download url and add menuitem support
 [ "$ADD_SUPPORT" = "y" ] && $sh2_DIR/patch_url "${SRC}" "${OEMLIST}"
 #add dsl expert pages support
 [ "$ADD_DSL_EXPERT_MNUE" = "y" ] && $sh_DIR/add_dsl_expert.sh "${SRC}" "${OEMLIST}"
 #add omlinecounter pages 
 [ "$ADD_ONLINECOUNTER" = "y" ] && $sh_DIR/add_onlinecounter.sh "${SRC}" "${OEMLIST}"
 #relpace assistent menuitem with enhenced settings 
 [ "$RPL_ASSIST" = "y" ] && $sh2_DIR/rpl_ass_menuitem "${SRC}" "${OEMLIST}" 
 #tam bugfix remove tams    
 $sh_DIR/patch_tam.sh "${SRC}"
 #gsm page    
 [ "$DO_GSM_PATCH" = "y" ] && $sh_DIR/disply_gsm.sh "${SRC}" "${OEMLIST}"
 #enable all providers
 [ "$SET_ALLPROVIDERS" = "y" ] && $sh_DIR/set_allproviders.sh
 #set expert Ansicht    
 [ "$SET_EXPERT" = "y" ] && $sh_DIR/set_expertansicht.sh
 # reverse phonebook lookup
 [ "$DO_LOOKUP_PATCH" = "y" ] && $sh2_DIR/patch_fc "${SRC}"
 # remove tcom and some other oem dirs and add link instead to enable other brands.
 $sh2_DIR/add_tcom_link "${SRC}"
 #add kaid for xbox 
 [ "$ADD_KAID" = "y" ] && $sh2_DIR/add_kaid
 #exchange kernel 
 if [ "$XCHANGE_KERNEL" = "y" ]; then 
 	echo "-- Take Speedport kernel for new image"
 	cp -rfv "${SPDIR}/kernel.raw" "${FBDIR}/kernel.raw"
 elif [ "$SRC2_KERNEL" = "y" ]; then
 	echo "-- Take kernel from source 3 for new image"
	cp -rfv "${FBDIR_2}/kernel.raw" "${FBDIR}/kernel.raw"
 else
 	echo "-- Take Source 2 kernel for new image"
 fi
 #remove signature
 $sh_DIR/rmv_signatur.sh "${SRC}"
 #remove autoupdate tab
 $sh_DIR/remove_autoupdatetab.sh "${SRC}"
 # patch update pages 
 $sh_DIR/patch_tools.sh "${SRC}"
 # update modules dependencies
 [ "$UPDATE_DEPMOD" = y ] && $sh_DIR/update-module-deps.sh "${SRC}" "${KernelVersion}"
 #export download links
 $HOMEDIR/extract_rpllist.sh	
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
fi
#dont set kernel annex args, if it is a multi annex firmware
#make firmware insallable via GUI
readConfig "DSL_MULTI_ANNEX" "DSL_MULTI_ANNEX" "${SRC}/etc/init.d"
[ "$DSL_MULTI_ANNEX" == "y" ] && export kernel_args="console=ttyS0,38400"
$sh_DIR/patch_install.sh "${SPDIR}"
. $inc_DIR/testerror
[ ${FAKEROOT_ON} = "n" ] && chmod -R 777 "${FBDIR}"
echo "********************************************************************************"
echo -e "\033[1mPhase 10:\033[0m Pack and deliver."
echo "********************************************************************************"
#do a final compare
[ "$DO_FINAL_DIFF" = "y" ] && ./0diff "${SPDIR}" "${TEMPDIR}" "./logFINALtoAVM"
[ "$DO_FINAL_DIFF_SRC2" = "y" ] && ./0diff "${SPDIR}" "${FBDIR_2}" "./logFINALto3"
[ "$DO_FINAL_KDIFF3_2" = "y" ] && kdiff3 "${SPDIR}" "${TEMPDIR}"
[ "$DO_FINAL_KDIFF3_3" = "y" ] && kdiff3 "${SPDIR}" "${FBDIR_2}" "${TEMPDIR}"
[ "$DO_STOP_ON_ERROR" = "y" ] && exec 2>"${HOMEDIR}/${ERR_LOGFILE}"
# compose Filename for new .tar ended File
if SVN_VERSION="$(svnversion . | tr ":" "_")"; then
 [ "${SVN_VERSION:0:6}" == "export" ] && SVN_VERSION=""
 [ "$SVN_VERSION" != "" ] && SVN_VERSION="-r-$SVN_VERSION"
 SKRIPT_DATE+="$SVN_VERSION"
fi
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
[ "$ORI" != "y" ] && export NEWIMG="fw_${CLEAR}${CLASS}_W${SPNUM}V_${TCOM_VERSION_MAJOR}.${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}_OEM-${OEM}${PANNEX}${Language}.image"
[ "$ORI" == "y" ] && export NEWIMG="${SPIMG}_OriginalTcomAdjusted${PANNEX}${Language}.image"
[ "$ATA_ONLY" = "y" ] && export NEWIMG="fw_${CLEAR}${CLASS}_W${SPNUM}V_${TCOM_VERSION_MAJOR}.${TCOM_VERSION}-${TCOM_SUBVERSION}_${CONFIG_PRODUKT}_${AVM_VERSION_MAJOR}.${AVM_VERSION}-${AVM_SUBVERSION}${FREETZ_REVISION}-sp2fr-${SKRIPT_DATE_ISO}${SVN_VERSION}_OEM-${OEM}_ATA-ONLY${Language}.image"
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
 fw_pack "$SPDIR" "${NEWDIR}" "${NEWIMG}"
 . $inc_DIR/testerror
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
echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0
