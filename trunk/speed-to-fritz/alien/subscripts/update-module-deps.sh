#!/bin/sh

if [ -x /sbin/depmod ]; then
	echo "-- Updating module dependency informations"
	/sbin/depmod -b "$1" "$2"
fi


