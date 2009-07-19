#!/bin/bash
#########################################################################################################################
# Speedport W900V, Sinus W500, requires AVM's Fritz!Fon 7150 dect firmware 
#########################################################################################################################
### Keep this line, because some files are needed from this firmware in every case.
#IMG="ftp://ftp.avm.de/fritz.box/fritzfon.7150/dect-firmware/fritz.fon_7150.annexb.dect_update-vbf003212-26.image" 
IMG="ftp://ftp.avm.de/fritz.box/fritzfon.7150/dect-firmware/FRITZ.Fon_7150.AnnexB.dect_update-vbf003212-26-A.image"
### There is also a new DECT firmware included with Sinus W500V firmware, if you want to use this, uncomment the line startimg with IMG2.
IMG2="http://hilfe.telekom.de/dlp/eki/downloads/Sinus%20W%20500%20V/fw_SinusW500V_27_04_27.zip ./Firmware.orig/dect_update-SinusW500V-vbf001589.image"
# 
# 
export HOMEDIR="`pwd`"
export P_DIR="$HOMEDIR/alien/patches"
export inc_DIR="$HOMEDIR/includes"
. $inc_DIR/includefunctions

TOOLS_SUBDIR="tools"
export TOOLS_DIR="${HOMEDIR}/${TOOLS_SUBDIR}"
export include_modpatch="${TOOLS_DIR}/freetz_patch"
export FWORIGDIR="Firmware.orig"
export FWBASE="$HOMEDIR/Firmware.orig"
export FWNEWDIR="Firmware.new"
export DECTDIR="${HOMEDIR}/DECT"
export DECTIMG_PATH="$(get_item "$IMG" "0")"
export DECTIMG="$(echo $DECTIMG_PATH | sed -e "s/.*\///")"
export DECTDIR2="${HOMEDIR}/DECT2"
export DECTIMG_PATH2="$(get_item "$IMG2" "0")"
export DECTIMG2="$(echo $DECTIMG_PATH2 | sed -e "s/.*\///")"
export FILENAME_DECTIMG_PATH="$(get_item "$IMG" "1")"
export MIRROR_DECTIMG_PATH="$(get_item "$IMG" "2")"
export FILENAME_DECTIMG2_PATH="$(get_item "$IMG2" "1")"
export MIRROR_DECTIMG2_PATH="$(get_item "$IMG2" "2")"
export VERBOSE=""


export firmwareconf_file_name="$0"
#START
echo
echo
echo
echo "------------------------------------------------------------------------------------------------------------------------------"
echo "Patch for DECT update"
echo "------------------------------------------------------------------------------------------------------------------------------"
# extract source
[ ! -d "$FWBASE" ] && mkdir "$FWBASE"
# Create output directory if neccessary.
[ ! -d "$FWNEWDIR" ] && mkdir --mode=777 "$FWNEWDIR"
export NEWDIR="$(readlink -f "$FWNEWDIR")"
if [ ! -d "$NEWDIR" ]; then
	echo "Unable to locate/create directory: $NEWDIR"
	sleep 20; exit 1
fi
# Removing privias sources if still in existant
rm -fdr ${DECTDIR}
# Create temporary directories 
mkdir  ${DECTDIR}
if [ ! -d "$DECTDIR" ]; then
	echo "Could not create temporary directory: $DECTDIR"
	sleep 20; exit 1
fi
echo "Looking for DECT update firmware file '$DECTIMG'."

# Check if images/directories exist or download file
#get tcom source
fwselect "$DECTIMG_PATH" "$FWBASE" "IMG" "DECTIMG" "$MIRROR_DECTIMG_PATH" "$FILENAME_DECTIMG_PATH"
if [ -z "$DECTIMG" ]; then
	echo "No image for processing. Exit"
	sleep 20; exit 1
fi
# extract pseudo update 
tar -xf "$FWBASE/$DECTIMG" -C "$DECTDIR" .
if [ "$IMG2" ]; then
 echo "Looking for DECT update firmware file '$DECTIMG2'."
 # Check if images/directories exist or download file
 #get tcom source
 fwselect "$DECTIMG_PATH2" "$FWBASE" "IMG2" "DECTIMG2" "$MIRROR_DECTIMG2_PATH" "$FILENAME_DECTIMG2_PATH"
 if [ -z "$DECTIMG2" ]; then
	echo "No image for processing. Exit"
	sleep 20; exit 1
 fi
 # Removing privias sources if still exist
 rm -fdr ${DECTDIR2}
 # Create temporary directories 
 mkdir  ${DECTDIR2}
 if [ ! -d "$DECTDIR2" ]; then
	echo "Could not create temporary directory: $DECTDIR2"
	sleep 20; exit 1
 fi
 # copy bin file from fimware two to firmwar one
 tar -xf "$FWBASE/$DECTIMG2" -C "$DECTDIR2" .
 #rm -v  "$DECTDIR"/var/dect_firmware.bin
 cp -fv "$DECTDIR2"/var/dect_firmware.bin "$DECTDIR"/var/dect_firmware.bin 
fi
exec 2>"${HOMEDIR}/error0"
#cp -dprv ./addon/tmp/dectupdate/install    --target-directory="$DECTDIR"/var
rm -f "$DECTDIR"/var/install
VERBOSE="-v"
# include modpatch function
. ${include_modpatch}
modpatch "${DECTDIR}" "${P_DIR}/add_dectupdate-install.patch"
rm -v "$DECTDIR"/var/info.txt
 
tar -cf "$NEWDIR/dect-update.image" --owner=0 --group=0 --mode=0755 -C "$DECTDIR" ./var

# Check if an error has occured (Size of logfile > 0)                   
if [ -s "${HOMEDIR}/error0" ]; then
	echo "********************************************************************************" >>"${HOMEDIR}/error0"
	echo "ERROR OCCURED !!! - Push 'Q' to get back." >>"${HOMEDIR}/error0"
	echo "********************************************************************************" >>"${HOMEDIR}/error0"
    cat "${HOMEDIR}/error0" | less
exit 0
fi 

	echo "********************************************************************************"
	echo
	echo "New DECT update firmware image completed successfully!"
	echo "You may now use it in regular firmware upgrade process."
	echo "Use at your own risk!!!"
	echo
	echo "dect-update.image" 
	echo     
	echo "is now in output directory:"
	echo "      $NEWDIR"
	echo
	echo "********************************************************************************"



echo "All done .... Press 'ENTER' to return to the calling shell."
while !(read -s); do
    sleep 1
done
exit 0
