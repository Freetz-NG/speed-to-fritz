#!/bin/bash
. ${include_modpatch}
echo "-- fix lua 'aura' menue ..."

DIRI="$(find ${SRC}/usr/www/ \( -name settings.lua  \) -type f -print)"
for file_n in $DIRI; do
    ##echo2 "      ${DIRI}"
    sed -i -e 's/= config.DECT or.*/= false/' "$file_n"
    sed -i -e 's/not(store.aura_for_storage_aktiv()) or//' "$file_n"
    sed -i -e 's|) .> <a href="<.lua href.write("/usb/aura.lua")) .>"><.lua box.html.*</a>.|<a href="<?lua href.write("/usb/aura.lua") ?>"</a>|' "$file_n"
    sed -i -e 's/store.aura_for_storage_aktiv() or //' "$file_n"
#    sed -i -e 's/lua box.html(/lua box.out(/' "$file_n"
    sed -i -e '/store.get_storage_link("samba,ftp"/d' "$file_n"
done
exit 0

-<div <?lua if not(store.aura_for_storage_aktiv()) or store.internal_memory_available() then box.out('style="display:none;"') end ?>>
+<div <?lua if not(true)                           or store.internal_memory_available() then box.out('style="display:none;"') end ?>>

-<span>{?80:369?}) ?> <a href="<?lua href.write("/usb/aura.lua")) ?>"><?lua box.html({?80:763?}</a>.</span>
+<span>{?80:369?}     <a href="<?lua href.write("/usb/aura.lua") ?>"</a></span></div>

-<div <?lua if store.aura_for_storage_aktiv() or store.internal_memory_available() or store.check_usb_useable() then box.out('style="display:none;"') end ?>>
+<div <?lua if                                   store.internal_memory_available() or store.check_usb_useable() then box.out('style="display:none;"') end ?>>


-<span class="dt_activ"><input type="checkbox" id="uiViewInternalMemActiv" name="internal_mem_activ" onclick="onInternalMem()" title="<?lua box.html([[{?80:656?}]]) ?>" <?lua if g_ctlmgr.internalflash_enabled == "1" then box.out([[ checked ]]) end ?>></span>
+<span class="dt_activ"><input type="checkbox" id="uiViewInternalMemActiv" name="internal_mem_activ" onclick="onInternalMem()" title="<?lua box.out([[{?80:656?}]]) ?>"  <?lua if g_ctlmgr.internalflash_enabled == "1" then box.out([[ checked ]]) end ?>></span>

-<span class="dt_name"><?lua if g_ctlmgr.internalflash_enabled == "1" and store.get_storage_link("samba,ftp", [[{?80:72?}]], [[{?80:49?}]]) ~= "" then box.out(store.get_storage_link("samba,ftp", box.html([[{?80:568?}]]), box.html([[{?80:778?}]])) else box.out([[{?80:98?}]])) end ?></span>

-<span class="dt_type"><?lua box.html([[{?80:521?}]])?></span>
+<span class="dt_type"><?lua box.out([[{?80:521?}]])?></span>
