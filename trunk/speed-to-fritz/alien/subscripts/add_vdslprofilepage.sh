#!/bin/bash
# include modpatch function
. ${include_modpatch}
OEML="avm" && [ -d "${DST}"/usr/www/avme ] && OEML="avme"
OEML2="avm" && [ -d "${SRC_2}"/usr/www/avme ] && OEML2="avme"
if [ "${ADD_VDSL_PROFILE}" = "y" ]; then

echo "-- Adding vdsl profile pages ..."
#in progress

fi
