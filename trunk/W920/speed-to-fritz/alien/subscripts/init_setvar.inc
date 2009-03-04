#!/bin/bash
#this part is in use on W500, W501, w701, W900
# Speed2fritz -->
export SKRIPT_DATE="03.06.08"
export REMOVE_MENU_ITEM="y"
export REMOVE_HELP="n" #is done by freetz option
export UPDTAM="n"
export ORI="n"
export TR069_TCOM="n"
export FBIMG="$FREETZ_DL_SOURCE"
export SPIMG="$FREETZ_DL_SOURCE2"
#<-- Speed2fritz
export TCOM_FILESYS_DIR="${DIR}/.tk/original/filesystem"
export include_modpatch="${TOOLS_DIR}/freetz_patch"
#------------------------------------------------------------------------------------------------------------------
[ "$FREETZ_TYPE_ANNEX_A" == "y" ] && export ANNEX="A" || export ANNEX="B"
export OEM="avm"
export CONFIG_OEM_DEFAULT="avm"
export OEMLIST="avm avme"
export HOSTNAME="fritz.box"
export SVCPORTAL="none"
export CONFIG_ACCESSORY_URL=""
export CONFIG_SERVICEPORTAL_URL=""
export CONFIG_FIRMWARE_URL="http://www.t-com.de/downloads"
export CONFIG_ATA="y"
export CONFIG_ATA_FULL="n"
export CLASS="Speedport"
#------------------------------
