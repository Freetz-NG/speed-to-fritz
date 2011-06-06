#!/bin/bash
if ! `cat "./incl_var" | grep -q 'REUSECONF="y"'`; then
    [ -f "./Firmware.conf" ] && rm -fdr ./Firmware.conf
    echo "You are starting with clean configuration, all settings made last time are removed!"
fi
if ! [ -f "./Firmware.conf" ]; then
    echo "#!/bin/bash" > ./Firmware.conf
    echo "# Automatically generated make config: don't edit" >> ./Firmware.conf
    chmod 755 "./Firmware.conf"

cat << 'EOF' > "./incl_var"
#!/bin/bash
export FIRST_RUN="y"
export VERBOSE=""
export OEM="avm"
export HWRevision="101.1.1.0"
export ETH_IF=""
export IPADDRESS="192.168.178.1"
export CONFIG_jffs2_size="32"
export ANNEX="B"
export avm_Lang="de"
export SKRIPT_DATE="00 --- ATTENTION, you are starting the setuptool for the first time! ---"
export AVM_VERSION="04.57"
export TCOM_VERSION="04.56"
export SPNUM="701"
export CLASS="Speedport"
export TCOM_SUBVERSION="0"
export AVM_SUBVERSION="0"
export firmwareconf_file_name="Firmware.conf"
EOF
chmod 755 "./incl_var"
fi
export HOMEDIR="`pwd`"
#  add ready made configs to menu 
##! [ -e "./conf/conf.in" ] && 
./conf/add_config.sh
#set last used revision in Config.in
SVN_REV="$(svnversion . )" && let "SVN_REV=$(echo ${SVN_REV##*:} | tr -d '[:alpha:]')" && sed -i -e "s|default \"....\" #|default \"$SVN_REV\" #|" ./Config.in
make
grep -q 'UPDATE_SP2FR=y' "./Firmware.conf" && eval `grep 'UPDATE_SP2FR' "./Firmware.conf"`
grep -q 'SET_SP2FR_REVISION=y' "./Firmware.conf" && eval `grep 'SET_SP2FR_REVISION' "./Firmware.conf"`
grep -q 'EXPORT_SP2FR_REVISION=' "./Firmware.conf" && eval `grep 'EXPORT_SP2FR_REVISION' "./Firmware.conf"`
#echo "UPDATE_SP2FR: $UPDATE_SP2FR"
#echo "EXPORT_SP2FR_REVISION: $EXPORT_SP2FR_REVISION"
#echo "SET_SP2FR_REVISION: $SET_SP2FR_REVISION"
[ "$EXPORT_SP2FR_REVISION" == "" ] && SET_SP2FR_REVISION="n"
[ "$SET_SP2FR_REVISION" == "y" ] && echo "Chechout older revision $EXPORT_SP2FR_REVISION, be patient ..."  && rm Firmware.conf &&\
cd .. && svn co -r $EXPORT_SP2FR_REVISION https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk/speed-to-fritz speed-to-fritz-$EXPORT_SP2FR_REVISION &&\
(cd speed-to-fritz-$EXPORT_SP2FR_REVISION && ./start.sh) && exit 0

[ "$UPDATE_SP2FR" == "y" ] && [ "$SET_SP2FR_REVISION" != "y" ] && rm Firmware.conf && echo "Looking vor new version ..."  && svn up && make
grep -q 'UPDATE_SP2FR=y' "./Firmware.conf" && eval `grep 'UPDATE_SP2FR' "./Firmware.conf"` && rm Firmware.conf && echo "Looking vor new version ..."  && svn up && make

if ! `cat "./Firmware.conf" | grep -q 'SAVED_CONF=y'`; then
    echo "You must save configuration to './Firmware.conf' when exiting the menu!"
    echo "Run './start' again."
    sleep 10
    exit 0
fi
grep -q 'SEL_FIRMWARE_CONF_TO_USE=y' "./Firmware.conf" && eval `grep 'FIRMWARE_CONF_PATH_TO_USE' "./Firmware.conf"` && \
[ -f "./conf/$FIRMWARE_CONF_PATH_TO_USE/Firmware.conf" ] && cp -fv ./conf/$FIRMWARE_CONF_PATH_TO_USE/Firmware.conf ./Firmware.conf && ./restart && exit 0
#. FirmwareConfStrip
./sp-to-fritz.sh -z
# run Freetz if it was selected in speed-to-fritz menue.
. ./incl_var
[ "$RUNFREETZ" == "y" ] && ./start-freetz.sh
#sleep 20