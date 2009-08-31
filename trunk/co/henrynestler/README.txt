This Version is adjusted for the use with speed-to-fritz and freetz.
Login as normal user first.
Use ./download_speed-to-fritz.sh to start the latest speed-to-fritz version.
Use ./freetz.sh to start the stable freetz version.

ATTENTION!
Make sure that you already have a physical LAN connection up running with a link to the router,
because there is a bug that blocks all activity if this is not the case.

LAN connectivity:
You can disable the bridge connection to the Internet if you add a leading hash sign to
the following line within andlinux/settings.txt
eth2=ndis-bridge,"LAN1", -> #eth2=ndis-bridge,"LAN1",
This makes eth0 unusable with dhcp, and pings via LAN1 will not be possible.
(WLAN could also be used, but it must be bridged inside windows.)

pcap-bridge needs Win-Pcap installed. ndis-bridge is about the same but does not need Win-Pcap.

In /etc/network/interfaces
eth0 is set to: dhcp
eth2 is set to: 192.168.178.10
You must rename your Windows physical LAN connection to 'LAN1' if the install script could not do it.
* If you dont want to use all core CPUs
Disanable the following line in andlinux/startup.bat by adding the "::"
::set COLINUX_NO_CPU0_WORKAROUND=Y

X Applications:
1. Click start icon on desktop or andlinux/startup.bat.
2. Wait until LINUX boot is finished. You can use Console-NT or Console-FTLK to watch the boot process.
    *  console-nt: paste with WinKey+V
3. Click any X Windows icon.
(Xming window server is usually also stated via settings.txt)

Some changes since 05.05.2009 base.drv is now called base.vdi
This was done to be compatible to andLinux beta2 final
