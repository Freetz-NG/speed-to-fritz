wrtjp.5.2 -backup:custom /bypass /skipdetect /silent /window:90000000 /start:90000000 /length:20000 /fc:21
pause

:: Example: Chain with 4 devicese and instruction length 5 for each device:
:: Hir= Header Insructionregister
:: Tir= Trailer Insructionregister
:: Hdr= Header Dataregister
:: Tdr= Trailer Dataregister
::    (Hir, Tir, Hdr, Tdr)
::To program device ::1, the following parameters:
::       (15, 0, 3, 0)
::To program device ::2, the following parameters:
::       (10, 5, 2, 1)
::To program device ::3, the following parameters:
::       (5, 10, 1, 2)
::To program device ::4, the following parameters:
::       (0, 15, 0, 3)

::Example: Chain with 3 devicese and instruction length 6, 3, 5 for each device:
::    (Hir, Tir, Hdr, Tdr)
::To program device ::1, the following parameters:
::       ( 9, 0, 2, 0)
::To program device ::2, the following parameters:
::       ( 5, 6, 1, 1)
::To program device ::3, the following parameters:
::       ( 0, 8, 0, 2)


::wrtjp.5.2 -backup:custom  /skipdetect /silent /hir:9 /tir:0 /hdr:2 /tdr:0 /window:90000000 /start:90000000 /length:20000 /dv:1
::/debug2 >log
::wrtjp.5.2 -backup:custom  /skipdetect /silent /hir:0 /tir:8 /hdr:0 /tdr:2 /window:90000000 /start:90000000 /length:20000 /dv:3
::/debug2 >log
:: Not all parameter need to be specified usual /hir:X or /tir:X is sufficiant. /hir:0 /tir:0 /hdr:0 /tdr:0 is default.
::wrtjp.5.2 -backup:custom  /skipdetect /silent /hir:9 /window:90000000 /start:90000000 /length:20000
::/debug2 >log
::wrtjp.5.2 -backup:custom /skipdetect /silent /tir:8 /window:90000000 /start:90000000 /length:20000 /dv:3
::/debug2 >log
::!!!!!!!!!!!!!!!!!!!!!!::
:: If bypass Option is in use only /skipdetect /dv:X must be specified to select the decired device. /dev:1 is default.
::/debug1
::/debug2 > log
::wrtjp.5.2 -backup:custom /bypass /skipdetect /silent /window:90000000 /start:90000000 /length:20000 /dv:3
::/debug2 >log

:: Option test for checking pin assignment of adapter.
:: /test
:: Option debug2 generates a total trace step by step.
::/debug2 >log
:: Option debug1 generates trace of flasch read/writes
::/debug1 >log

::cat log | more
:: (7141 and W701 "/hir:9 /hdr:2")
:: (7050 "/hir:4 /hdr:1")


