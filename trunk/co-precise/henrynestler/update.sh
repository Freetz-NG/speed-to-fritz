#!/bin/bash

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y
sleep 10
#sudo sed -i -e 's|gutsy|hardy|' "/etc/apt/sources.list"
#sudo sed -i -e 's|hardy|intrepid|' "/etc/apt/sources.list"
#sudo sed -i -e 's|intrepid|jaunty|' "/etc/apt/sources.list"
#Karmic Koala
sudo sed -i -e 's|jaunty|karmic|' "/etc/apt/sources.list"
sleep 10
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean -y

exit

apt-get install update-manager-core
do-release-upgrade -d #ohne -d 

