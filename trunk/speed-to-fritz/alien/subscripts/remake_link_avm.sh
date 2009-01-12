#!/bin/bash
if [ -d "$1"/usr/www/all ] ; then
    [ -L "$1"/usr/www/avm ] && rm -fd -R "$1"/usr/www/avm
    ln -s all "$1"/usr/www/avm
fi
exit 0




