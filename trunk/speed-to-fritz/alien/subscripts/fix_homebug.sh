#!/bin/bash
    echo "-- Bugfix for home.js"
 #bug in home.js, courses mailfunction with tcom firmware, status page is emty
 #also it corses that fon may be not configurable
 if [ -f "${SRC}/usr/www/${OEMLINK}/html/de/home/home.js" ]; then
  grep -q 'function HasRestriction()' "${SRC}/usr/www/${OEMLINK}/html/de/home/home.js" && \
  sed -i -e '/86400) return true;/d' -e '/($3 != 0)/d' "${SRC}/usr/www/${OEMLINK}/html/de/home/home.js"
 fi