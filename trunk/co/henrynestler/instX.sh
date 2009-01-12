#!/bin/sh
#xfontsel
#mkfontdir
#exit
#sudo apt-get update
#apt-get install xorg-X11
#dpkg reconfigure-xserver xorg

#Okay, an dieser Stelle htte ich noch etwas suchen und ausprobieren knnen. 
#Allerdings finde ich Radikallsungen manchmal einfach effektiver - und vor allem schneller: 
#Eine Neuinstallation des XServers musste her.
#funktioniert nicht
sudo dpkg-reconfigure xserver-xorg 

apt-get remove xorg xserver-xorg-core xserver-xorg

apt-get install xorg xserver-xorg-core xserver-xorg

#sudo apt-get --fix-missing install xfs
exit
sudo apt-get update
sudo apt-get install openssh-server
sudo apt-get install blackbox bbappconf bbdate bbkeys bbmail bbpager bbppp bbrun bbsload bbtime
sudo apt-get install tightvncserver
sudo rm /etc/alternatives/x-window-manager
sudo ln -s /usr/bin/blackbox /etc/alternatives/x-window-manager
tightvncserver
