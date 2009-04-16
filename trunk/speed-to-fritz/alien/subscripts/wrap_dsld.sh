#!/bin/bash
echo "-- Wrap dsld ..."

mkdir ${SRC}/lib/dsld

cat <<EOF > ${SRC}/lib/dsld/dsld-wrapper.sh
#!/bin/sh
# dsld-wrapper.sh
DSLD_DIR=/lib/dsld
LD_LIBRARY_PATH="\$DSLD_DIR:\$LD_LIBRARY_PATH"
LD_LIBRARY_PATH="\${LD_LIBRARY_PATH%:}"
export LD_LIBRARY_PATH
exec \$DSLD_DIR/dsld "\$@"
EOF
chmod +x ${SRC}/lib/dsld/dsld-wrapper.sh

cp -fdrp "${DST}"/sbin/dsld --target-directory="${SRC}"/lib/dsld
cp -fdrp "${DST}"/lib/libar7cfg.so.1.0.0 --target-directory="${SRC}"/lib/dsld
ln -s /lib/dsld/libar7cfg.so.1.0.0 "${SRC}/lib/dsld/libar7cfg.so.1"
ln -s /lib/dsld/libar7cfg.so.1.0.0 "${SRC}/lib/dsld/libar7cfg.so"
rm -f "${SRC}/sbin/dsld"
ln -s /lib/dsld/dsld-wrapper.sh "${SRC}/sbin/dsld"
exit 0

# target layout:
#
#	 /lib/dsld/dsld
#	 /lib/dsld/libar7cfg.so
#	 /lib/dsld/libar7cfg.so.1.0.0 
#	 /lib/dsld/libar7cfg.so.1 ( Symlink nach libar7cfg.so.1.0.0 )
#	 /lib/dsld/libar7cfg.so (Symlink nach libar7cfg.so.1 )
#	 /lib/dsld/dsld-wrapper.sh
#	 /sbin/dsld (Symlink nach ../lib/dsld/dsld-wrapper.sh )
