#!/bin/bash
#!/bin/bash
echo "-------------------------------------------------------------------------------------------------------------"
echo
if [ `id -u` -eq 0 ]; then
 clear
  echo
  echo "This script needs to be executed without 'su' privileges."
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  sleep 10
  exit 0
fi

#apt-get -y install subversion 
svn co https://svn.code.sf.net/p/freetzlinux/code/trunk/co trunk/co
#cd trunk/co/henrynestler
#./s.sh
sleep 5
