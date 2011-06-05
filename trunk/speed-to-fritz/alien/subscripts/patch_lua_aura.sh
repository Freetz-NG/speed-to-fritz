#!/bin/bash
. ${include_modpatch}
echo "-- fix lua 'aura' menue ..."
DIRI="$(find ${SRC}/usr/www/ \( -name settings.lua  \) -type f -print)"
for file_n in $DIRI; do
    sed -i -e 's|. .> <a href="<.lua href.write."/usb/aura.lua".. .>"><.lua box.html.|<a href="<?lua href.write("/usb/aura.lua") ?>">box.html|' "$file_n"
    sed -i -e 's|}</a>.</span>|}</a></span>|' "$file_n"
    sed -i -e 's|box.out(store.get_storage_link("samba,ftp", box.html.....80:568....., box.html.....80:778...... else box.out.....80:98......|box.out(store.get_storage_link("samba,ftp", [[{?80:568?}]], [[{?80:778?}]])) else box.out([[{?80:98?}]])|' "$file_n"
done
exit 0
