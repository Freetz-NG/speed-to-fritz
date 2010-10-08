#!/bin/bash
if [ `id -u` -ne 0 ]; then
	export FAKEROOT_ON="y"
		echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"
else
	export FAKEROOT_ON="n"
		echo "ATTENTION! Normaly you should not run this skrit as root!"
		echo "If you do for some reason, keep in mind that once run as root"
		echo "a second time run as normal user will result in errors."
fi
# Commandline
export cml="$0"
export Options="$*"
##########################################################################
# Date of current version:
# TODO: LC_ALL= LANG= LC_TIME= svn info . | awk '/^Last Changed Date: / {print $4}'
#dont chang this line formwat is used in ./start to get script version into Firmware.conf
Tag="08"; Monat="10"; Jahr="10"
export SKRIPT_DATE="$Tag.$Monat.$Jahr"
export SKRIPT_DATE_ISO="$Jahr.$Monat.$Tag"
export SKRIPT_REVISION="$Jahr$Monat$Tag"
export MODVER="${SKRIPT_DATE}-multi"
##########################################################################
TOOLS_SUBDIR="tools"
export TOOLS_DIR="./${TOOLS_SUBDIR}"
FAKEROOT_TOOL="fakeroot"
FAKEROOT_DESTDIR="${TOOLS_DIR}/usr"
FAKEROOT_BIN_DIR="${FAKEROOT_DESTDIR}/bin"
FAKEROOT_LIB_DIR="${FAKEROOT_DESTDIR}/lib"
FAKEROOT="${FAKEROOT_BIN_DIR}/${FAKEROOT_TOOL}"
sed -i -e "s|^PREFIX=.*$|PREFIX=${FAKEROOT_DESTDIR}|g" ${FAKEROOT}
sed -i -e "s|^BINDIR=.*$|BINDIR=${FAKEROOT_BIN_DIR}|g" ${FAKEROOT}
sed -i -e "s|^PATHS=.*$|PATHS=${FAKEROOT_LIB_DIR}|g" ${FAKEROOT}

### -z tells speed to fritz not to use commandline options
if [ "$FAKEROOT_ON" == "y" ]; then 
 [ ! -x "$FAKEROOT" ] && echo  "cannot find the tool $FAKEROOT_TOOL" && sleep 10 && exit 1
 $FAKEROOT ./sp-to-fritz.root.sh -z $*
else
 ./sp-to-fritz.root.sh -z $*
fi
