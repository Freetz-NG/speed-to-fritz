#!/bin/bash
#apt-get install rsync
#https://sourceforge.net/apps/trac/sourceforge/wiki/Shell%20service
#ssh -t jpascher,speedlinux@shell.sourceforge.net create
#Akk
#2020
#apt-get install rsync
# type sf-help at console
#find port and login and use it with windows WinSCP
#for file transfere only the lollowing line is needed, but for watching how much is allready transfered we need WinSCP:
#rsync --progress -e ssh /mnt/win/and/backup/Drives/precise-mini/precise-minimal.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/
#rsync --progress -e ssh /mnt/win/and/backup/Drives/precise-maxi/precise-maximal.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/
#rsync --progress -e ssh /mnt/win/and/backup/Drives/precise-freetz/precise-freetz.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/
#rsync --progress -e ssh /mnt/win/and/backup/Drives/jaunty-max/jaunty-max.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/
#rsync --progress -e ssh /mnt/win/and/backup/Drives/jaunty-mini/jaunty-mini.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/
rsync --progress -e ssh /mnt/win/and/backup/Drives/precise-fx-firefox/precise-fx-firefox.7z jpascher,speedlinux@frs.sourceforge.net:/home/frs/project/s/sp/speedlinux/

sleep 10
