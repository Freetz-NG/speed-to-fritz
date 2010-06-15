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

3. Click any X Windows icon.
	(Xming window server is stated after startup.bat via settings.txt)
	Or type in: 'konsole' followed by Enter key in Console(NT) or Console (FTLK) 
	to bring up a X konsole.

4.	Login as normal user.

Type in: ./download_speed-to-fritz.sh followed by Enter key,
	to download  and start the latest speed-to-fritz version.

Type in: ./freetz.sh followed by Enter key, 
	to download and start freetz.

(Some updates and installations will run once, if the above skrits are invoked.)

ATTENTION!
Make sure that you already have a physical LAN connection up running with a link
to a router or the internet.
If you get: could no connect to 192.168.11.150 :2081, then restart LINUX,
and give a bit more time before you start any X Application.
If X-Applications cant be started, do a reinstallation by reinvoking the installation.
Do a restart of the PC bevore reinvoking the installation.
Make sure TAP was installed propper, it returns 0 if it worked.

LAN connectivity:
If your Windows physical LAN connection to the internet is not named 'LAN1'
then you must rename your Windows physical connection 'LAN1'
or you may change the name in settings.txt.
You can disable the bridge connection to the Internet if you add a 
leading hash sign to the following line within settings.txt
eth2=ndis-bridge,"LAN1", -> #eth2=ndis-bridge,"LAN1",
This makes eth0 unusable with dhcp, and pings will not be possible.
(WLAN could also be used, but it must be bridged in your windows network settings.)
(pcap-bridge needs Win-Pcap installed, ndis-bridge is about the same but does not 
need Win-Pcap, and is much faster.)

On the LINUX system setup did make changes, in /etc/network/interfaces
eth0 is set to: dhcp
eth2 is set to: 192.168.178.10

* If you dont want to use all core CPUs,
disable the following line in startup.bat by adding the "::"
::set COLINUX_NO_CPU0_WORKAROUND=Y
(Some PC need this changed, to get coLinux working.) 
Maximum CPU usage is 50% even all core CPUs are in use.

Changes since 05.05.2009:
base.drv is now called base.vdi
This was done to be compatible to andLinux beta2 final

coLinux kernelversion is now 2.6.33.5, but dont worry 
coLinux kernel version must not be the same as the kernelversion 
usual used on the system installed.
