#!/bin/sh
echo "-------------------------------------------------------------------------------------------------------------"
echo
if [ `id -u` -eq 0 ]; then
		(
		echo
		echo "This script mustn't be executed with 'su' privileges."
		echo "Login as normal user!"
		echo "Speed-to-fritz must be run as normal user as well!"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		sleep 10
		exit 1
		) >&2
fi

if [ -r /etc/debian_version ]; then # Debian und Ubuntu-Derivate
		sudo apt-get -y install subversion fakeroot
# elif RedHat
# elif Suse
# elif ...
else
		(
		echo
		echo "You seem to run this script on a system that we don't know."
		echo "Try installing subversion and fakeroot on your own and"
		echo "and please report, so we are able to allow this running on your OS."
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		sleep 10
		exit 1
		) >&2
fi

set -e
svn co https://freetzlinux.svn.sourceforge.net/svnroot/freetzlinux/trunk/speed-to-fritz speed-to-fritz

if [ -d speed-to-fritz ]; then
	cd speed-to-fritz
	svn log >> info.txt
	[ -x ./install-start ] && ./install-start
	sleep 5
fi
