#!/bin/sh

if [ -x /sbin/depmod ]; then
	echo "-- updating module dependency informations"
	/sbin/depmod -b "$1" "$2" 2> /dev/null
sed -i -e "s|kernel/|/lib/modules/$2/kernel/|" "${1}/lib/modules/$2/modules.dep"
sed -i -e "s| kernel/| /lib/modules/$2/kernel/|" "${1}/lib/modules/$2/modules.dep"
rm -f "${1}/lib/modules/$2/modules.dep.bin"
rm -f "${1}/lib/modules/$2/modules.symbols.bin"
rm -f "${1}/lib/modules/$2/modules.alias.bin"
#14464 uses links to /var/...
echo "/lib/modules/$2/kernel/drivers/net/rfcntl/rfcntl.ko: /lib/modules/$2/kernel/drivers/char/audio/avm_audio.ko" >> "${1}/lib/modules/$2/modules.dep"
echo "/lib/modules/$2/kernel/drivers/char/audio/avm_audio.ko:" >> "${1}/lib/modules/$2/modules.dep"
fi


