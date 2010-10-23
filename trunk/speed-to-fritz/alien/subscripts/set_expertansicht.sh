#!/bin/bash
# include modpatch function
. ${include_modpatch}
echo "-- set expertview ..."


 rpl_expert_1()
 {
	for file in $1; do
	if [ -f "$file" ]; then
	grep -q 'expertmode =' "$file"&& echo2 "  expertmode removed in file: ${file##*etc}"
	sed -i -e '/expertmode =/d' "$file" 
	sed -i -e '/webui ./a\
expertmode = yes;' "$file"
	grep -q 'webui .' "$file" ||\
	sed -i -e '/\/\/ EOF/i\
webui {\
expertmode = yes;\
}' "$file"
	grep -q 'expertmode =' "$file" && echo2 "  in file: ${file##*etc}"
	fi 
	done
 }

rpl_expert_1 "$(find "${SRC}/etc" -name ar7.cfg)" 


exit 0
