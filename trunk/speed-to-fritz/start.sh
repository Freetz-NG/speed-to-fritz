#!/bin/bash
export K_ONLY=1 # if set to 1 only build kconfig if set to 0 all tools are rebult first
echo
echo
! [ -f ./incl_var ] && touch ./incl_var
! grep -q 'REUSECONF="y"' ./incl_var && [ -f "./Firmware.conf" ] && rm -fr ./Firmware.conf &&\
echo "You are starting with clean configuration, all settings made last time are removed!" &&\
sleep 3

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
# exract packed ./conf directory
! [ -d "./conf" ] && [ -e "./conf.tar" ] && tar xf ./conf.tar -C . ./conf && echo "-- ./conf.tar extracted"
#  add ready made configs to menu 
./conf/add_config.sh
#set last used revision in Config.in
SVN_REV="$(svnversion . )" && let "SVN_REV=$(echo ${SVN_REV##*:} | tr -d '[:alpha:]')" && sed -i -e "s|default \"....\" # dont edit this line|default \"$SVN_REV\" # dont edit this line|" ./Config.in
make
grep -q 'UPDATE_SP2FR=y' "./Firmware.conf" && eval `grep 'UPDATE_SP2FR' "./Firmware.conf"`
grep -q 'SET_SP2FR_REVISION=y' "./Firmware.conf" && eval `grep 'SET_SP2FR_REVISION' "./Firmware.conf"`
grep -q 'EXPORT_SP2FR_REVISION=' "./Firmware.conf" && eval `grep 'EXPORT_SP2FR_REVISION' "./Firmware.conf"`
#echo "UPDATE_SP2FR: $UPDATE_SP2FR"
#echo "EXPORT_SP2FR_REVISION: $EXPORT_SP2FR_REVISION"
#echo "SET_SP2FR_REVISION: $SET_SP2FR_REVISION"
[ "$EXPORT_SP2FR_REVISION" == "" ] && SET_SP2FR_REVISION="n"
[ "$SET_SP2FR_REVISION" == "y" ] && echo "Checkout older revision $EXPORT_SP2FR_REVISION, be patient ..."  && rm Firmware.conf && rm link.lst &&\
cd .. && svn co -r $EXPORT_SP2FR_REVISION https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk/speed-to-fritz speed-to-fritz-$EXPORT_SP2FR_REVISION &&\
(cd speed-to-fritz-$EXPORT_SP2FR_REVISION && ./start.sh) && exit 0

[ "$UPDATE_SP2FR" == "y" ] && [ "$SET_SP2FR_REVISION" != "y" ] && rm Firmware.conf && echo "Looking for new version ..."  && svn up && make
grep -q 'UPDATE_SP2FR=y' "./Firmware.conf" && eval `grep 'UPDATE_SP2FR' "./Firmware.conf"` && rm Firmware.conf && rm link.lst && echo "Looking for new version ..."  && svn up && make

if ! `cat "./Firmware.conf" | grep -q 'SAVED_CONF=y'`; then
    echo "You must save configuration to './Firmware.conf' when exiting the menu!"
    echo "Run './start' again."
    sleep 10
    exit 0
fi
grep -q 'SEL_FIRMWARE_CONF_TO_USE=y' "./Firmware.conf" && eval `grep 'FIRMWARE_CONF_PATH_TO_USE' "./Firmware.conf"` && \
if [ -f "./conf/$FIRMWARE_CONF_PATH_TO_USE/Firmware.conf" ]; then
    cp -fv ./conf/$FIRMWARE_CONF_PATH_TO_USE/Firmware.conf ./Firmware.conf && ./add_ll.sh
fi
./sp-to-fritz.sh -z
# run Freetz if it was selected in speed-to-fritz menue.
. ./incl_var
[ "$RUNFREETZ" == "y" ] && ./start-freetz.sh
#sleep 20
