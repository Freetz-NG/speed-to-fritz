#!/bin/bash
export HOMEDIR="`pwd`"
echo "-------------------------------------------------------------------------------------------------------------"
echo
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "Login as normal user!"
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi
FREETZ_DIR="oliver-7390"
rm "$HOMEDIR/$FREETZ_DIR/fwmod"
rm -f $HOMEDIR/$FREETZ_DIR/Makefile.in
svn co http://svn.freetz.org/branches/oliver/7390 $FREETZ_DIR
cd $FREETZ_DIR
#--> diabele building of modules and kernel
sed -i -e "s/kernel-precompiled: pkg-echo-start.*$/kernel-precompiled: pkg-echo-start pkg-echo-done/" "$HOMEDIR/$FREETZ_DIR/make/linux/kernel.mk"
grep -q "kernel-precompiled: pkg-echo-start pkg-echo-done" "$HOMEDIR/$FREETZ_DIR/make/linux/kernel.mk" && echo -e "\033[31mMake kernel is disabled!\033[0m"
#<--
#done ins in trunk now 4835
grep -q " -be" "$HOMEDIR/$FREETZ_DIR/fwmod" && echo -e "\033[31mBig endianness option found!\033[0m"
echo "----------------------------"
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

make menuconfig
make

echo -n "   All done' ? "; read -n 1 -s YESNO; echo
cd ..


sleep 5
