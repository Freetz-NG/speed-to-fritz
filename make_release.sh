#!/bin/bash
# asume working SVN direcroty is: ./trunk and windows mount is: /mnt/win
# and this file must be started at the root off ./trunk
echo "---------------------------------------------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------------------------------------------"
TMP_DIR="./tmp"
UPSTREAM_DIR="/mnt/win/upstream"
SVN_TRUNK_DIR="./trunk"
VER=$(date +%Y_%m_%d)
mkdir -p $TMP_DIR
mkdir -p $UPSTREAM_DIR
cp -fdrp $SVN_TRUNK_DIR/speed-to-fritz --target-directory="$TMP_DIR"
cp -fdrp $SVN_TRUNK_DIR/co --target-directory="$TMP_DIR"
# Remove left over Subversion directories
find "$TMP_DIR" -type d -name .svn | xargs rm -rf
tar zcf $UPSTREAM_DIR/speed-to-fritz-${VER}.tar.gz -C $TMP_DIR ./speed-to-fritz && echo "Created $UPSTREAM_DIR/speed-to-fritz-${VER}.tar.gz for upload!" 
#
echo "---------------------------------------------------------------------------------------------------------------"
VER=$(cat ${TMP_DIR}/co/henrynestler/version)
echo "freetzlinux skript version: $VER"
tar cf $UPSTREAM_DIR/co-${VER}.tar.gz -C $TMP_DIR ./co  && echo "Created $UPSTREAM_DIR/co-${VER}.tar for upload!" 
rm -rf ${TMP_DIR}
echo "---------------------------------------------------------------------------------------------------------------"
#cp -v /mnt/and/co.1.${VER}.tar $UPSTREAM_DIR/co.1.${VER}.tar # beinhaltet auch die co downloads
cp -v /mnt/and/freetzLinux-${VER}.exe $UPSTREAM_DIR/freetzLinux-${VER}.exe && echo "Coppyed $UPSTREAM_DIR/freetzLinux-${VER}.exe!"
echo "---------------------------------------------------------------------------------------------------------------"
cat <<EOF > $UPSTREAM_DIR/upload_files_${VER}.sh
#sudo apt-get install rsync xinetd
rsync -avP -e ssh co-${VER}.tar.gz jpascher@frs.sourceforge.net:uploads/
sleep 10
rsync -avP -e ssh freetzLinux-${VER}.exe jpascher@frs.sourceforge.net:uploads/
exit
#findet Verzeichnis nicht
sftp jpascher,freetzlinux@frs.sourceforge.net <<EOT
cd uploads
put co-${VER}.tar.gz
put freetzLinux-${VER}.exe
bye
EOT
EOF
chmod 777 $UPSTREAM_DIR/upload_files_${VER}.sh


