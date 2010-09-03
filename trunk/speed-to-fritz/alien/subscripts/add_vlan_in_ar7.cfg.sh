#!/bin/bash
# include modpatch function
. ${include_modpatch}
cp -f "${SRC}/etc/default.${CONFIG_PRODUKT}/tcom/ar7.cfg" "${SRC}/etc/default.${CONFIG_PRODUKT}/avm/ar7.cfg"
rpl_vlan()
 {
	for file in $1; do
	if [ -f "$file" ]; then
	sed -i -e '/ppptarget = "internet";/,/}/{s/pppoevlanauto =.*;/pppoevlanauto = yes;/}' "$file" 
	sed -i -e '/ppptarget = "internet";/,/}/{s/pppoevlanauto_startwithvlan =.*;/pppoevlanauto_startwithvlan = yes;/}' "$file" 
	sed -i -e '/dsl_encap = dslencap_mixed;/,/}/{s/vlanencap =.*;/vlanencap = vlanencap_class_prio;/}' "$file" 
	sed -i -e '/dsl_encap = dslencap_mixed;/,/}/{s/vlanid =.*;/vlanid = 10;/}' "$file" 
	sed -i -e '/dsl_encap = dslencap_mixed;/,/}/{s/vlanprio =.*;/vlanprio = 1;/}' "$file" 
#	sed -i -e '/dsl_encap = dslencap_mixed;/,/}/{s/vlanencap =.*;/vlanencap = vlanencap_tcom;/}' "$file" 
#	sed -i -e '/vlanencap_tcom/,/}/{s/vlanid =.*;/vlanid = 7;/}' "$file" 

	grep -q 'vlanencap = vlanencap_class_prio;' "$file" && echo "-- set vlan in ${file##*etc}..."
	grep -q 'vlanencap = vlanencap_class_prio;' "$file" && echo2 "  -- set vlanencap = vlanencap_class_prio;"
	grep -q 'vlanid = 10' "$file" && echo2 "  -- set vlanid = 10"
	grep -q 'vlanprio = 1' "$file" && echo2 "  -- set vlanprio = 1"
	grep -q 'pppoevlanauto = yes' "$file" && echo2 "  -- set pppoevlanauto = yes"
	grep -q 'pppoevlanauto_startwithvlan = yes' "$file" && echo2 "  -- set pppoevlanauto_startwithvlan = yes"
	grep -q 'vlanencap = vlanencap_tcom' "$file" && echo2 "  -- set  vlanencap = vlanencap_tcom"
	grep -q 'vlanid = 7;' "$file" && echo2 "  -- set  vlanid = 7"
	fi 
	done
 }

rpl_vlan "$(find "${SRC}/etc" -name ar7.cfg)" 
