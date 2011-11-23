We changed the naming from freetzlinux to speedlinux.

This Version is adjusted for the use with speed-to-fritz and freetz.

X Applications:

1. Click start icon (speedlinux pinguin) on desktop, menu, ...   
	or use startup.bat found in your installation directory.
2. Wait until LINUX boot process is finished. 
		Console-NT (Donald-Duck icon), 
		Console-FTLK (Ying-Yung icon),
		watch the boot process and wait a bit.
	*	Console-NT: paste with WinKey+V
	*	Console-FTLK: Comes now with more options,
		use pulldown to see shortcuts

3. 	(Xming window server is stated after startup.bat via settings.txt)

4.	Login as normal user.
	Type in: 'p' followed by Enter key in Console(NT) or Console (FTLK) 
	to bring up a X kde menue up and start a terminal session.

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
leading hash sign to the following line within settings.txt
eth2=ndis-bridge,"LAN1", -> #eth2=ndis-bridge,"LAN1",
(pcap-bridge needs Win-Pcap installed, ndis-bridge is about the same but does not 
need Win-Pcap, and is much faster.)

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