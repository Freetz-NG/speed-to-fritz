
#!/bin/bash
# 7320 an 722 uses ttyS1 as serial consol
[ "$SPMOD" = "722" ] && exit 0
[ "$SPMOD" = "7320" ] && exit 0
# include modpatch function
. $include_modpatch
echo "-- replaced /etc/inittab.sh ..."
cat << 'EOF' > "${1}/etc/inittab"
##
::restart:/sbin/init
::sysinit:/etc/init.d/rc.S
## Start an "askfirst" shell on the console (whatever that may be)
ttyS0::askfirst:-/bin/sh
## Stuff to do before rebooting
::shutdown:/bin/sh -c /var/post_install &>/dev/null
EOF
exit 0

