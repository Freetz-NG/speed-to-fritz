#!/bin/bash
 . $include_modpatch
	sed -i -e "/export CONFIG_ENVIRONMENT_PATH=\/proc\/sys\/urlader/a \
	echo firmware_version ${OEM} > \$CONFIG_ENVIRONMENT_PATH\/environment" "${SRC}/etc/init.d/rc.S"
exit 0
