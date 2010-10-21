#!/bin/bash
 . ${include_modpatch}
echo2 "  -- removing files ..."
for DIR in ${OEM}; do
# if [ "$DIR" = "avme" ] ; then
#  export HTML="$DIR/$avm_Lang/html"
# else
  export HTML="$DIR/html"
# fi
    DSTI="${1}"/usr/www/$HTML
    if [ -d ${DSTI} ]; then
#-----------------------------------------
#echo "-- /usr/www/$HTML/$avm_Lang/..."
sleep 0
  
#---------------------------------------------
    fi
done

rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/scsi
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/usb
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/wlan

rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/fat
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/vfat
rm -fd -R ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/nls

rm -rf ${1}/usr/share/ctlmgr/libctlusb*




exit 0

rm_files()
{
	for file in $1; do
	echo2 "$file"
	rm -rf "$file"
	done
}

rm_files "$(find ${1}/lib/modules -name scsi)"
