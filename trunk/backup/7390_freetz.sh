#!/bin/bash
export HOMEDIR="`pwd`"
#With revision 4818 new squashfs is now in the trunk, we dont need to add it any more.
FREETZ_REVISION="4846"
FREETZ_DIR="freetz-trunk-7390" 
##rm -fdR  $FREETZ_DIR
rm -f $HOMEDIR/$FREETZ_DIR/Makefile.in
rm -f $HOMEDIR/$FREETZ_DIR/Config.in
rm -f $HOMEDIR/$FREETZ_DIR/fwmod
rm -f $HOMEDIR/$FREETZ_DIR/toolchain/Config.in
rm -f $HOMEDIR/$FREETZ_DIR/toolchain/make/Makefile.in
rm -f $HOMEDIR/$FREETZ_DIR/toolchain/make/target/uclibc/uclibc.mk
rm -f $HOMEDIR/$FREETZ_DIR/make/Makefile.in
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/kernel.mk
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/Config.iks-16mb_26.7390_04.83
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/Config.ikanos-8mb_26.7390_04.83
rm -fdR $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7390_04.83
rm -fdR $HOMEDIR/$FREETZ_DIR/patches/7390
rm -f $HOMEDIR/$FREETZ_DIR/patches/196-usbstorage.sh
rm -f $HOMEDIR/$FREETZ_DIR/patches/220-assistant.sh
rm -f $HOMEDIR/$FREETZ_DIR/patches/cond/usbstorage_7390.patch
rm -f $HOMEDIR/$FREETZ_DIR/patches/cond/de/remove_assistant_7390.patch
rm -f $HOMEDIR/$FREETZ_DIR/patches/cond/de/webmenu-wol-7390.patch

rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7390_04.83/110-hwrev_list.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7390_04.83/140-platform_c.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7390_04.83/130-revert_skbuff_changes.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7390_04.83/120-remove_fusiv.patch

rm -f "$HOMEDIR/$FREETZ_DIR/make/config.mipsel"
rm -f "$HOMEDIR/$FREETZ_DIR/make/config.mips"

rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/600-cpmac_ioctl.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/3270_04.80/600-cpmac_ioctl.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7270_04.80/600-cpmac_ioctl.patch

svn co http://svn.freetz.org/trunk $FREETZ_DIR -r $FREETZ_REVISION

