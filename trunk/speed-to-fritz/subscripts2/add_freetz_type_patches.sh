#!/bin/bash
#echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
 . $include_modpatch
  # include freetz subrutines
 . $include_isfreetz
#adapt freetz vars
#export L0=''
export L1='  '
export L2='    '
export FREETZ_VERBOSITY_LEVEL="1"
[ "$VERBOSE" == "-v" ] && export FREETZ_VERBOSITY_LEVEL="3"
export DIR="$HOMEDIR"
mkdir -p "${HOMEDIR}/.tk/original"
ln -s $2 ${HOMEDIR}/.tk/original/filesystem
export FIRMWARE2="$SRC_2"
export FILESYSTEM_MOD_DIR="$1"
export FIRMWARE_MOD_DIR="$FBDIR"
export PATCHES_DIR="$FREETZ_P_DIR"
#Some more vars may be needed if orignal freetz patches will be used as the are.
#If aditional patches from freetz are used vars should be set up within Config.in
#Setting up this vars in Config.in would mean to add to the varable name 'EXPORT_'
# Example:
#FREETZ_ENFORCE_URLADER_SETTING_FIRMWARE_VERSION
#EXPORT_FREETZ_ENFORCE_URLADER_SETTING_FIRMWARE_VERSION
echo " -- applying foreign patches"
	# Apply patches
	if [ ! -d "${FREETZ_P_DIR}" ]; then
		error 1 "missing ${FREETZ_P_DIR}"
	fi
	# Execute version specific patch scripts
	for i in "${FREETZ_P_DIR}/"*.sh; do
		[ -r "$i" ] || continue
		echo2 "  -- applying patch file $i"
		. $i
	done
	# Apply (general, version specific, language specific) patches
	for i in "${FREETZ_P_DIR}/"*.patch \
	#FBMOD
		"${FREETZ_P_DIR}/${AVM_VERSION}/"*.patch \
		"${FREETZ_P_DIR}/${AVM_VERSION}/${avm_Lang}/"*.patch
	do
		modpatch "$1" "$i"
	done
exit 0