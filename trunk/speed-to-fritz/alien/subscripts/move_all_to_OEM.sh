#!/bin/bash
# include modpatch function
. ${include_modpatch}
for wwwdir in usr/www usr/www.nas; do
 webdir="${1}/${wwwdir}"
   for DIR in ${OEMLIST}; do
    if [ -d ${webdir}/$DIR ] ; then
	[ "$DIR" = "all" ] && rm -fd -R ${webdir}/$OEM
	[ "$DIR" = "all" ] && mv ${webdir}/all  ${webdir}/$OEM && echo2 "   moving $wwwdir/all to $wwwdir/$OEM ..." 
        if ! [ "$DONT_LINK_OENDIRS" == "y" ]; then
    	 [ "$DIR" != "$OEM" ] && rm -fd -R ${webdir}/${DIR} && echo2 "   removed directory: $wwwdir/$DIR"
	 [ -L ${webdir}/$DIR ] && [ "$DIR" != "$OEM" ] && rm -fd -R ${webdir}/${DIR} && echo2 "   removed link: $wwwdir/$DIR"
	    ## moved this to make_oem_links.sh
	    ##[ -d ${webdir}/$OEM ] && [ "$DIR" != "$OEM" ] && ln -sf ${webdir}/$OEM ${webdir}/$DIR && echo2 "-- added link: $wwwdir/$DIR"
	fi
    fi
   done
done
exit 0
