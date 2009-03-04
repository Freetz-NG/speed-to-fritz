#!/bin/bash
# Fon parameter used in countrys with Annex A
if [ ${ANNEX} = "A" ] ; then
    if ! `cat "${1}"/etc/init.d/rc.S | grep -q 'local_ec=3'`; then
     sed -i -e 's|isdn_params=""|isdn_params=""\
isdn_params="${isdn_params} local_ec=3"|' "${1}"/etc/init.d/rc.S
    fi
else
 sed -i -e 's| local_ec=3||' "${1}"/etc/init.d/rc.S
fi
exit 0