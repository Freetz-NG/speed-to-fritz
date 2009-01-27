#!/bin/bash
#!/bin/bash
echo "-------------------------------------------------------------------------------------------------------------"
echo
if ! [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed with 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi

apt-get -y install subversion 
svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk/co /trunk/co
cd /trunk/co/henrynestler
./start.sh
sleep 5
