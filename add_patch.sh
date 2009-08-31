#!/bin/bash
export HOME="`pwd`"
export include_modpatch="${HOME}/trunk/speed-to-fritz/tools/freetz_patch"
export VERBOSE="-v"

. ${include_modpatch}
DIR="trunk"
#DIR="trunk/speed-to-fritz"
#DIR="trunk/speed-to-fritz/includes"
PATCH="patch.diff"
#PATCH="rev494_dsl-labor-pages.patch"
#PATCH="get_SRC2_ver.patch"
#PATCH="getprodukt.patch"
#PATCH="getversion.patch"
#PATCH="includefunctions.patch"
#PATCH="Config.in.diff"
#PATCH="config.in.diff"
#PATCH="print_settings.diff"
#PATCH="sp-to-fritz.sh.diff"
#PATCH="patch_dect.sh.diff"
#PATCH="install-start.diff"
#PATCH="install-tools.diff"
#PATCH="start-freetz.sh.diff"

#sleep 5
modpatch "${HOME}/${DIR}" "${HOME}/${PATCH}"
#sleep 5
#patch -d "$FILE" -p0 --no-backup-if-mismatch < "$PATCH" 2>&1
echo -n "   All done' ? "; read -n 1 -s YESNO; echo
rm ./$PATCH 
exit 0
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/sbin:/sbin
export inc_DIR="trunk/speed-to-fritz/includes"
export TOOLS_DIR="trunk/speed-to-fritz/tools"
export HOMEDIR="trunk/speed-to-fritz"
export FWBASE="trunk/speed-to-fritz/Firmware.orig"
export P_DIR="trunk/speed-to-fritz/alien/patches"
export sh_DIR="trunk/speed-to-fritz/alien/subscripts"
export sh2_DIR="trunk/speed-to-fritz/subscripts2"
export SPDIR="trunk/speed-to-fritz/SPDIR"
export FBDIR="speed-to-fritz/FBDIR"
export SRC="trunk/speed-to-fritz/FBDIR/squashfs-root"
export FBDIR_2="trunk/speed-to-fritz/FBDIR2"
export SRC_2="trunk/speed-to-fritz/FBDIR2/squashfs-root"
export DST="trunk/speed-to-fritz/SPDIR/squashfs-root"
export FREETZ_VERBOSITY_LEVEL="2"
export AUTO_FIX_PATCHES="y"
