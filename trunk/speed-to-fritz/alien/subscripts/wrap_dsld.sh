#!/bin/bash
echo "-- Wrap dsld ..."

DSLD_DIR=/lib/dsld
mkdir -p "${SRC}/$DSLD_DIR"

# build dsld-wrappers.sh
cat <<EOF > "${SRC}/${DSLD_DIR}/dsld-wrapper.sh"
#!/bin/sh
LD_LIBRARY_PATH="${DSLD_DIR}:\$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="\${LD_LIBRARY_PATH%:}"
export LD_LIBRARY_PATH
exec ${DSLD_DIR}/dsld "\$@"
EOF
chmod 755 "${SRC}/${DSLD_DIR}/dsld-wrapper.sh"

rm -f "${SRC}/sbin/dsld"
ln -sf ..${DSLD_DIR}/dsld-wrapper.sh "${SRC}/sbin/dsld"

cp -fdrp "${DST}"/sbin/dsld --target-directory="${SRC}/${DSLD_DIR}"
for lib in libar7cfg.so.1.0.0 libboxlib.so.0.0.0; do
	cp -fdrp "${DST}"/lib/"$lib" --target-directory="${SRC}/${DSLD_DIR}"
	target="$lib" 
	until [ "${target%.[0-9]}" = "$target" ]; do
		ln -s "$target" "${SRC}/${DSLD_DIR}/${target%.[0-9]}"
		target="${target%.[0-9]}"
	done
done

# target layout:
#
#	 /lib/dsld/dsld
#	 /lib/dsld/libar7cfg.so
#	 /lib/dsld/libar7cfg.so.1.0.0 
#	 /lib/dsld/libar7cfg.so.1 ( Symlink nach libar7cfg.so.1.0.0 )
#	 /lib/dsld/libar7cfg.so (Symlink nach libar7cfg.so.1 )
#	 /lib/dsld/dsld-wrapper.sh
#	 /sbin/dsld (Symlink nach ../lib/dsld/dsld-wrapper.sh )
