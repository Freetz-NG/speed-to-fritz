#!/bin/bash
echo
echo "-- Add configs to menu..."
rm -f $HOMEDIR/conf/conf.in
DIRI="$(find $HOMEDIR/conf \( -name Firmware.conf  \) -type f -print)"
PATHS=`echo $DIRI  | sed -e 's|/Firmware.conf||g' -e 's|\.\/||g' -e "s|$HOMEDIR/conf/||g" `
[ "$PATHS" == "" ] && touch $HOMEDIR/conf/conf.in && exit 0
cat > "$HOMEDIR/conf/conf.in" << EOF
choice
	prompt "Select -->"
	depends on SEL_FIRMWARE_CONF_TO_USE
EOF
for file_n in $PATHS; do
    C_FILENAME=`echo $file_n  | sed -e 's|/|_|g' `
    echo  "config ${C_FILENAME}" >> "$HOMEDIR/conf/conf.in"
    echo  "    bool \"${file_n}\"" >> "$HOMEDIR/conf/conf.in"
done
cat >> "$HOMEDIR/conf/conf.in" << EOF
endchoice
config FIRMWARE_CONF_PATH_TO_USE
	string
EOF
for file_n in $PATHS; do
    C_FILENAME=`echo $file_n  | sed -e 's|/|_|g' -e 's|\.||g' `
    echo  "default \"${file_n}\" if ${C_FILENAME}" >> "$HOMEDIR/conf/conf.in"
done
