#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- set expertview ..."


 rpl_expert_1()
 {
	for file in $1; do
	if [ -f "$file" ]; then
	grep -q 'expertmode =' "$file"&& echo2 "  'expertmode removed in file: ${file##*etc}"
	sed -i -e '/expertmode =/d' "$file" 
	sed -i -e '/webui ./a\
expertmode = yes;' "$file"
	grep -q 'webui .' "$file" ||\
	sed -i -e '/\/\/ EOF/i\
webui {\
expertmode = yes;\
}' "$file"
	grep -q 'expertmode =' "$file" && echo2 "  'in file: ${file##*etc}"
	fi 
	done
 }

rpl_expert_1 "$(find "${SRC}/etc" -name ar7.cfg)" 


#FILELIST="/html/de/system/sitemap.html \
#/html/de/home/sitemap.html \
#/html/de/menus/menu2_system.html"

#for FILE in $FILELIST; do
#  if [ -f "${SRC}/usr/www/${OEMLINK}/$FILE" ]; then 
#    sed -i -e "/'extended'/d" "${SRC}/usr/www/${OEMLINK}/$FILE"
#    echo2 "  /usr/www/${OEMLINK}/$FILE"
#  fi
#done



exit 0
