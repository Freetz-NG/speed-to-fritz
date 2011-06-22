#!/bin/bash
if ! [ -f "./link.lst" ]; then
	cat ./Config.in > ./link.lst
	sed -i -e '1,/--- General settings for Speed-to-fritz ---/ s/.*//' -e '/---     Config or Menu    ---/,$ s/.*//g' -e 's/#.*//' -e '/^$/d' "./link.lst"
	sed -i -e 's/^.*default//' -e 's/^.*config *//' -e 's/^ *//' -e '/string/d' -e '/mainmenu/d' -e '/comment/d' -e 's|^"|="|' "./link.lst"
	sed -i -e '$!N;s/\n//' "./link.lst" 	# join two lines
fi
if ! grep -q  '@AVM' ./Firmware.conf && ! grep -q  -e 'http://'  ./Firmware.conf ;then
	mv "./Firmware.conf" "./Firmware.conf.1"
	echo "#!/bin/sh" > "./Firmware.conf"
        cat ./link.lst >> ./Firmware.conf
	cat ./Firmware.conf.1 >> ./Firmware.conf
	rm ./Firmware.conf.1
fi
