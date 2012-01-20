We changed the naming from freetzlinux to speedlinux.

All Version are useabel for speed-to-fritz and freetz.

Get started:

1. Click icon (speedlinux) on desktop, menu, quick lounch   
	or use startup.bat found in your installation directory.
2. Wait until LINUX boot process is finished. 
		Console-NT (Donald-Duck icon), 
		Console-FTLK (Ying-Yung icon),
		watch the boot process.
	*	Console-NT: paste with WinKey+V
	*	Console-FTLK: Comes with more options,
		use pulldown to see shortcuts

3. 	(Xming window server and pulseaudio sound server 
	is automaticaly stated via settings.txt.

4.	Login as normal user.
	Type in: 'p' followed by Enter key in Console(NT) or Console (FTLK) 
	to bring up a XFCE4 menu and start a terminal session.

	Depending on the image in uses this may vary.
	Read the README.XXX on sourceforge.net to the image in use.
	The installer presents a page where
	one can select the image for download, there is also a link to each 
	Image that brings up the README.XXX within the internet explorer. 
	Or on:
	http://sourceforge.net/projects/speedlinux/files/[subfolder named like the image]
	You also finnd the corresponding README.XXX file.

	'termianl' or 'konsole' shuld always be usabel.

Type in: 'cd Desktop'

Type in: './download_speed-to-fritz.sh' followed by Enter key,
	to download  and start the latest speed-to-fritz version.

Or type in: './freetz.sh' followed by Enter key, 
	to download and start freetz.

(Some updates and installations will run once, if the above scripts are invoked.)

ATTENTION!

Make sure that you already have a physical LAN connection up running with a link
to a router or the internet.

LAN connectivity:
If your Windows physical LAN connection to the internet is not named 'LAN1'
then you must rename your Windows physical connection 'LAN1'
or you may change the name in settings.txt.
You can disable the bridge connection to the Internet if you add a 
leading hash sign to the following line within [Installdir]\settings.txt
eth2=ndis-bridge,"LAN1", -> #eth2=ndis-bridge,"LAN1",
(pcap-bridge needs Win-Pcap installed, ndis-bridge is about the same but does not 
need Win-Pcap, and is much faster.)
Read documetation for mor info on the subject.
http://wiki.ip-phone-forum.de/skript:technische_beschreibug_von_freetzlinux

* If you dont want to use 2nd CPU core,
disable the following line in startup.bat by adding the "::"
::set COLINUX_NO_CPU0_WORKAROUND=Y
(Some PC need this changed, to get coLinux working.) 
Maximum CPU usage is 50%, even all core CPUs are in use.

Changes since 05.05.2009:
base.drv is now called base.vdi
This was done to be compatible to andLinux beta2 final

Changes 06.06.2011
coLinux kernelversion is now 2.7.10, but dont worry
coLinux kernel version must not be the same as the kernelversion 
used on the system installed.

18.11.11
Ubuntu presice is now in use.

23.12.11
Default NET for eth1 changed to 192.168.0.0, because if WLAN is in use,
Windows Vista sets the virtual adapter to 192.168.0.1.
Read info on http://wiki.ip-phone-forum.de/freetzlinux:network

15.01.12 Version 3118
Fixed Xming related bugs, allredy instlled Xming my now be used.
German console key layout my now be disabled, follow link on install page for more details.