exit 0



 USAGE: wrt54g [parameter] </noreset> </noemw> </nocwd> </nobreak> </noerase>
            </notimestamp> </dma> </nodma>
            <start:XXXXXXXX> </length:XXXXXXXX>
            </silent> </skipdetect> </instrlen:XX> </fc:XX> /bypass /st5

            Required Parameter
            ------------------
            -backup:
            -backup:cfe
            -backup:nvram
            -backup:kernel
            -backup:wholeflash
            -backup:custom
            -backup:bsp
            -erase:cfe
            -erase:nvram
            -erase:kernel
            -erase:wholeflash
            -erase:custom
            -erase:bsp
            -flash:cfe
            -flash:nvram
            -flash:kernel
            -flash:wholeflash
            -flash:custom
            -flash:bsp
            -probeonly
            -probeonly:custom
                 Optional with -backup:
                       -erase:, -flash: wgrv8bdata, wgrv9bdata, cfe128

            Optional Switches
            -----------------
            /noreset ........... prevent Issuing EJTAG CPU reset
            /noemw ............. prevent Enabling Memory Writes
            /nocwd ............. prevent Clearing CPU Watchdog Timer
            /nobreak ........... prevent Issuing Debug Mode JTAGBRK
            /noerase ........... prevent Forced Erase before Flashing
            /notimestamp ....... prevent Timestamping of Backups
            /dma ............... force use of DMA routines
            /nodma ............. force use of PRACC routines (No DMA)
            /window:XXXXXXXX ... custom flash window base (in HEX)
            /start:XXXXXXXX .... custom start location (in HEX)
            /length:XXXXXXXX ... custom length (in HEX)
            /silent ............ prevent scrolling display of data
            /skipdetect ........ skip auto detection of CPU Chip ID
            /instrlen:XX ....... set instruction length manually
            /hir:XX ............ custom istruktion prefix
            /tir:XX ............ custom istruktion postfix
            /hdr:XX ............ custom data prefix
            /tdr:XX ............ custom data postfix
            /bypass ............ set bypass - not usable in every case
            /debug1 ............ display EJTAG states,
                                 only if compiled for debug
            /dedub2 ............ show all EJTAG states,
                                 only if compiled for debug
            /dedug ............. show all CPU read/write
            /test .............. manual set of ports, siglstep, ...
            /check ............. check every flash read and write
            /fc:XX = Optional (Manual) Flash Chip Selection
            /st5 ............... Use Speedtouch ST5xx flash routines
                                 instead of WRT routines
            /reboot............. sets the process and reboots
            /swap_endian........ swap endianess during backup - most
                                 Atheros based routers
            /flash_debug........ flash chip debug messages, show flash
                                 MFG and Device ID

            -----------------------------------------------
            /fc:01 ............. Spansion S25FL016A         (2MB) Serial
            /fc:02 ............. Spansion S25FL032A         (4MB) Serial
            /fc:03 ............. Spansion S25FL064A         (8MB) Serial
            /fc:04 ............. AMD 29lv160DB 1Mx16 BotB   (2MB)
            /fc:05 ............. AMD 29lv160DT 1Mx16 TopB   (2MB)
            /fc:06 ............. AMD 29lv320DB 2Mx16 BotB   (4MB)
            /fc:07 ............. AMD 29lv320DT 2Mx16 TopB   (4MB)
            /fc:08 ............. AMD 29lv320MB 2Mx16 BotB   (4MB)
            /fc:09 ............. AMD 29lv320MT 2Mx16 TopB   (4MB)
            /fc:10 ............. AMD 29lv320MT 2Mx16 TopB   (4MB)
            /fc:11 ............. Intel 28F128J3 8Mx16      (16MB)
            /fc:12 ............. Intel 28F160B3 1Mx16 BotB  (2MB)
            /fc:13 ............. Intel 28F160B3 1Mx16 TopB  (2MB)
            /fc:14 ............. Intel 28F160C3 1Mx16 BotB  (2MB)
            /fc:15 ............. Intel 28F160C3 1Mx16 TopB  (2MB)
            /fc:16 ............. Intel 28F160S3/5 1Mx16     (2MB)
            /fc:17 ............. Intel 28F320B3 2Mx16 BotB  (4MB)
            /fc:18 ............. Intel 28F320B3 2Mx16 TopB  (4MB)
            /fc:19 ............. Intel 28F320C3 2Mx16 BotB  (4MB)
            /fc:20 ............. Intel 28F320C3 2Mx16 TopB  (4MB)
            /fc:21 ............. Intel 28F320J3 2Mx16       (4MB)
            /fc:22 ............. Intel 28F320J5 2Mx16       (4MB)
            /fc:23 ............. Intel 28F320S3/5 2Mx16     (4MB)
            /fc:24 ............. Intel 28F640B3 4Mx16 BotB  (8MB)
            /fc:25 ............. Intel 28F640B3 4Mx16 TopB  (8MB)
            /fc:26 ............. Intel 28F640C3 4Mx16 BotB  (8MB)
            /fc:27 ............. Intel 28F640C3 4Mx16 TopB  (8MB)
            /fc:28 ............. Intel 28F640J3 4Mx16       (8MB)
            /fc:29 ............. Intel 28F640J5 4Mx16       (8MB)
            /fc:30 ............. MBM29LV320BE 2Mx16 BotB    (4MB)
            /fc:31 ............. MBM29LV320TE 2Mx16 TopB    (4MB)
            /fc:32 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:33 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:34 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:35 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:36 ............. SST39VF320 2Mx16           (4MB)
            /fc:37 ............. ST 29w320DB 2Mx16 BotB     (4MB)
            /fc:38 ............. ST 29w320DT 2Mx16 TopB     (4MB)
            /fc:39 ............. Sharp 28F320BJE 2Mx16 BotB (4MB)
            /fc:40 ............. TC58FVB321 2Mx16 BotB      (4MB)
            /fc:41 ............. TC58FVT321 2Mx16 TopB      (4MB)
            /fc:42 ............. AT49BV/LV16X 2Mx16 BotB    (4MB)
            /fc:43 ............. AT49BV/LV16XT 2Mx16 TopB   (4MB)
            /fc:44 ............. MBM29LV160B 1Mx16 BotB     (2MB)
            /fc:45 ............. MBM29LV160T 1Mx16 TopB     (2MB)
            /fc:46 ............. MX29LV161B 1Mx16 BotB      (2MB)
            /fc:47 ............. MX29LV161T 1Mx16 TopB      (2MB)
            /fc:48 ............. ST M29W160EB 1Mx16 BotB    (2MB)
            /fc:49 ............. ST M29W160ET 1Mx16 TopB    (2MB)
            /fc:50 ............. SST39VF1601 1Mx16 BotB     (2MB)
            /fc:51 ............. SST39VF1602 1Mx16 TopB     (2MB)
            /fc:52 ............. SST39VF3201 2Mx16 BotB     (4MB)
            /fc:53 ............. SST39VF3202 2Mx16 TopB     (4MB)
            /fc:54 ............. SST39VF6401 4Mx16 BotB     (8MB)
            /fc:55 ............. SST39VF6402 4Mx16 TopB     (8MB)
            /fc:56 ............. K8D1716UTC  1Mx16 TopB     (2MB)
            /fc:57 ............. K8D1716UBC  1Mx16 BotB     (2MB)
            /fc:58 ............. MX29LV800BTC 512kx16 TopB  (1MB)
            /fc:59 ............. MX29LV800BTC 512kx16 BotB  (1MB)
            /fc:60 ............. K8D3216UTC  2Mx16 TopB     (4MB)
            /fc:61 ............. K8D3216UBC  2Mx16 BotB     (4MB)
            /fc:62 ............. SST39VF6401B 4Mx16 BotB    (8MB)
            /fc:63 ............. SST39VF6402B 4Mx16 TopB    (8MB)
            /fc:64 ............. M29W128GH 8Mx16           (16MB)
            /fc:65 ............. MX29LV640MTTC-90G 4Mx16    (8MB)
            /fc:66 ............. MBM29DL323TE 2Mx16 TopB    (4MB)
            /fc:67 ............. MBM29DL323BE 2Mx16 BotB    (4MB)
            /fc:68 ............. AT49BV322A 2Mx16 BotB      (4MB)
            /fc:69 ............. AT49BV322A(T) 2Mx16 TopB   (4MB)
            /fc:70 ............. Atmel AT45DB161B           (2MB) Serial
            /fc:71 ............. STMicro M25P16             (2MB) Serial
            /fc:72 ............. STMicro M25P32             (4MB) Serial
            /fc:73 ............. STMicro M25P64             (8MB) Serial
            /fc:74 ............. STMicro M25P128           (16MB) Serial
            /fc:75 ............. M29DW324DT 2Mx16 TopB      (4MB)
            /fc:76 ............. M29DW324DB 2Mx16 BotB      (4MB)
            /fc:77 ............. Atmel AT45DB161B           (2MB) Serial
            /fc:78 ............. EON EN29LV160A 1Mx16 BotB  (2MB)
            /fc:79 ............. EON EN29LV160A 1Mx16 TopB  (2MB)
            /fc:80 ............. EON EN29LV640 4Mx16 TopB   (8MB)
            /fc:81 ............. EON EN29LV640 4Mx16 BotB   (8MB)
            /fc:82 ............. EON EN29LV320 2Mx16 TopB   (4MB)
            /fc:83 ............. EON EN29LV320 2Mx16 BotB   (4MB)
            /fc:84 ............. TC58FVM6T2A  4Mx16 TopB    (8MB)
            /fc:85 ............. TC58FVM6B2A  4Mx16 BopB    (8MB)
            /fc:86 ............. TC58FVT321 2Mx16 TopB      (4MB)
            /fc:87 ............. TC58FVB321 2Mx16 BotB      (4MB)
            /fc:88 ............. SST39VF320 2Mx16           (4MB)
            /fc:89 ............. Macronix MX25L160A         (2MB) Serial
            /fc:90 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:91 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:92 ............. Macronix MX25L1605D        (2MB) Serial
            /fc:93 ............. Macronix MX25L3205D        (4MB) Serial
            /fc:94 ............. Macronix MX25L6405D        (8MB) Serial
            /fc:95 ............. MX29LV160CB 1Mx16 BotB     (2MB)
            /fc:96 ............. MX29LV640MTTC-90G 4Mx16    (8MB)
            /fc:97 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:98 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:99 ............. MX29LV640B 4Mx16 TopB     (16MB)
            /fc:100 ............. MX29LV640B 4Mx16 BotB     (16MB)
            /fc:101 ............. MX29LV160CT 1Mx16 TopB     (2MB)
            /fc:102 ............. W19B(L)320SB   2Mx16 BotB  (4MB)
            /fc:103 ............. W19B(L)320ST   2Mx16 TopB  (4MB)
            /fc:104 ............. K8D1716UTC  1Mx16 TopB     (2MB)
            /fc:105 ............. K8D1716UBC  1Mx16 BotB     (2MB)
            /fc:106 ............. K8D6316UTM  4Mx16 TopB     (8MB)
            /fc:107 ............. K8D6316UBM  4Mx16 BotB     (8MB)
            /fc:108 ............. Winbond W25X32             (4MB) Serial
            /fc:109 ............. Winbond W25X64             (8MB) Serial
            /fc:110 ............. Spansion S29GL064M BotB    (8MB)
            /fc:111 ............. Spansion S29GL064M TopB    (8MB)
            /fc:112 ............. Spansion S29GL128M U      (16MB)
            /fc:113 ............. Spansion S29GL032M BotB    (4MB)
            /fc:114 ............. Spansion S29GL032M TopB    (4MB)
            /fc:115 ............. Spansion S29GL128P U      (16MB)
            /fc:116 ............. Spansion S29GL256P U      (32MB)
            /fc:117 ............. Spansion S29GL512P U      (64MB)
            /fc:118 ............. Spansion S29GL01GP U     (128MB)


 NOTES: 1) If 'flashing' - the source filename must exist as follows:
           CFE.BIN, NVRAM.BIN, KERNEL.BIN, WHOLEFLASH.BIN or CUSTOM.BIN
           BSP.BIN

        2) If you have difficulty auto-detecting a particular flash
           you can manually specify your flash type using the /fc:XX option.

        3) If you have difficulty with the older bcm47xx chips or when no CFE
           is currently active/operational you may want to try both the
           /noreset and /nobreak command line options together.  Some bcm47xx
           chips *may* always require both these options to function properly.

        4) When using this utility, usually it is best to type the command line
           out, then plug in the router, and then hit <ENTER> quickly to avoid
           the CPUs watchdog interfering with the EJTAG operations.

        5) Test option useds a subset off keys to set or toggle port lines.
           You my use single nuber keys followed by the enter key or multible
           keys followed by the enter key, in this way you produce a puttern.
           Use this to make sure the hardware is connected correcly.
           You may also us the test mode to enter the states of the tap bus.
           So you could progam a chip step by step as well, if it would not
           be to timeconsuming. But for lerning and displaying the states,
           this is usefull.
        6) /bypass - enables Unlock bypass command for some AMD/Spansion type
           flashes, it also disables polling

 .............................................................................
 If /bypass is used some off the the folllowing parameters may still be needed.
 .............................................................................
     Parameter           Name                                Description
 .............................................................................
