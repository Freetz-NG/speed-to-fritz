#!/bin/bash
mkdir -p /tmp/flash/minicom
cat > "/tmp/flash/minicom/minirc.dfl" << EOF
pu port /dev/ttyS0
pu baudrate 38400
pu minit
pu mreset
pu mhangup
pu rtscts No
EOF
chmod 755 /tmp/flash/minicom/minirc.dfl

cp /etc/inittab /var/tmp
sed -i  's/^ttyS0/# ttyS0/'  /var/tmp/inittab 
mount -o bind /var/tmp/inittab /etc/inittab 
killall -HUP init
./minicom