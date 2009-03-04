#!/bin/bash
 # include modpatch function
 . ${include_modpatch}
# check for bitfile 
BITFILE=""
[ -e "${1}"/lib/modules/microvoip_top.bit ] && BITFILE="microvoip_top.bit"
[ -e "${1}"/lib/modules/microvoip_isdn_top.bit ] && BITFILE="microvoip_isdn_top.bit"
[ "$BITFILE" = "" ] && error 2 "Error no bitfile present!"

# delete section 
sed -i -e "/piglet_bitfile=\//,/\"$/d" "${1}/etc/init.d/rc.S"
sed -i -e "/HWRevision_BitFileCount\" =.*$/,/fi$/d" "${1}/etc/init.d/rc.S"

# add default section
if `cat "${1}/etc/init.d/rc.S" | grep -q 'modprobe Piglet piglet_bitfile='` ; then
	sed -i -e '/modprobe Piglet piglet_bitfile=/i \
piglet_bitfile=/lib/modules/'$BITFILE'${HWRevision_BitFileCount} \
piglet_load_params="\\\
piglet_width_running=1 \\\
piglet_irq_gpio=18 \\\
piglet_irq=9 \\\
piglet_usb_power_bit=-1 \\\
piglet_disable_test=1 \\\
piglet_cs=5 \\\
piglet_reset_bit=-2 \\\
piglet_bitfile_offset=0x51 \\\
piglet_bitfile_write=-1 \\\
piglet_bitfile_revbytes=1 \\\
piglet_enable_button2=1 \\\
"' "${1}/etc/init.d/rc.S"
else
# no ISDN: must be W500V
	sed -i -e '/\[ -n "\$piglet_load_params" \] && \[ -e \$piglet_bitfile \]/i \
piglet_bitfile=/lib/modules/'$BITFILE'${HWRevision_BitFileCount} \
piglet_load_params="\\\
piglet_width_running=1 \\\
piglet_irq_gpio=18 \\\
piglet_irq=9 \\\
piglet_usb_power_bit=-1 \\\
piglet_disable_test=1 \\\
piglet_cs=5 \\\
piglet_reset_bit=-2 \\\
piglet_bitfile_offset=0x51 \\\
piglet_bitfile_write=-1 \\\
piglet_bitfile_revbytes=1 \\\
piglet_enable_button2=1 \\\
"' "${1}/etc/init.d/rc.S"
fi

if `cat "${1}/etc/init.d/rc.S" | grep -q 'microvoip_isdn_top.bit'` ; then
	sed -i -e '/modprobe Piglet piglet_bitfile=/i \
if [ "$HWRevision_BitFileCount" = "3" ] ; then \
 piglet_load_params="\$piglet_load_params piglet_enable_switch=1" \
fi' "${1}/etc/init.d/rc.S"
fi

#if [ "$HWRevision_BitFileCount" = "3" ] ; then \ is set to 3 because if 1 is set extern/intern switch on the box is in use
#this courses more irritations for the user as if the switch is out of funktion, software configuration is sufficient!

# copy t-com parameter
function funct_copy_param()
{
	PARA=`cat "${2}/etc/init.d/rc.S" | grep "${1}="`
	PARA=${PARA% \\*}
	PARA=${PARA##*piglet_}
	if [ -n "$PARA" ]; then
           echo2 "  -- piglet_${PARA}"
		sed -i -e "s/${1}=.*$/piglet_${PARA} \\\/" "${3}/etc/init.d/rc.S"
	else
		sed -i -e "/${1}=.*$/d" "${3}/etc/init.d/rc.S"
	fi
}

funct_copy_param "piglet_irq_gpio" "${2}" "${1}"
funct_copy_param "piglet_irq" "${2}" "${1}"
funct_copy_param "piglet_width_running" "${2}" "${1}"
funct_copy_param "piglet_usb_power_bit" "${2}" "${1}"
funct_copy_param "piglet_disable_test" "${2}" "${1}"
funct_copy_param "piglet_cs" "${2}" "${1}"
funct_copy_param "piglet_reset_bit" "${2}" "${1}"
funct_copy_param "piglet_bitfile_offset" "${2}" "${1}"
funct_copy_param "piglet_bitfile_write" "${2}" "${1}"
funct_copy_param "piglet_bitfile_revbytes" "${2}" "${1}"
funct_copy_param "piglet_enable_button2" "${2}" "${1}"



exit 0
