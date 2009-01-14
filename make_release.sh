#!/bin/bash
# asume working SVN direcroty is: ./trunk and windows mount is: /mnt/win
# and this file must be started at the root off ./trunk
echo "---------------------------------------------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------------------------------------------"
TMP_DIR="./tmp"
UPSTREAM_DIR="/mnt/win/upstream"
SVN_TRUNK_DIR="./trunk"
VER=$(date +%y.%m.%d)
mkdir -p $TMP_DIR
mkdir -p $UPSTREAM_DIR
cp -fdrp $SVN_TRUNK_DIR/speed-to-fritz --target-directory="$TMP_DIR"
cp -fdrp $SVN_TRUNK_DIR/co --target-directory="$TMP_DIR"
# Remove left over Subversion directories
find "$TMP_DIR" -type d -name .svn | xargs rm -rf
tar zcf $UPSTREAM_DIR/speed-to-fritz-${VER}.tar.gz -C $TMP_DIR/speed-to-fritz . && echo "Created $UPSTREAM_DIR/speed-to-fritz-${VER}.tar.gz for upload!" 
#
echo "---------------------------------------------------------------------------------------------------------------"
VER=$(cat ${TMP_DIR}/co/henrynestler/version)
echo "freetzlinux skript version: $VER"
tar cf $UPSTREAM_DIR/co-${VER}.tar.gz -C $TMP_DIR/co . && echo "Created $UPSTREAM_DIR/co-${VER}.tar for upload!" 
rm -rf ${TMP_DIR}
echo "---------------------------------------------------------------------------------------------------------------"

sleep 5