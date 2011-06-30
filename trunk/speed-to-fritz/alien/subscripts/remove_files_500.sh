#!/bin/bash
. ${include_modpatch}
echo2 "  -- removing files ..."
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/scsi | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/usb | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/drivers/wlan | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/fat | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/vfat | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/lib/modules/2.6.13.1-ohio/kernel/fs/nls | sed "s/.*\//\t'/"
rm -fr $VERBOSE ${1}/usr/share/ctlmgr/libctlusb* | sed "s/.*\//\t'/"
exit 0
