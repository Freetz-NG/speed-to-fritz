#!/bin/bash
echo "-- removing luna usb ..."

#new lua type pages on 18577
DIRI="$(find ${1}/usr/www/ \( -name usb_devices.lua  \) -type f -print)"
for file_n in $DIRI; do
    sed -i -e 's/show_usb_sharing = true/show_usb_sharing = false/' "$file_n"
    sed -i -e 's/if v.1.==."physmedium"..tonumber.val.5..-1. then/if 1 == 0 then/' "$file_n"
    sed -i -e 's/if tonumber.usb_dev_tab.part_count. == 0 then/if 0 == 0 then/' "$file_n"
    grep -q 'if 1 == 0 then' "$file_n" && echo2 "    removed ram check from file: ${file_n##*/}"
    grep -q 'if 0 == 0 then' "$file_n" && echo2 "    removed usb count from file: ${file_n##*/}"
done
exit 0
