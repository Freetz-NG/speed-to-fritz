#!/bin/bash
VERZEICHNISS1="./1"
VERZEICHNISS2="./2"
DESTPATH_UND_NAME=""
PATCHFILE_NAME="0.patch"
#----------------------------------------------------------------

diff -Naur "$VERZEICHNISS1" "$VERZEICHNISS2" > ./$PATCHFILE_NAME

#sed -i -e "s|||g" ./$PATCHFILE_NAME

sed -i -e "s|$VERZEICHNISS1|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
sed -i -e "s|$VERZEICHNISS2|$DESTPATH_UND_NAME|g" ./$PATCHFILE_NAME
sed -i -e "/diff/d" ./$PATCHFILE_NAME

sleep 3
