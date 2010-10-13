#!/bin/bash
echo "-- wrap dsld ..."

LIBS=

# these libs are at least neccesary
[ "$WRAP_DSLD_LIBBOXLIB" = y ] && \
	LIBS="$LIBS libboxlib.so.0.0.0"
[ "$WRAP_DSLD_LIBAR7CFG" = y ] && \
	LIBS="$LIBS libar7cfg.so.1.0.0"
[ "$WRAP_DSLD_LIBAVMCSOCK" = y ] && \
	LIBS="$LIBS libavmcsock.so.2.0.0"
[ "$WRAP_DSLD_LIBAVMCIPHER" = y ] && \
	LIBS="$LIBS libavmcipher.so.0.0.0"
[ "$WRAP_DSLD_LIBAVMHMAC" = y ] && \
	LIBS="$LIBS libavmhmac.so.2.0.0"
[ "$WRAP_DSLD_LIBEWNWLINUX" = y ] && \
	LIBS="$LIBS libewnwlinux.so.2.0.0"
[ "$WRAP_DSLD_LIBSLAB" = y ] && \
	LIBS="$LIBS libslab.so.2.0.0"

# perhaps these are needed later when AVM changes more 
# undocumented and properitary API
#	LIBS="$LIBS libwdt.so.1.0.0"

# example target layout:
#
#	 /lib/dsld/dsld
#	 /lib/dsld/libar7cfg.so
#	 /lib/dsld/libar7cfg.so.1.0.0 
#	 /lib/dsld/libar7cfg.so.1 ( Symlink nach libar7cfg.so.1.0.0 )
#	 /lib/dsld/libar7cfg.so (Symlink nach libar7cfg.so.1 )
#	 /lib/dsld/dsld-wrapper.sh
#	 /sbin/dsld (Symlink nach ../lib/dsld/dsld-wrapper.sh )

DSLD_DIR=/lib/dsld
mkdir -p "${SRC}/$DSLD_DIR"

# build dsld-wrappers.sh
[ "$PATCH_DSLIP_AR7" = "y" ] && \
cat <<EOF > "${SRC}/${DSLD_DIR}/dsld-wrapper.sh"
#!/bin/sh
LD_LIBRARY_PATH="${DSLD_DIR}:\$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="\${LD_LIBRARY_PATH%:}"
cp /var/flash/ar7.cfg /var/flash/ar7
sed -i -e "/\(dslinterface .\)/,/\(\}\)/ { /dslinterface ./b; /\}/b; s/ipaddr =.*/ipaddr = 169.254.2.1;/ }" /var/flash/ar7
sed -i -e "/\(dslinterface .\)/,/\(\}\)/ { /dslinterface ./b; /\}/b; s/netmask =.*/netmask = 255.255.255.255;/ }" /var/flash/ar7
sed -i -e "/\(dslinterface .\)/,/\(\}\)/ { /dslinterface ./b; /\}/b; s/dstipaddr =.*/dstipaddr = 169.254.2.1;/ }" /var/flash/ar7
cp /var/flash/ar7 /var/flash/ar7.cfg
export LD_LIBRARY_PATH
exec ${DSLD_DIR}/dsld "\$@"
EOF

[ "$PATCH_DSLIP_AR7" != "y" ] && \
cat <<EOOF > "${SRC}/${DSLD_DIR}/dsld-wrapper.sh"
#!/bin/sh
LD_LIBRARY_PATH="${DSLD_DIR}:\$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="\${LD_LIBRARY_PATH%:}"
export LD_LIBRARY_PATH
exec ${DSLD_DIR}/dsld "\$@"
EOOF
chmod 755 "${SRC}/${DSLD_DIR}/dsld-wrapper.sh"


rm -f "${SRC}/sbin/dsld"
ln -sf ..${DSLD_DIR}/dsld-wrapper.sh "${SRC}/sbin/dsld"

cp -fdrp "${DST}"/sbin/dsld --target-directory="${SRC}/${DSLD_DIR}"
for lib in $LIBS; do
	cp -fdrp "${DST}"/lib/"$lib" --target-directory="${SRC}/${DSLD_DIR}"
	target="$lib" 
	until [ "${target%.[0-9]}" = "$target" ]; do
		ln -s "$target" "${SRC}/${DSLD_DIR}/${target%.[0-9]}"
		target="${target%.[0-9]}"
	done

done