hir   Header            The number of bits to shift before the target set of
      Instruction       instruction bits. These bits put the non-target devices
      Register          after the target device into BYPASS mode.
                        The 'hir' value must be equivalent to the sum of
                        instruction register lengths for devices following the
                        target device in the scan chain.
tir   Trailer           The number of bits to shift after the target set of
      Instruction       instruction bits. These bits put the non-target devices
      Register          before the target device into BYPASS mode.
                        The 'tir' value must be equivalent to the sum of
                        instruction register lengths for devices preceding the
                        target device in the scan chain.
hdr   Header Data       The number of (zero) bits to shift before the target set
      Register          of data bits. These bits are placeholders that fill the
                        BYPASS data registers in the non-target devices after
                        the target device. One bit for a device.
                        The 'hdr' value must be equivalent to the sum of devices
                        following the target device in the scan chain.
tdr   Trailer Data      The number of (zero) bits to shift after the target set
      Register          of data bits. These bits are placeholders that fill the
                        BYPASS data registers in the non-target devices before
                        the target device. One bit for a device.
                        The 'tdr' value must be equivalent to the sum of devices
 ***************************************************************************
 * Flashing the KERNEL or WHOLEFLASH will take a very long time using JTAG *
 * via this utility.  You are better off flashing the CFE & NVRAM files    *
 * & then using the normal TFTP method to flash the KERNEL via ethernet.   *
 ***************************************************************************

