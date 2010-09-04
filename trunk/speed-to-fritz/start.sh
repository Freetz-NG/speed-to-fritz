#!/bin/bash
### speedtofritz version and other variables used last time
### specifies the configfile in use, 
### put a hash sign in front if you want to use the filename used the last time
#export firmwareconf_file_name="conf-900-freetz"
### invoke menuconfig  
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
#[ -f "./${firmwareconf_file_name}.tar" ] && tar --overwirte  -xf "${firmwareconf_file_name}"
make
if ! `cat "./Firmware.conf" | grep -q 'SAVED_CONF=y'`; then
    echo "You must save configuration to './Firmware.conf' when exiting the menu!"
    echo "Run './start' again."
    sleep 5
    exit 0
fi
#. FirmwareConfStrip
./sp-to-fritz.sh -z
# run Freetz if it was selected in speed-to-fritz menue.
. ./incl_var
[ "$RUNFREETZ" == "y" ] && ./start-freetz.sh
#sleep 20