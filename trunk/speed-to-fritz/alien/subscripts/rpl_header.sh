#!/bin/bash
 # include modpatch function
 . $include_modpatch
echo "-- Adding Header ..."
for DIR in ${OEMLIST}; do
 if [ "$DIR" = "avme" ] ; then
  export HTML="$DIR/$avm_Lang/html"
 else
  export HTML="$DIR/html"
 fi
    DSTI="$1"/usr/www/$HTML/${avm_Lang}
    if [ -d ${DSTI}/images ] ; then
    	if [ -f $P_DIR/fw_header980.gif ] && [ $AVM_V_MINOR -gt 46 ] && [ "$avm_Lang" = "de" ]; then 
	 echo2 "      /usr/www/${HTML}/${avm_Lang}/images/fw_header980.gif"
	  cp -fdpr  $P_DIR/fw_header980.gif  --target-directory="$1"/usr/www/${HTML}/${avm_Lang}/images
	fi
	if ( [ -f $P_DIR/fw_header.gif ] && [ $AVM_V_MINOR -lt 47 ] ) || [ "$avm_Lang" = "en" ]; then 
	 echo2 "      /usr/www/${HTML}/${avm_Lang}/images/fw_header.gif"
	 cp -fdpr  $P_DIR/fw_header.gif  --target-directory="$1"/usr/www/${HTML}/${avm_Lang}/images
	fi
    fi
done

exit 0

