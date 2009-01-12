
This Version is adjusted for the use with speed2freetz and freetz.
There is still a problem with setting passwords, so you must do the manually.

By invoking 'passwd' as root within the black window after start.
'chmod 777 /setpw' 
and '/setpw' would do the same.

X Applications:
1.
Xming window server is usually stated via auto start!
2. 
Click start icon on desktop.
3.
Click any X Windows icon.

IMPORTANT:
don't start the X Windows to fast after start, all needs some time to settle!

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
    As workarrount set an unique MAC address for all network interfaces
    in config file. Or disable udev.
    Debian: Remove all entries from /etc/udev/rules.d/z25_persistent-net.rules