cp -fdrp $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/600-cpmac_ioctl.patch $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/3270_04.80/600-cpmac_ioctl.patch
cp -fdrp $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/600-cpmac_ioctl.patch $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/7270_04.80/600-cpmac_ioctl.patch
rm -f $HOMEDIR/$FREETZ_DIR/make/linux/patches/2.6.19.2/600-cpmac_ioctl.patch
# ? ->
cp -f $HOMEDIR/$FREETZ_DIR/make/config.mipsel $HOMEDIR/$FREETZ_DIR/make/config.mips
sed -i -e 's|export ac_cv_c_bigendian=no|export ac_cv_c_bigendian=yes|' "$HOMEDIR/$FREETZ_DIR/make/config.mips " 2> /dev/null
sed -i -e 's|export ||' "$HOMEDIR/$FREETZ_DIR/make/config.mips " 2> /dev/null
# <- ?
cd $FREETZ_DIR
#patch 7390_3.patch aus ticket #673  (Config.in diff removed)
PATCH="$HOMEDIR/7390_3.2.patch"
patch -d . -p0 -N --no-backup-if-mismatch < "$PATCH" 2>&1
#patch add Config in diff
PATCH="$HOMEDIR/7390_Config.in.R4818.diff"
patch -d . -p0 -N --no-backup-if-mismatch < "$PATCH" 2>&1
#--> diabele building of modules and kernel
sed -i -e "s/kernel-precompiled: pkg-echo-start.*$/kernel-precompiled: pkg-echo-start pkg-echo-done/" "$HOMEDIR/$FREETZ_DIR/make/linux/kernel.mk"
grep -q "kernel-precompiled: pkg-echo-start pkg-echo-done" "$HOMEDIR/$FREETZ_DIR/make/linux/kernel.mk" && echo -e "\033[31mMake kernel is disabled!\033[0m"
#<--
#patch add be option to fwmod
PATCH="$HOMEDIR/add_target_option.diff"
patch -d . -p0 -N --no-backup-if-mismatch < "$PATCH" 2>&1
grep -q " -be" "$HOMEDIR/$FREETZ_DIR/fwmod" && echo -e "\033[31mBig endianness option found!\033[0m"
# add complete patch subdirectory for 7390 based on 7270_labor_phone
PATCH="$HOMEDIR/7390_patch_dir.diff"
patch -d . -p0 -N --no-backup-if-mismatch < "$PATCH" 2>&1
# patch
sed -i -e 's/jffs|fuse|cifs/jffs|fuse|cifs|yaffs/' "$HOMEDIR/$FREETZ_DIR/root/usr/lib/cgi-bin/mod/mounted.cgi"
# -> Set Freetz /dl Downloaddirectory to windows partition if existent to free up space needed for working.
# This part is without funktion if /mnt/win/dl dirictory is not existant.
WinPartitopn="/mnt/win/dl"
WinPartitopn=`echo "$WinPartitopn" | tr '/' '\/' `
[ -d "$WinPartitopn" ] && sed -i -e "s|\(DL_DIR:=\).*$|\1${WinPartitopn}|" "$HOMEDIR/$FREETZ_DIR/Makefile"
[ -d "$WinPartitopn" ] && echo -e "\033[1mFreetz download directory is now set to windows partition:\033[0m ${WinPartitopn}" 
eval `cat $HOMEDIR/$FREETZ_DIR/Makefile | grep  'DL_DIR:=' | tr -d ':'`
DL_DIR_ABS=$HOMEDIR/$FREETZ_DIR/$DL_DIR
`cat $HOMEDIR/$FREETZ_DIR/Makefile | grep -q 'DL_DIR:=/'` && DL_DIR_ABS=$DL_DIR
[ -d "$DL_DIR_ABS" ] || mkdir  "$DL_DIR_ABS"
[ -d "$DL_DIR_ABS/fw" ] || mkdir  "$DL_DIR_ABS/fw"
# <- Set Freetz /dl 
# copy default 7390 config
###cp -f $HOMEDIR/.config $HOMEDIR/$FREETZ_DIR/.config

make menuconfig
# Use different kernel source
USE_ALTERNATIV_SOURCE="n"
if [ "$USE_ALTERNATIV_SOURCE" == "y" ];then
KERNEL_DL_LINK="@AVM/fritz.box/fritzbox.fon_wlan_7390/x_misc/opensrc/fritz_box_fon_wlan_7390_source_files.04.83.tar.gz"
KERNEL_DL_LINK="http://hilfe.telekom.de/dlp/eki/downloads/Speedport/Speedport_W722V/GPL-Speedport_W722V.tar.gz"
KERNEL_SOURCE="$(echo $KERNEL_DL_LINK | sed -e "s/.*\///")"
KERNEL_SITE="${KERNEL_DL_LINK%/*}"
[ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SOURCE=.*$/FREETZ_DL_KERNEL_SOURCE=$KERNEL_SOURCE/" "./.config" 2> /dev/null
[ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SITE=.*$/FREETZ_DL_KERNEL_SITE=$KERNEL_SITE/" "./.config" 2> /dev/null
[ -n "$KERNEL_SOURCE" ] && sed -i -e "s/FREETZ_DL_KERNEL_SOURCE_MD5=.*$/FREETZ_DL_KERNEL_SOURCE_MD5=\"\"/" "./.config" 2> /dev/null
fi
make
echo -n "   All done' ? "; read -n 1 -s YESNO; echo
cd ..
