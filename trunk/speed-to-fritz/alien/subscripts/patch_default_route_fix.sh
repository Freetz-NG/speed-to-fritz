#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "$1"
modpatch "$1" "$P_DIR/default_route_fix.patch"
chmod +x $1/etc/onlinechanged/dsld_default_route
exit 0