Supported CPUs:
            ---------------
            Broadcom BCM4702 Rev 1 CPU
            Broadcom BCM4704 KPBG Rev 9 CPU
            Broadcom BCM4712 Rev 1 CPU
            Broadcom BCM4712 Rev 2 CPU
            Broadcom BCM4716 Rev 1 CPU
            Broadcom BCM4785 Rev 1 CPU
            Broadcom BCM5350 Rev 1 CPU
            Broadcom BCM5352 Rev 1 CPU
            Broadcom BCM5354 KFBG Rev 1 CPU
            Broadcom BCM5354 KFBG Rev 2 CPU
            Broadcom BCM5354 KFBG Rev 3 CPU
            Broadcom BCM3345 KPB Rev 1 CPU
            Broadcom BCM5365 Rev 1 CPU
            Broadcom BCM5365 Rev 1 CPU
            Broadcom BCM6345 Rev 1 CPU
            Broadcom BCM6348 Rev 1 CPU
            Broadcom BCM6345 Rev 1 CPU
            TI AR7WRD TNETD7200ZWD Rev 1 CPU
            TI AR7WRD TNETD7200ZWD Rev 1 CPU
            Broadcom BCM6338 Rev 1 CPU
            Broadcom BCM6358 Rev 1 CPU
            Broadcom BCM6368 Rev 1 CPU
            Broadcom BCM4321 RADIO STOP
            Broadcom BCM4321L RADIO STOP
            BRECIS MSP2007-CA-A1 CPU
            TI TNETV1060GDW CPU
            Linkstation 2 with RISC K4C chip
            Atheros AR531X/231X CPU
            XScale IXP42X 266mhz
            XScale IXP42X 400mhz
            XScale IXP42X 533mhz
            ARM 940T
            Marvell Feroceon 88F5181
            LX4380
            XC3S100E FPGE
            XC3S250E FPGE
            XC3S500E FPGE
            XC3S1200E FPGE
            Spartan-3 FPGA
            XC3S1600E FPGE
            0B6C002F ?????
            Broadcom BCM4704 Rev 8 CPU
            BRECIS MSP2007-CA-A1 CPU
            XCF0xS Platform Flash

