#!/bin/sh

if [ -x /sbin/depmod ]; then
	echo "-- Updating module dependency informations"
	/sbin/depmod -a -b "$1" "$2"
sed -i -e "s|kernel/|/lib/modules/$2/kernel/|" "${1}/lib/modules/$2/modules.dep"
sed -i -e "s| kernel/| /lib/modules/$2/kernel/|" "${1}/lib/modules/$2/modules.dep"
rm -f "${1}/lib/modules/$2/modules.dep.bin"
rm -f "${1}/lib/modules/$2/modules.symbols.bin"
rm -f "${1}/lib/modules/$2/modules.alias.bin"
fi


