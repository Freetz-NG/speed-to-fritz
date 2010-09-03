#!/bin/bash
 . $include_modpatch
#add section to rc.S
if ! `cat "$1"/etc/init.d/rc.S | grep -q '/var/flash/aura-usb'` ; then
echo2 "  -- add section to original rc.S"
sed -i -e 's|^.*mknod /var/flash/calllog c $tffs_major $((0x8D))| \
mknod /var/flash/calllog c $tffs_major $((0x8D))\
mknod /var/flash/aura-usb c $tffs_major $((0xA0))\
mknod /var/flash/browser-data c $tffs_major $((0xA8))\
mknod /var/flash/user.cfg c $tffs_major $((0x78))\
mknod /var/flash/userstat.cfg c $tffs_major $((0x79))\
mknod /var/flash/voipd_call_stat c $tffs_major $((0x7A))\
mknod /var/flash/dect_misc c $tffs_major $((0xB0))|' "${1}/etc/init.d/rc.S"
sed -i -e 's|/${OEM}/config.tam|/tcom/config.tam|g' "${1}/etc/init.d/rc.S"
fi

if ! `cat "$1"/etc/init.d/rc.S | grep -q 'ln -s /var/html/html/$Language/tools/flash.html /var/flash.html'` ; then
echo2 "  -- add link line for update page to rc.S"
sed -i -e 's|. /etc/init.d/rc.conf|. /etc/init.d/rc.conf \
ln -s /var/html/html/$Language/tools/flash.html /var/flash.html|' "${1}/etc/init.d/rc.S"
fi
#enable ata menue 
if ! `cat "$1"/etc/init.d/rc.S | grep -q 'var:isAta 1'` ; then
echo2 "  -- enable ATA menuepage "
sed -i -e 's|var:isAta 0|var:isAta 1|g' "${1}/etc/init.d/rc.S"
fi
#all the following adds are not of major importance

if ! `cat "$1"/etc/init.d/rc.S | grep -q 'echo MODE=pd_speed_on >/dev/avm_power'` ; then
sed -i -e 's|^.*echo "4" > /proc/sysrq-trigger|if [ -f /lib/modules/pm_info.in ]; then\
cat /lib/modules/pm_info.in >/dev/avm_power\
fi\
echo "4" > /proc/sysrq-trigger \
echo MODE=pd_speed_on >/dev/avm_power|' "${1}/etc/init.d/rc.S"
fi


if ! `cat "$1"/etc/init.d/rc.S | grep -q 'takeover_printk=1'` ; then
sed -i -e 's|^.*modprobe ubik2|modprobe ubik2 takeover_printk=1\
cat /dev/debug \&|' "${1}/etc/init.d/rc.S"
fi

if ! `cat "$1"/etc/init.d/rc.S | grep -q 'STATES pppoe,0 = 16 -> 0" >/dev/new_led'` ; then
sed -i -e 's|^.* modprobe kdsldmod| \
ln -s /dev/new_led /var/led\
echo "STATES pppoe,0 = 16 -> 0" >/dev/new_led\
echo "STATES pppoe,0 = 17 -> 0" >/dev/new_led\
echo "STATES pppoe,0 = 18 -> 0" >/dev/new_led\
echo "STATES pppoe,0 = 19 -> 0" >/dev/new_led\
modprobe kdsldmod|' "${1}/etc/init.d/rc.S"
fi


if ! `cat "$1"/etc/init.d/rc.S | grep -q 'set | grep -v "IFS="|grep'` ; then
sed -i -e 's!^.*usb_root_path=/lib/modules/2.6.13.1-ohio/kernel/drivers/usb!set | grep -v "IFS="|grep "^[A-Z]"|sed "s/\\(.*\\)/export \\1/" > /var/env.cache\
usb_root_path=/lib/modules/2.6.13.1-ohio/kernel/drivers/usb!' "${1}/etc/init.d/rc.S"
fi








