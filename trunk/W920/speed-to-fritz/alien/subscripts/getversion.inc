#!/bin/bash
#########################################################################
# Check version of AVM firmware source 
# only in use with freetz
#########################################################################
echo2 "Verifying version of TCOM and AVM firmware images ..."
export TCOM_VERSION=`cat ${TCOM_FILESYS_DIR}/etc/.version`
export TCOM_V_MINOR=${TCOM_VERSION##*.}
export TCOM_SUBVERSION=`cat ${TCOM_FILESYS_DIR}/etc/.subversion`
export TCOM_SUBVERSION=`echo ${TCOM_SUBVERSION##*-} | tr -d '[:alpha:]'`
[ "$TCOM_SUBVERSION" = "" ] &&  export TCOM_SUBVERSION="0"
echo2 "-- TCOM firmware image version is: $TCOM_VERSION-$TCOM_SUBVERSION"

export AVM_VERSION=`cat ${FILESYSTEM_DIR}/etc/.version`
export AVM_V_MINOR=${AVM_VERSION##*.}
export AVM_SUBVERSION=`cat ${FILESYSTEM_DIR}/etc/.subversion`
export AVM_SUBVERSION=`echo ${AVM_SUBVERSION##*-} | tr -d '[:alpha:]'`
[ "$AVM_SUBVERSION" = "" ] && export AVM_SUBVERSION="0"
echo2 "-- AVM  firmware image version is: $AVM_VERSION-$AVM_SUBVERSION"

# wird von install gegbraucht
export SP_Vesioninfo="# Versioninfo:	33.$TCOM_VERSION"
export SP_Checkpoint="# Checkpoint:	r0000"
export SP_kernel_size="kernel_size=${kernel_size}"

[ -n "$SP_Vesioninfo" ] && echo2 "-- TCOM  $SP_Vesioninfo"
[ -n "$SP_Checkpoint" ] && echo2 "-- TCOM  $SP_Checkpoint"

## Für Language den Default der Firmware auflösen
## (es wird immer die Sprache der FW genommen)

#if [ "$FREETZ_TYPE_LANG_EN" == "y" ]; then

Language=`grep language ${TCOM_FILESYS_DIR}/etc/default.language`
export tcom_Lang=`echo ${Language##language} | tr -d ' '`
Language=`grep language ${FILESYSTEM_DIR}/etc/default.language`
export avm_Lang=`echo ${Language##language} | tr -d ' '`

if ( [ "$OEM" = "avme" ] && [ "$avm_Lang" != "en" ] ) || ( [ "$OEM" != "avme" ] && [ "$avm_Lang" = "en" ] ); then 
 echo2 "-- AVM  firmware image version is: $AVM_VERSION-$AVM_SUBVERSION"
 echo2 "-- Language of AVM firmware is: $avm_Lang, language of TCOM firmware is: $tcom_Lang"
 echo2 "-- You cant use branding: \"$OEM\" with this version!"
  sleep 20
fi
AVM_PRODUKT=`ls -d "${FILESYSTEM_DIR}"/etc/default.F*` 
export AVM_PRODUKT=${AVM_PRODUKT##*.}
if [ ${CONFIG_PRODUKT} = "" ]; then
    error "Could not find source directory: ${FILESYSTEM_DIR}/etc/default.F*"
fi
# find the number in AVM_PRODUKT 
FBMOD=${AVM_PRODUKT##*Fritz_Box_}
FBMOD=${FBMOD%%_*}
export FBMOD=`echo ${FBMOD} | tr -d '[:alpha:]'`
#echo "Fritz Box Firmware mod is: ${FBMOD}"

