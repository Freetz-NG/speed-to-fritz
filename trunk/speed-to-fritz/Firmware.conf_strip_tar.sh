#!/bin/bash
. incl_var
Firmware_conf_tar="${NEWIMG}_Firmware.conf.tar"
. FirmwareConfStrip
[ -f $firmwareconf_file_name ] && tar --owner=0 --group=0 --mode=0755 -cf "$Firmware_conf_tar" "$firmwareconf_file_name"
[ -f $Firmware_conf_tar ] && echo " -- craeted: $Firmware_conf_tar"
[ -f "${NEWDIR}/$Firmware_conf_tar" ] && echo "moved $Firmware_conf_tar to $NEWDIR"
SP_NUM="W${SPNUM}"
[ "$CLASS" == "Speedport" ] && SP_NUM="W${SPNUM}"
DSLTYPE="/ADSL"
grep -q 'FORCE_VDSL=y' "$firmwareconf_file_name" && DSLTYPE="/VDSL"
AVM_SUBVERSION_DIR="$AVM_SUBVERSION"
[ "$AVM_SUBVERSION" == "" ] && AVM_SUBVERSION_DIR=${AVM_VERSION}
CONFDIR="./conf/${SP_NUM}$DSLTYPE/${AVM_SUBVERSION_DIR}/ANNEX_${ANNEX}"
mkdir -p "${CONFDIR}"
cp -f "$firmwareconf_file_name" --target-directory="${CONFDIR}"
mv -f "$Firmware_conf_tar" --target-directory="$NEWDIR"
[ -f "${CONFDIR}/$firmwareconf_file_name" ] && echo "-- copyed $firmwareconf_file_name to $CONFDIR"

sleep 10