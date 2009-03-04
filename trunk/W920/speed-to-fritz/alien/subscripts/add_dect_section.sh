#!/bin/bash

SR1="$1" 

#add section to rc.S
echo "-- Add  section to original rc.S"

sed -i -e 's|^.*mknod /var/flash/calllog c $tffs_major $((0x8D))| \
mknod /var/flash/calllog c $tffs_major $((0x8D))\
mknod /var/flash/dmgr_handset_user c $tffs_major $((0xB2))\
mknod /var/flash/dect_misc c $tffs_major $((0xB0))|' "$SR1/etc/init.d/rc.S"


sed -i -e 's|if /usr/bin/checkempty /var/flash/ar7\.cfg; then|copy_dect_defaults dect_eeprom ${CONFIG_PRODUKT} ${OEM} ${OEM_DEFAULT_INDEX}\
if /usr/bin/checkempty /var/flash/ar7\.cfg; then|' "$SR1/etc/init.d/rc.S"


sed -i -e 's|copy_telefonie_defaults() {| copy_dect_defaults() {\
tmp_file_name=$1\
tmp_produkt=$2\
tmp_oem=$3\
tmp_index=$4\
if /usr/bin/checkempty /var/flash/${tmp_file_name}; then\
if [ -f /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name}.${tmp_index} ] ; then\
echo "DECT Defaults: cp /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name}.${tmp_index} /var/flash/${tmp_file_name}"\
cp /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name}.${tmp_index} /var/flash/${tmp_file_name}\
return\
fi\
if [ -f /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name} ] ; then\
echo "DECT Defaults: cp /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name} /var/flash/${tmp_file_name}"\
cp /etc/default\.${tmp_produkt}/${tmp_oem}/${tmp_file_name} /var/flash/${tmp_file_name}\
return\
fi\
fi\
}\
copy_telefonie_defaults() {|' "$SR1/etc/init.d/rc.S"

exit 0
