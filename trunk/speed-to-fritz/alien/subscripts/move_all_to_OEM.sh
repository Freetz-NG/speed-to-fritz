#!/bin/bash
# include modpatch function
. ${include_modpatch}
for wwwdir in usr/www usr/www.nas; do
 webdir="${1}/${wwwdir}"
   for oem_dir in ${OEMLIST}; do
    if [ -d ${webdir}/$oem_dir ] ; then
	[ "$oem_dir" = "all" ] && rm -fd -R ${webdir}/$OEM
	[ "$oem_dir" = "all" ] && mv ${webdir}/all  ${webdir}/$OEM && echo2 "   moving $wwwdir/all to $wwwdir/$OEM ..." 
        if ! [ "$DONT_LINK_OENDIRS" == "y" ]; then
    	 [ "$oem_dir" != "$OEM" ] && rm -fd -R ${webdir}/${oem_dir} && echo2 "   removed directory: $wwwdir/$oem_dir"
         [ "$oem_dir" != "$OEM" ] && rm -fd -R  "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" && echo2 "   removed directory: /etc/default.${SORCE_PRODUKT}/$oem_dir"
	 [ -L ${webdir}/$oem_dir ] && [ "$oem_dir" != "$OEM" ] && rm -fd -R ${webdir}/${oem_dir} && echo2 "   removed link: $wwwdir/$oem_dir"
	    ## moved this to make_oem_links.sh
	    ##[ -d ${webdir}/$OEM ] && [ "$oem_dir" != "$OEM" ] && ln -sf ${webdir}/$OEM ${webdir}/$oem_dir && echo2 "-- added link: $wwwdir/$oem_dir"
	fi
    fi
   done
done
exit 0

for oem_dir in freenet hansenet avm avme; do
  ! [ -d "$1/etc/default.${SORCE_PRODUKT}/$OEM" ] &&\
  [ -d "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" ] && mv "$1/etc/default.${SORCE_PRODUKT}/$oem_dir" "$1/etc/default.${SORCE_PRODUKT}/$OEM" &&\
  echo "-- moved /etc/default.${CONFIG_PRODUKT}/$oem_dir to $OEM"
 ##echo "---->OEM: $OEM"
 for wwwdir in usr/www usr/www.nas; do
  webdir="${1}/${wwwdir}"
  [ -d "${webdir}" ] && \
   ! [ -d "${webdir}/${OEM}" ] && \
    [ -d "${webdir}/$oem_dir" ] &&  mv "${webdir}/$oem_dir" "${webdir}/${OEM}" && echo "   moved $wwwdir/$oem_dir to $wwwdir/${OEM}"
 done
done
