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
#annex settings made via GUI
if ! `grep -q 'ar7cfg.dslglobalconfig.Annex' "${1}"/etc/init.d/rc.conf`; then
     sed -i -e '/export ANNEX=.cat .CONFIG_ENVIRONMENT_PATH.annex./d' "${1}"/etc/init.d/rc.conf
     sed -i -e '/"$annex_param"/a\
if [ "${CONFIG_DSL_MULTI_ANNEX}" = "y" ] ; then\
LOADANNEX=`echo ar7cfg.dslglobalconfig.Annex | ar7cfgctl -s 2>\/dev\/null | sed s\/\\\\"\/\/g` ; # annex aus userselection?\
if [ -z "${LOADANNEX}" ] ; then\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` ; # annex aus /proc nehmen, nicht von Config!\
else\
export ANNEX=${LOADANNEX} ; # annex aus userselection\
fi\
else\
export ANNEX=`cat $CONFIG_ENVIRONMENT_PATH\/annex` \
fi' "${1}"/etc/init.d/rc.conf
fi
exit 0

