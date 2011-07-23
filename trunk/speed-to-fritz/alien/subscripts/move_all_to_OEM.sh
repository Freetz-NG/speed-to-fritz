#!/bin/bash
# include modpatch function
. ${include_modpatch}
for wwwdir in usr/www usr/www.nas; do
 webdir="${1}/${wwwdir}"
   for oem_dir in ${OEMLIST}; do
    if [ -d ${webdir}/$oem_dir ] ; then
	[ "$oem_dir" = "all" ] && ! [ -L ${webdir}/$oem_dir ] && rm -fd -R ${webdir}/$OEM
	[ "$oem_dir" = "all" ] && ! [ -L ${webdir}/$oem_dir ] && mv ${webdir}/all  ${webdir}/$OEM && echo2 "   moving $wwwdir/all to $wwwdir/$OEM ..." 
        if ! [ "$DONT_LINK_OENDIRS" == "y" ]; then
    	 [ "$oem_dir" != "$OEM" ] && rm -fd -R ${webdir}/${oem_dir} && echo2 "   removed directory: $wwwdir/$oem_dir"
         [ "$oem_dir" != "$OEM" ] && rm -fd -R  "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" && echo2 "   removed directory: /etc/default.${SORCE_PRODUKT}/$oem_dir"
	 [ -L ${webdir}/$oem_dir ] && [ "$oem_dir" != "$OEM" ] && rm -fd -R ${webdir}/${oem_dir} && echo2 "   removed link: $wwwdir/$oem_dir"
	fi
    fi
   done
done
exit 0
