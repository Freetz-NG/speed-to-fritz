#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- Set expert Ansicht ..."
 rpl_expert_1()
 {
	for file in $1; do
	if [ -f "$file" ]; then
	 grep -q '<? query box:settings/expertmode/activated ?>' "$file" && echo2 "  'Expert Ansicht set' in File: ${file##*/}"
	 sed -i -e 's|<? query box:settings/expertmode/activated ?>|1|' "$file"
	fi 
	done
 }
 rpl_expert_1 "$(find "${SRC}/usr/www/${OEMLINK}" -name *.html)" 
 rpl_expert_1 "$(find "${SRC}/usr/www/${OEMLINK}" -name *.js)" 


FILELIST="/html/de/system/sitemap.html \
/html/de/menus/menu2_system.html"

for FILE in $FILELIST; do
  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
    sed -i -e "/'system', 'extended'/d" "${SRC}/usr/www/${OEMLINK}/$FILE"
    echo2 "  /usr/www/${OEMLINK}/$FILE"
  fi
done



exit 0
