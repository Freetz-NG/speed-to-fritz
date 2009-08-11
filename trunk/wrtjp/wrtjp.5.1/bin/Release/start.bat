wrtjp.5.1 -backup:custom /bypass /skipdetect /silent /window:90000000 /start:90000000 /length:20000 /fc:21
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


::wrtjp.5.1 -backup:custom  /skipdetect /silent /hir:9 /tir:0 /hdr:2 /tdr:0 /window:90000000 /start:90000000 /length:20000 /dv:1
::/debug2 >log
::wrtjp.5.1 -backup:custom  /skipdetect /silent /hir:0 /tir:8 /hdr:0 /tdr:2 /window:90000000 /start:90000000 /length:20000 /dv:3
::/debug2 >log
:: Not all parameter need to be specified usual /hir:X or /tir:X is sufficiant. /hir:0 /tir:0 /hdr:0 /tdr:0 is default.
::wrtjp.5.1 -backup:custom  /skipdetect /silent /hir:9 /window:90000000 /start:90000000 /length:20000
::/debug2 >log
::wrtjp.5.1 -backup:custom /skipdetect /silent /tir:8 /window:90000000 /start:90000000 /length:20000 /dv:3
::/debug2 >log
::!!!!!!!!!!!!!!!!!!!!!!::
:: If bypass Option is in use only /skipdetect /dv:X must be specified to select the decired device. /dev:1 is default.
::/debug1
::/debug2 > log
::wrtjp.5.1 -backup:custom /bypass /skipdetect /silent /window:90000000 /start:90000000 /length:20000 /dv:3
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

           "            /hir:XX............. custom instruktion prefix\n"
           "            /tir:XX............. custom instruktion postfix\n"
           "            /hdr:XX............. custom data prefix\n"
           "            /tdr:XX............. custom data postfix\n"
           "            /bypass ............ set bypass - not usable in every case \n"
           "            /debug ............. display states\n"
           "            /dedub2 ............ show all clockstates\n"
           "            /dedub1 ............ show all CPU read/write\n"
           "            /test .............. manual set of port\n"


            /fc:XX = Optional (Manual) Flash Chip Selection
            -----------------------------------------------
            /fc:01 ............. AMD 29lv160DB 1Mx16 BotB   (2MB)
            /fc:02 ............. AMD 29lv160DT 1Mx16 TopB   (2MB)
            /fc:03 ............. AMD 29lv320DB 2Mx16 BotB   (4MB)
            /fc:04 ............. AMD 29lv320DT 2Mx16 TopB   (4MB)
            /fc:05 ............. AMD 29lv320MB 2Mx16 BotB   (4MB)
            /fc:06 ............. AMD 29lv320MT 2Mx16 TopB   (4MB)
            /fc:07 ............. AMD 29lv320MT 2Mx16 TopB   (4MB)
            /fc:08 ............. Intel 28F128J3 8Mx16       (16MB)
            /fc:09 ............. Intel 28F160B3 1Mx16 BotB  (2MB)
            /fc:10 ............. Intel 28F160B3 1Mx16 TopB  (2MB)
            /fc:11 ............. Intel 28F160C3 1Mx16 BotB  (2MB)
            /fc:12 ............. Intel 28F160C3 1Mx16 TopB  (2MB)
            /fc:13 ............. Intel 28F160S3/5 1Mx16     (2MB)
            /fc:14 ............. Intel 28F320B3 2Mx16 BotB  (4MB)
            /fc:15 ............. Intel 28F320B3 2Mx16 TopB  (4MB)
            /fc:16 ............. Intel 28F320C3 2Mx16 BotB  (4MB)
            /fc:17 ............. Intel 28F320C3 2Mx16 TopB  (4MB)
            /fc:18 ............. Intel 28F320J3 2Mx16       (4MB)
            /fc:19 ............. Intel 28F320J5 2Mx16       (4MB)
            /fc:20 ............. Intel 28F320S3/5 2Mx16     (4MB)
            /fc:21 ............. Intel 28F640B3 4Mx16 BotB  (8MB)
            /fc:22 ............. Intel 28F640B3 4Mx16 TopB  (8MB)
            /fc:23 ............. Intel 28F640C3 4Mx16 BotB  (8MB)
            /fc:24 ............. Intel 28F640C3 4Mx16 TopB  (8MB)
            /fc:25 ............. Intel 28F640J3 4Mx16       (8MB)
            /fc:26 ............. Intel 28F640J5 4Mx16       (8MB)
            /fc:27 ............. MBM29LV320BE 2Mx16 BotB    (4MB)
            /fc:28 ............. MBM29LV320TE 2Mx16 TopB    (4MB)
            /fc:29 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:30 ............. MX29LV320B 2Mx16 BotB      (4MB)
            /fc:31 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:32 ............. MX29LV320T 2Mx16 TopB      (4MB)
            /fc:33 ............. SST39VF320 2Mx16           (4MB)
            /fc:34 ............. ST 29w320DB 2Mx16 BotB     (4MB)
            /fc:35 ............. ST 29w320DT 2Mx16 TopB     (4MB)
            /fc:36 ............. Sharp 28F320BJE 2Mx16 BotB (4MB)
            /fc:37 ............. TC58FVB321 2Mx16 BotB      (4MB)
            /fc:38 ............. TC58FVT321 2Mx16 TopB      (4MB)
            /fc:39 ............. AT49BV/LV16X 2Mx16 BotB    (4MB)
            /fc:40 ............. AT49BV/LV16XT 2Mx16 TopB   (4MB)
            /fc:41 ............. MBM29LV160B 1Mx16 BotB     (2MB)
            /fc:42 ............. MBM29LV160T 1Mx16 TopB     (2MB)
            /fc:43 ............. MX29LV161B 1Mx16 BotB      (2MB)
            /fc:44 ............. MX29LV161T 1Mx16 TopB      (2MB)
            /fc:45 ............. ST M29W160EB 1Mx16 BotB    (2MB)
            /fc:46 ............. ST M29W160ET 1Mx16 TopB    (2MB)
            /fc:47 ............. SST39VF1601 1Mx16 BotB     (2MB)
            /fc:48 ............. SST39VF1602 1Mx16 TopB     (2MB)
            /fc:49 ............. SST39VF3201 2Mx16 BotB     (4MB)
            /fc:50 ............. SST39VF3202 2Mx16 TopB     (4MB)
            /fc:51 ............. SST39VF6401 4Mx16 BotB     (8MB)
            /fc:52 ............. SST39VF6402 4Mx16 TopB     (8MB)
            /fc:53 ............. K8D1716UTC  1Mx16 TopB     (2MB)
            /fc:54 ............. K8D1716UBC  1Mx16 BotB     (2MB)
            /fc:55 ............. MX29LV800BTC 512kx16 TopB  (1MB)
            /fc:56 ............. MX29LV800BTC 512kx16 BotB  (1MB)
            /fc:57 ............. K8D3216UTC  2Mx16 TopB     (4MB)
            /fc:58 ............. K8D3216UBC  2Mx16 BotB     (4MB)
            /fc:59 ............. SST39VF6401B 4Mx16 BotB    (8MB)
            /fc:60 ............. SST39VF6402B 4Mx16 TopB    (8MB)
            /fc:61 ............. M29W128GH 8Mx16           (16MB)
