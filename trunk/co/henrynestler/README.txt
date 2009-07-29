This Version is adjusted for the use with speed2fritz and freetz.

Some changes since 05.05.2009 base.drv is now called base.vdi
This was done to be compatible to andLinux beta2 final

LAN connectivity:
You can enable a bridge connection to the Internet if you remove the leading hash sign from
the following line within andlinux/settings.txt
#eth2=ndis-bridge,"LAN1", -> eth2=ndis-bridge,"LAN1",
This will make eth0 usable with dhcp, and pings via LAN1 will be possible, but not via WLAN.
WLAN could also be used, but it must be bridged inside windows

pcap-bridge needs Win-Pcap installed. ndis-bridge is about the same but does not need Win-Pcap.

In /etc/network/interfaces
eth0 is set to: dhcp
eth2 is set to: 192.168.178.10
You must rename your Windows physical LAN connection to 'LAN1' if the install script could not do it.
ATTENTION!
If you enable eth2, then make sure that you already have a physical LAN connection up running with a link to the router,
because there is a bug that blocks all activity if this is not the case.

* If you want to use all core CPUs
Enable the following line in andlinux/startup.bat by removing the "::"
::set COLINUX_NO_CPU0_WORKAROUND=Y

X Applications:
1. Click start icon on desktop or andlinux/startup.bat.
2. Wait until LINUX boot is finished. You can use Console Console-NT or Console-FTLK to watch the boot process.
    *  console-nt: paste with WinKey+V
3. Click any X Windows icon.
(Xming window server is usually also stated via settings.txt)

IMPORTANT:
Resizing Images takes 15 minutes or much longer depending on the size.

----------------------------------------------------------------------------
Cooperative Linux 0.8.0 README
----------------------------------------------------------------------------
  Instructions for running Cooperative Linux for Windows (see source for
how to build and run coLinux for Linux)

WARNING:

  Although Cooperative Linux may be actually useful on some setups
(e.g, stable setups), it is still meant for testing purposes only.
This means that running it may crash the host (Windows or Linux system).

  PLEASE REPORT and read about problems on the colinux-devel@sourceforge.net
mailing list or file an Bug report at
http://www.sourceforge.net/projects/colinux

NOTES ON UPGRADING:

 Upgrading from coLinux 0.7.2 and before
 -- Some dev distries increase eth1, eth2, eth3, ... on every boot.
    Typicaly have no network, but can see it with "cat /proc/net/dev".
    As workaround set an unique MAC address for all network interfaces
    in config file. Or disable udev.
    Debian: Remove all entries from /etc/udev/rules.d/z25_persistent-net.rules