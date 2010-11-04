// **************************************************************************
//
//  WRT54G.C - WRT54G/GS AVM Speedport EJTAG Debrick Utility  v5.2
//
//  Note:
//  This program is for De-Bricking the WRT54G/GS, AVM, Speedport
//  and other misc routers.
//
//  New for v5.2 - Added all Tornado Options:
//               - See changelog.txt for more details
//  New for v5.1 - Added 1 new Flash types to the list:
//               - /check ............. do check flash write
//				 - fix segmetation fault in PrAcc routine,
//				   happend if wrong adresses ware read.
//  New for v5.0 - bugfix
//  New for v4.9 - Added 2 new Flash types to the list:
//               - /dedug1 ............ show CPU state
//               - /dedug2 ............ show all clockstates
//               - /test .............. manual test of ports
// Replaced port routines with the one from xilinx Application note.
// http://www.xilinx.com/support/documentation/application_notes/xapp058.pdf
// http://www.xilinx.com/support/documentation/application_notes/xapp424.pdf
// See also:
// ftp://ftp.xilinx.com/pub/swhelp/cpld/eisp_pc.zip
//
//
//  New for v4.8 - Added 2 new Flash Chip Parts to the list:
//                     - SST39VF6401B 4Mx16 BotB     (8MB)
//                     - SST39VF6402B 4Mx16 TopB     (8MB)
//               - Added the following New Switch Options
//                     - /wiggler ........... use wiggler
//
//  New for v4.7 - Added 2 new Flash Chip Parts to the list:
//                     - K8D3216UTC  2Mx16 TopB     (4MB)
//                     - K8D3216UBC  2Mx16 BotB     (4MB)
//
//  New for v4.6 - Added Common Flash Chip Polling routine
//               - Added "-probeonly" parameter (good idea jmranger)
//               - Added Chip ID for Broadcom BCM4704 Rev 8 CPU
//               - Added TRST Signal Support for Wiggler Cables
//               - Added Chip ID for BRECIS MSP2007-CA-A1 CPU
//               - Added Experimental 1MB Flash Chip Offsets
//               - Added 2 new Flash Chip Parts to the list:
//                     - MX29LV800BTC 512kx16 TopB  (1MB)
//                     - MX29LV800BTC 512kx16 BotB  (1MB)
//
//  New for v4.5 - Added 2 new Flash Chip Parts to the list:
//                     - K8D1716UTC 1Mx16 TopB      (2MB)
//                     - K8D1716UBC 1Mx16 BotB      (2MB)
//
//  New for v4.4 - Added PrAcc routines to support additional MIPS chips
//                 without the ability to use EJTAG DMA Access
//               - Added Chip ID for Broadcom BCM5365 Rev 1 CPU
//               - Added Chip ID for Broadcom BCM6348 Rev 1 CPU (Big Endian)
//               - Added Chip ID for Broadcom BCM6345 Rev 1 CPU
//               - Added 6 new Flash Chip Parts to the list:
//                     - SST39VF1601 1Mx16 BotB     (2MB)
//                     - SST39VF1602 1Mx16 TopB     (2MB)
//                     - SST39VF3201 2Mx16 BotB     (4MB)
//                     - SST39VF3202 2Mx16 TopB     (4MB)
//                     - SST39VF6401 4Mx16 BotB     (8MB)
//                     - SST39VF6402 4Mx16 TopB     (8MB)
//               - Added the following New Switch Options
//                     - /noemw ............. prevent Enabling Memory Writes
//                     - /nocwd ............. prevent Clearing CPU Watchdog Timer
//                     - /dma ............... force use of DMA routines
//                     - /nodma ............. force use of PRACC routines (No DMA)
//                     - /window:XXXXXXXX ... custom flash window base (in HEX)
//                     - /start:XXXXXXXX .... custom start location (in HEX)
//                     - /length:XXXXXXXX ... custom length (in HEX)
//                     - /silent ............ prevent scrolling display of data
//                     - /skipdetect ........ skip auto detection of CPU Chip ID
//                     - /instrlen:XX ....... set instruction length manually
//               - Added elapsed time to Backup, Erase, and Flash routines
//               - Other minor miscellaneous changes/additions.
//
//  New for v4.3 - Corrected Macronix Flash Chip Block Definitions.
//               - Add 8 new Flash Chip Parts to the list:
//                     - AT49BV/LV16X 2Mx16 BotB    (4MB)
//                     - AT49BV/LV16XT 2Mx16 TopB   (4MB)
//                     - MBM29LV160B 1Mx16 BotB     (2MB)
//                     - MBM29LV160T 1Mx16 TopB     (2MB)
//                     - MX29LV161B 1Mx16 BotB      (2MB)
//                     - MX29LV161T 1Mx16 TopB      (2MB)
//                     - ST M29W160EB 1Mx16 BotB    (2MB)
//                     - ST M29W160ET 1Mx16 TopB    (2MB)
//
//  New for v4.2 - Changed the chip_detect routine to allow for easier
//                 additions of new chip id's.
//               - Added detection support for the Broadcom BCM5350 chip.
//               - Fixed DMA routines to check status bit that was
//                 removed in prior version.
//               - Removed clockout routine in an effort to speed up access.
//               - Changed clockin routine in an effort to speed up access.
//               - Changed ReadData and WriteData routines to merely call
//                 ReadWriteData routine.
//               - Removed Defines from .h file and placed flash areas in a
//                 structure list for easier maintenance should they change.
//               - Miscellaneous other minor changes.
//
// **************************************************************************
//  Written by HairyDairyMaid (a.k.a. - lightbulb)
//  hairydairymaid@yahoo.com
//  tornado@odessaua.com tornado@dd-wrt.com
//  Version 4.9 to 5.2 by johann.pascher at gmail.com
// **************************************************************************
//
//  This program is copyright (C) 2004 HairyDairyMaid (a.k.a. Lightbulb)
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of version 2 the GNU General Public License as published
//  by the Free Software Foundation.
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//  To view a copy of the license go to:
//  http://www.fsf.org/copyleft/gpl.html
//  To receive a copy of the GNU General Public License write the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//
// **************************************************************************
//#include <ctype.h>
#include <stdio.h>
//#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "wrt54g.h"
//#include "lenval.h"
//#include "lenval.c"
//#include "ports.h"
#include "ports.c"
//#include "micro.h"
//#include "micro.c"
#include <inttypes.h>
#include <ctype.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>
#include "spi.h"
// Default is Compile for Linux (both #define's below should be commented out)
//#define WINDOWS_VERSION   // uncomment only this for Windows Compile / MS Visual C Compiler
//#define __FreeBSD__       // uncomment only this for FreeBSD
#ifdef WINDOWS_VERSION
#include <windows.h>      // Only for Windows Compile
#define strcasecmp  stricmp
#define strncasecmp strnicmp
#include <conio.h>
#define _CRT_SECURE_NO_WARNINGS
#endif
#ifdef WINDOWS_VERSION
#define tnano(seconds) Sleep((seconds) / 1000000)
#define tmicro(seconds) Sleep((seconds) * 1000)
/* Windows sleep is milliseconds, time/1000000 gives us nanoseconds */
#else
//ulseep is in microseconds
#define tnano(seconds) sleep((seconds) / 1000000000)
#define tmicro(seconds) usleep(seconds)
#endif
static unsigned int ctrl_reg;
//int instruction_length;
unsigned int instruction;
int issue_reset      = 1;
int issue_reboot     = 0;
int issue_enable_mw  = 1;
int issue_watchdog   = 1;
int issue_break      = 1;
int issue_erase      = 1;
int issue_timestamp  = 1;
int force_dma        = 0;
int force_nodma      = 0;
int selected_fc      = 0;
unsigned int selected_window  = 0;
unsigned int selected_start   = 0;
unsigned int selected_length  = 0;
int custom_options   = 0;
int silent_mode      = 0;
int skipdetect       = 0;
int instrlen         = 0;
int instruction_length = 0;
int instr_l          = 0;
int debug 	     = 0;
int debug1	     = 0;
int debug2	     = 0;
int repeat 	     = 0;
int clkcount 	     = 0;
int test 	     = 0;
int check 	     = 0;
int wiggler          = 0;
int old	         = 0;
int ChainLength  = 0;
int setBypass    = 0;
int selected_tir = 0;
int selected_hir = 0;
int selected_hdr = 0;
int selected_tdr = 0;
int tir = 0;
int hir = 0;
int hdr = 0;
int tdr = 0;
int selected_device = 0;
static int curinstr = 0xFFFFFFFF;
//int device_Offset = 0;
//int pfd;
int speedtouch       = 0;
//int DEBUG            = 0;
int Flash_DEBUG      = 0;
int probe_options    = 0;
unsigned int idcode_in_use =0;
int device = 0; /* selected device 0 ... 10 */
int ndevs  = 0; /* number of devices on the chain, set by autodetect */
unsigned int    idcodes[10]; /* list of inodes found by autodect */
char            flash_part[128];
unsigned int    blocks[1024];
unsigned int    proc_id;
unsigned int    data_register;
unsigned int    address_register;
static unsigned int ctrl_reg;
unsigned int    flash_size     = 0;
int             block_total    = 0;
unsigned int    block_addr     = 0;
unsigned int    cmd_type       = 0;
int             ejtag_version  = 0;
int             cl_bypass      = 0;
int             USE_DMA        = 0;
char            AREA_NAME[128];
unsigned int    AREA_START;
unsigned int    AREA_LENGTH;
unsigned int    FLASH_MEMORY_START;
unsigned int    vendid;
unsigned int    devid;
unsigned int    data_register;
unsigned int    address_register;
unsigned int    xbit = 0;
unsigned int    frequency;
unsigned int    bcmproc = 0;
unsigned int    swap_endian=0;
unsigned int    bigendian=0;
unsigned int spi_flash_read;
unsigned int spi_flash_mmr;
unsigned int spi_flash_mmr_size;
unsigned int spi_flash_ctl;
unsigned int spi_flash_opcode;
unsigned int spi_flash_data;
unsigned int spi_ctl_start;
unsigned int spi_ctl_busy;
#define	CID_ID_MASK		0x0000ffff
struct STAT_REG_BITS p;
typedef struct _processor_chip_type {
    unsigned int        chip_mask;      // Processor Chip ID maske
    unsigned int        chip_id;        // Processor Chip ID
    unsigned int        chip_IDCODE;    // Processor Chip IDCODE
    int                 instr_length;   // EJTAG Instruction Length
    char*               chip_descr;     // Processor Chip Description
} processor_chip_type;

processor_chip_type  processor_chip_list[] = {
   { 0xFFFFFFFF, 0x0471017F, 0x1, 5, "Broadcom BCM4702 Rev 1 CPU" },
   { 0xFFFFFFFF, 0x9470417F, 0x1, 8, "Broadcom BCM4704 KPBG Rev 9 CPU"},      // Tornado  WRT150N
   { 0xFFFFFFFF, 0x1471217F, 0x1, 8, "Broadcom BCM4712 Rev 1 CPU" },
   { 0xFFFFFFFF, 0x2471217F, 0x1, 8, "Broadcom BCM4712 Rev 2 CPU" },
   { 0xFFFFFFFF, 0x1471617F, 0x1, 8, "Broadcom BCM4716 Rev 1 CPU" },          // Eko BCM4718A1KFBG
   { 0xFFFFFFFF, 0x0478517F, 0x1, 8, "Broadcom BCM4785 Rev 1 CPU" },          // Tornado WRT350N
   { 0xFFFFFFFF, 0x0535017F, 0x1, 8, "Broadcom BCM5350 Rev 1 CPU" },
   { 0xFFFFFFFF, 0x0535217F, 0x1, 8, "Broadcom BCM5352 Rev 1 CPU" },
   { 0xFFFFFFFF, 0x1535417F, 0x1, 8, "Broadcom BCM5354 KFBG Rev 1 CPU" },     // Tornado - WRT54G GV8/GSV7
   { 0xFFFFFFFF, 0x2535417F, 0x1, 8, "Broadcom BCM5354 KFBG Rev 2 CPU" },     // Tornado - Gv8/GSv7
   { 0xFFFFFFFF, 0x3535417F, 0x1, 8, "Broadcom BCM5354 KFBG Rev 3 CPU" },     // Tornado - WRG54G2
   { 0xFFFFFFFF, 0x0334517F, 0x1, 5, "Broadcom BCM3345 KPB Rev 1 CPU" },      // Eko QAMLink  BCM3345 KPB SB4200
   { 0xFFFFFFFF, 0x0536517F, 0x1, 8, "Broadcom BCM5365 Rev 1 CPU" },         // BCM5365 Not Completely Verified Yet
   { 0xFFFFFFFF, 0x1536517F, 0x1, 8, "Broadcom BCM5365 Rev 1 CPU" },          // Eko....ASUS WL 500 G Deluxe
   { 0xFFFFFFFF, 0x0634517F, 0x1, 5, "Broadcom BCM6345 Rev 1 CPU" },          // BCM6345 Not Completely Verified Yet
   { 0xFFFFFFFF, 0x0634817F, 0x1, 5, "Broadcom BCM6348 Rev 1 CPU" },
   { 0xFFFFFFFF, 0x0634517F, 0x1, 5, "Broadcom BCM6345 Rev 1 CPU" },         // BCM6345 Not Completely Verified Yet
   { 0xFFFFFFFF, 0x0000100F, 0x1, 5, "TI AR7WRD TNETD7200ZWD Rev 1 CPU" },   // TI AR7WRD Only Partially Verified
   { 0xFFFFFFFF, 0x0000110F, 0x1, 5, "TI AR7WRD TNETD7200ZWD Rev 1 CPU" },   // TI AR7WRD Only Partially Verified
//  ------------------------  0x1 not veryfied
    { 0xFFFFFFFF, 0x0633817F, 0x1, 5, "Broadcom BCM6338 Rev 1 CPU" },		  // Speedtouch
    { 0xFFFFFFFF, 0x0635817F, 0x1, 5, "Broadcom BCM6358 Rev 1 CPU" },          // brjtag Fully Tested
    { 0xFFFFFFFF, 0x0636817F, 0x1, 5, "Broadcom BCM6368 Rev 1 CPU" },          // brjtag
    { 0xFFFFFFFF, 0x1432117F, 0x1, 5, "Broadcom BCM4321 RADIO STOP" },         // Radio JP3 on a WRT300N V1.1
    { 0xFFFFFFFF, 0x3432117F, 0x1, 5, "Broadcom BCM4321L RADIO STOP"},         // EKO Radio on WRT300n
    { 0xFFFFFFFF, 0x102002E1, 0x1, 5, "BRECIS MSP2007-CA-A1 CPU" },            // BRECIS chip - Not Completely Verified Yet
    { 0xFFFFFFFF, 0x0B52D02F, 0x1, 5, "TI TNETV1060GDW CPU" },                 // Fox WRTP54G
    { 0xFFFFFFFF, 0x00217067, 0x1, 5, "Linkstation 2 with RISC K4C chip" },    // Not verified
    { 0xFFFFFFFF, 0x00000001, 0x1, 5, "Atheros AR531X/231X CPU" },             // WHR-HP-AG108
    { 0xFFFFFFFF, 0x19277013, 0x1, 7, "XScale IXP42X 266mhz" },                // GW2348-2 Eko Gateworks Avila GW234X (IXP42X 266MHz) BE
    { 0xFFFFFFFF, 0x19275013, 0x1, 7, "XScale IXP42X 400mhz" },
    { 0xFFFFFFFF, 0x19274013, 0x1, 7, "XScale IXP42X 533mhz" },
    { 0xFFFFFFFF, 0x10940027, 0x1, 4, "ARM 940T"}, // Eko  Linksys BEFSX41
    { 0xFFFFFFFF, 0x07926041, 0x1, 4, "Marvell Feroceon 88F5181" },
    { 0xFFFFFFFF, 0x1438000D, 0x1, 5, "LX4380"},
// first 4 MSB bit are the revision number and differ, so we need a mask to ignore the s bits
   { 0x0FFFFFFF, 0x01C10093, 0x9, 6, "XC3S100E FPGE" },   //0x.1C10093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0x0FFFFFFF, 0x01C1A093, 0x9, 6, "XC3S250E FPGE" },   //0x.1C1A093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0x0FFFFFFF, 0x01C22093, 0x9, 6, "XC3S500E FPGE" },   //0x.1C22093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0x0FFFFFFF, 0x01C2E093, 0x9, 6, "XC3S1200E FPGE" },   //0x.1C2E093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0xFFF00FFF, 0x01400093, 0x9, 6, "Spartan-3 FPGA" },   //0x.14..093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0x0FFFFFFF, 0x01C3A093, 0x9, 6, "XC3S1600E FPGE" },   //0x.X1C3A093 IDCODE => '001001', USER1  => '000010', USER2  => '000011', bypass => '111111'
   { 0x0FFFFFFF, 0x0B6C002F, 0x9, 3, "0B6C002F ?????" },   // W701 ??
//
//   { 0xFFFFFFFF, 0x0470417F, 0x1, 8, "Broadcom BCM4704 Rev 8 CPU" },          // BCM4704 chip (used in the WRTSL54GS units)
   { 0xFFFFFFFF, 0x0470417F, 0x9, 8, "Broadcom BCM4704 Rev 8 CPU" }, // BCM4704 chip (used in the WRTSL54GS units)
   { 0xFFFFFFFF, 0x102002E1, 0x9, 5, "BRECIS MSP2007-CA-A1 CPU" },   // BRECIS chip - Not Completely Verified Yet
   { 0x0FFF0FFF, 0x05040093, 0xFE, 8, "XCF0xS Platform Flash" },     //0x.504.093 IDCODE => '11111110', bypass =>  '11111111'
   { 0xFFFFFFFF, 0xFFFFFFFF, 0x9, 2, "------- NOT POWERD ON OR NOT CONNECTED -------" },
   { 0xFFFFFFFF, 0, 0x9,  0, 0 }
   };

/*
FB
	instructionregister length Chain is 5
	CPU ChipID is 0x0000100F
	EJTag impcode is 0x41404000
FBF7050
	instructionregister Chain length is 9
	CPU ChipID is 0x0000100F
	EJTag impcode is 0x41404000
FBF7141
	instructionregister Chain length is 14
	CPU ChipID is 0x0000100F
	EJTag impcode is 0x41404000
*/

processor_chip_type*   processor_chip = processor_chip_list;

typedef struct _flash_area_type {
    unsigned int        chip_size;
    char*               area_name;
    unsigned int        area_start;
    unsigned int        area_length;
} flash_area_type;

flash_area_type  flash_area_list[] = {
    //---------   ----------     -----------  ------------
    //chip_size   area_name      area_start   area_length
    //---------   ----------     -----------  ------------
    { size1MB,    "CFE",         0x1FC00000,  0x40000 },
    { size2MB,    "CFE",         0x1FC00000,  0x40000 },
    { size4MB,    "CFE",         0x1FC00000,  0x40000 },//256Kb
    { size8MB,    "CFE",         0x1C000000,  0x40000 },
//   { size16MB,   "CFE",         0x1C000000,  0x40000 }, //differnt
    { size16MB,   "CFE",         0x1F000000,  0x40000 }, //tornado - for alice

    { size8MB,    "AR-CFE",         0xA8000000,  0x40000 },
    { size16MB,   "AR-CFE",         0xA8000000,  0x40000 },


    { size1MB,    "CFE128",      0x1FC00000,  0x20000 },
    { size2MB,    "CFE128",      0x1FC00000,  0x20000 },
    { size4MB,    "CFE128",      0x1FC00000,  0x20000 },//128Kb
    { size8MB,    "CFE128",      0x1C000000,  0x20000 },
    { size16MB,   "CFE128",      0x1C000000,  0x20000 },

    { size1MB,    "CF1",         0x1FC00000,  0x2000 },
    { size2MB,    "CF1",         0x1FC00000,  0x2000 },
    { size4MB,    "CF1",         0x1FC00000,  0x2000 },//8Kb
    { size8MB,    "CF1",         0x1C000000,  0x2000 },
    { size16MB,   "CF1",         0x1C000000,  0x2000 },

    { size1MB,    "KERNEL",      0x1FC40000,  0xB0000  },
    { size2MB,    "KERNEL",      0x1FC40000,  0x1B0000 },
    { size4MB,    "KERNEL",      0x1FC40000,  0x3B0000 },//3776Kb
    { size8MB,    "KERNEL",      0x1C040000,  0x7A0000 },
    { size16MB,   "KERNEL",      0x1C040000,  0x7A0000 },
    { size8MB,    "AR-KERNEL",   0xA8040000,  0x7A0000 },
    { size16MB,   "AR-KERNEL",   0xA8040000,  0x7A0000 },

    { size1MB,    "NVRAM",       0x1FCF0000,  0x10000 },
    { size2MB,    "NVRAM",       0x1FDF0000,  0x10000 },
    { size4MB,    "NVRAM",       0x1FFF0000,  0x10000 },//64kb
    { size8MB,    "NVRAM",       0x1C7E0000,  0x20000 },
    { size16MB,   "NVRAM",       0x1C7E0000,  0x20000 },

    { size8MB,    "AR-NVRAM",    0xA87E0000,  0x20000 },
    { size16MB,   "AR-NVRAM",    0xA87E0000,  0x20000 },

    { size2MB,    "WGRV9NVRAM",  0x1FDFC000,  0x4000 },
    { size2MB,    "WGRV9BDATA",  0x1FDFB000,  0x1000 },
    { size4MB,    "WGRV8BDATA",  0x1FFE0000,  0x10000 },//64kb

    { size1MB,    "WHOLEFLASH",  0x1FC00000,  0x100000 },
    { size2MB,    "WHOLEFLASH",  0x1FC00000,  0x200000 },
    { size4MB,    "WHOLEFLASH",  0x1FC00000,  0x400000 },//4Mb
    { size8MB,    "WHOLEFLASH",  0x1C000000,  0x800000 },
//    { size16MB,   "WHOLEFLASH",  0x1C000000,  0x1000000 }, different
    { size16MB,   "WHOLEFLASH",  0x1F000000,  0x1000000 },
    { size8MB,    "AR-WHOLEFLASH",  0xA8000000,  0x800000 },
    { size16MB,   "AR-WHOLEFLASH",  0xA8000000,  0x1000000 },

    { size1MB,    "BSP",         0x1FC00000,  0x50000 },
    { size2MB,    "BSP",         0x1FC00000,  0x50000 },
    { size4MB,    "BSP",         0x1FC00000,  0x50000 },
    { size8MB,    "BSP",         0x1C000000,  0x50000 },
    { size16MB,   "BSP",         0x1C000000,  0x50000 },

    { size8MB,    "AR-BSP",         0xA8000000,  0x50000 },
    { size16MB,   "AR-BSP",         0xA8000000,  0x50000 },

    { size1MB,    "RED",         0x50000000,  0x50000 },
    { size2MB,    "RED",         0x50000000,  0x50000 },
    { size4MB,    "RED",         0x50000000,  0x50000 },
    { size8MB,    "AR-RED",      0xA8000000,  0x30000 },
    { size8MB,    "RED",         0x50000000,  0x50000 },
    { size16MB,   "RED",         0x50000000,  0x50000 },
   { 0, 0, 0, 0 }
   };

typedef struct _flash_chip_type {
    unsigned int        vendid;         // Manufacturer Id
    unsigned int        devid;          // Device Id
    unsigned int        flash_size;     // Total size in MBytes
    unsigned int        cmd_type;       // Device CMD TYPE
    char*               flash_part;     // Flash Chip Description
    unsigned int        region1_num;    // Region 1 block count
    unsigned int        region1_size;   // Region 1 block size
    unsigned int        region2_num;    // Region 2 block count
    unsigned int        region2_size;   // Region 2 block size
    unsigned int        region3_num;    // Region 3 block count
    unsigned int        region3_size;   // Region 3 block size
    unsigned int        region4_num;    // Region 4 block count
    unsigned int        region4_size;   // Region 4 block size
} flash_chip_type;
flash_chip_type  flash_chip_list[] = {
   { 0x0001, 0x0214, size2MB, CMD_TYPE_SPI, "Spansion S25FL016A         (2MB) Serial"   ,32,size64K,   0,0,          0,0,        0,0        }, /* new */
   { 0x0001, 0x0215, size4MB, CMD_TYPE_SPI, "Spansion S25FL032A         (4MB) Serial"   ,64,size64K,   0,0,          0,0,        0,0        }, /* new */
   { 0x0001, 0x0216, size8MB, CMD_TYPE_SPI, "Spansion S25FL064A         (8MB) Serial"   ,128,size64K,  0,0,          0,0,        0,0        }, /* new */
   { 0x0001, 0x2249, size2MB, CMD_TYPE_AMD, "AMD 29lv160DB 1Mx16 BotB   (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K },
   { 0x0001, 0x22c4, size2MB, CMD_TYPE_AMD, "AMD 29lv160DT 1Mx16 TopB   (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x0001, 0x22f9, size4MB, CMD_TYPE_AMD, "AMD 29lv320DB 2Mx16 BotB   (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x0001, 0x22f6, size4MB, CMD_TYPE_AMD, "AMD 29lv320DT 2Mx16 TopB   (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0001, 0x2200, size4MB, CMD_TYPE_AMD, "AMD 29lv320MB 2Mx16 BotB   (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x0001, 0x227E, size4MB, CMD_TYPE_AMD, "AMD 29lv320MT 2Mx16 TopB   (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0001, 0x2201, size4MB, CMD_TYPE_AMD, "AMD 29lv320MT 2Mx16 TopB   (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0089, 0x0018,size16MB, CMD_TYPE_SCS, "Intel 28F128J3 8Mx16      (16MB)"   ,128,size128K, 0,0,          0,0,        0,0        },
   { 0x0089, 0x8891, size2MB, CMD_TYPE_BSC, "Intel 28F160B3 1Mx16 BotB  (2MB)"   ,8,size8K,     31,size64K,   0,0,        0,0        },
   { 0x0089, 0x8890, size2MB, CMD_TYPE_BSC, "Intel 28F160B3 1Mx16 TopB  (2MB)"   ,31,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0089, 0x88C3, size2MB, CMD_TYPE_BSC, "Intel 28F160C3 1Mx16 BotB  (2MB)"   ,8,size8K,     31,size64K,   0,0,        0,0        },
   { 0x0089, 0x88C2, size2MB, CMD_TYPE_BSC, "Intel 28F160C3 1Mx16 TopB  (2MB)"   ,31,size64K,   8,size8K,     0,0,        0,0        },
   { 0x00b0, 0x00d0, size2MB, CMD_TYPE_SCS, "Intel 28F160S3/5 1Mx16     (2MB)"   ,32,size64K,   0,0,          0,0,        0,0        },
   { 0x0089, 0x8897, size4MB, CMD_TYPE_BSC, "Intel 28F320B3 2Mx16 BotB  (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x0089, 0x8896, size4MB, CMD_TYPE_BSC, "Intel 28F320B3 2Mx16 TopB  (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0089, 0x88C5, size4MB, CMD_TYPE_BSC, "Intel 28F320C3 2Mx16 BotB  (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x0089, 0x88C4, size4MB, CMD_TYPE_BSC, "Intel 28F320C3 2Mx16 TopB  (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0089, 0x0016, size4MB, CMD_TYPE_SCS, "Intel 28F320J3 2Mx16       (4MB)"   ,32,size128K,  0,0,          0,0,        0,0        },
   { 0x0089, 0x0014, size4MB, CMD_TYPE_SCS, "Intel 28F320J5 2Mx16       (4MB)"   ,32,size128K,  0,0,          0,0,        0,0        },
   { 0x00b0, 0x00d4, size4MB, CMD_TYPE_SCS, "Intel 28F320S3/5 2Mx16     (4MB)"   ,64,size64K,   0,0,          0,0,        0,0        },
   { 0x0089, 0x8899, size8MB, CMD_TYPE_BSC, "Intel 28F640B3 4Mx16 BotB  (8MB)"   ,8,size8K,     127,size64K,  0,0,        0,0        },
   { 0x0089, 0x8898, size8MB, CMD_TYPE_BSC, "Intel 28F640B3 4Mx16 TopB  (8MB)"   ,127,size64K,  8,size8K,     0,0,        0,0        },
   { 0x0089, 0x88CD, size8MB, CMD_TYPE_BSC, "Intel 28F640C3 4Mx16 BotB  (8MB)"   ,8,size8K,     127,size64K,  0,0,        0,0        },
   { 0x0089, 0x88CC, size8MB, CMD_TYPE_BSC, "Intel 28F640C3 4Mx16 TopB  (8MB)"   ,127,size64K,  8,size8K,     0,0,        0,0        },
   { 0x0089, 0x0017, size8MB, CMD_TYPE_SCS, "Intel 28F640J3 4Mx16       (8MB)"   ,64,size128K,  0,0,          0,0,        0,0        },
   { 0x0089, 0x0015, size8MB, CMD_TYPE_SCS, "Intel 28F640J5 4Mx16       (8MB)"   ,64,size128K,  0,0,          0,0,        0,0        },
   { 0x0004, 0x22F9, size4MB, CMD_TYPE_AMD, "MBM29LV320BE 2Mx16 BotB    (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   { 0x0004, 0x22F6, size4MB, CMD_TYPE_AMD, "MBM29LV320TE 2Mx16 TopB    (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   // --- These definitions were defined based off the flash.h in GPL source from Linksys, but appear incorrect ---
   //   { 0x00C2, 0x22A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   //   { 0x00C2, 0x00A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   //   { 0x00C2, 0x00A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   //   { 0x00C2, 0x22A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   // --- These below are proper however ---
   { 0x00C2, 0x22A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x00C2, 0x00A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x00C2, 0x00A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x00C2, 0x22A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   //--- End of Changes ----
   { 0x00BF, 0x2783, size4MB, CMD_TYPE_SST, "SST39VF320 2Mx16           (4MB)"   ,64,size64K,   0,0,          0,0,        0,0        },
   { 0x0020, 0x22CB, size4MB, CMD_TYPE_AMD, "ST 29w320DB 2Mx16 BotB     (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   { 0x0020, 0x22CA, size4MB, CMD_TYPE_AMD, "ST 29w320DT 2Mx16 TopB     (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x00b0, 0x00e3, size4MB, CMD_TYPE_BSC, "Sharp 28F320BJE 2Mx16 BotB (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x0098, 0x009C, size4MB, CMD_TYPE_AMD, "TC58FVB321 2Mx16 BotB      (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   { 0x0098, 0x009A, size4MB, CMD_TYPE_AMD, "TC58FVT321 2Mx16 TopB      (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   // --- Add a few new Flash Chip Definitions ---
   { 0x001F, 0x00C0, size4MB, CMD_TYPE_AMD, "AT49BV/LV16X 2Mx16 BotB    (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x001F, 0x00C2, size4MB, CMD_TYPE_AMD, "AT49BV/LV16XT 2Mx16 TopB   (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },

   { 0x0004, 0x2249, size2MB, CMD_TYPE_AMD, "MBM29LV160B 1Mx16 BotB     (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K },
   { 0x0004, 0x22c4, size2MB, CMD_TYPE_AMD, "MBM29LV160T 1Mx16 TopB     (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x00C2, 0x2249, size2MB, CMD_TYPE_AMD, "MX29LV161B 1Mx16 BotB      (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K },
   { 0x00C2, 0x22c4, size2MB, CMD_TYPE_AMD, "MX29LV161T 1Mx16 TopB      (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x0020, 0x2249, size2MB, CMD_TYPE_AMD, "ST M29W160EB 1Mx16 BotB    (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K },
   { 0x0020, 0x22c4, size2MB, CMD_TYPE_AMD, "ST M29W160ET 1Mx16 TopB    (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00BF, 0x234B, size4MB, CMD_TYPE_SST, "SST39VF1601 1Mx16 BotB     (2MB)"   ,64,size32K,    0,0,          0,0,        0,0        },
   { 0x00BF, 0x234A, size4MB, CMD_TYPE_SST, "SST39VF1602 1Mx16 TopB     (2MB)"   ,64,size32K,    0,0,          0,0,        0,0        },
   { 0x00BF, 0x235B, size4MB, CMD_TYPE_SST, "SST39VF3201 2Mx16 BotB     (4MB)"   ,128,size32K,   0,0,          0,0,        0,0        },
   { 0x00BF, 0x235A, size4MB, CMD_TYPE_SST, "SST39VF3202 2Mx16 TopB     (4MB)"   ,128,size32K,   0,0,          0,0,        0,0        },
   { 0x00BF, 0x236B, size4MB, CMD_TYPE_SST, "SST39VF6401 4Mx16 BotB     (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   { 0x00BF, 0x236A, size4MB, CMD_TYPE_SST, "SST39VF6402 4Mx16 TopB     (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00EC, 0x2275, size2MB, CMD_TYPE_AMD, "K8D1716UTC  1Mx16 TopB     (2MB)"   ,31,size64K,    8,size8K,     0,0,        0,0        },
   { 0x00EC, 0x2277, size2MB, CMD_TYPE_AMD, "K8D1716UBC  1Mx16 BotB     (2MB)"   ,8,size8K,      31,size64K,   0,0,        0,0        },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00C2, 0x22DA, size1MB, CMD_TYPE_AMD, "MX29LV800BTC 512kx16 TopB  (1MB)"   ,15,size32K,    1,size16K,    2,size4K,   1,size8K   },
   { 0x00C2, 0x225B, size1MB, CMD_TYPE_AMD, "MX29LV800BTC 512kx16 BotB  (1MB)"   ,1,size8K,      2,size4K,     1,size16K,  15,size32K },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00EC, 0x22A0, size2MB, CMD_TYPE_AMD, "K8D3216UTC  2Mx16 TopB     (4MB)"   ,63,size64K,    8,size8K,     0,0,        0,0        },
   { 0x00EC, 0x22A2, size2MB, CMD_TYPE_AMD, "K8D3216UBC  2Mx16 BotB     (4MB)"   ,8,size8K,      63,size64K,   0,0,        0,0        },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00BF, 0x236D, size8MB, CMD_TYPE_SST, "SST39VF6401B 4Mx16 BotB    (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   { 0x00BF, 0x236C, size8MB, CMD_TYPE_SST, "SST39VF6402B 4Mx16 TopB    (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   { 0x0020, 0x227E,size16MB, CMD_TYPE_AMD, "M29W128GH 8Mx16           (16MB)"   ,128,size128K,  0,0,          0,0,        0,0        },
   // --- Add a few new Flash Chip Definitions ---
   { 0x00C2, 0x227E, size8MB, CMD_TYPE_AMD, "MX29LV640MTTC-90G 4Mx16    (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   // --- NEW Add a few new Flash Chip Definitions ---
   { 0x0004, 0x2250, size4MB, CMD_TYPE_AMD, "MBM29DL323TE 2Mx16 TopB    (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x0004, 0x2253, size4MB, CMD_TYPE_AMD, "MBM29DL323BE 2Mx16 BotB    (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x001F, 0x00C8, size4MB, CMD_TYPE_AMD, "AT49BV322A 2Mx16 BotB      (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x001F, 0x00C9, size4MB, CMD_TYPE_AMD, "AT49BV322A(T) 2Mx16 TopB   (4MB)"   ,63,size64K,     8,size8K,   0,0,        0,0        },
   { 0x001F, 0x2600, size2MB, CMD_TYPE_SPI, "Atmel AT45DB161B           (2MB) Serial"   ,512,sizeA4K,   0,0,          0,0,        0,0        }, /* new */
   { 0x0020, 0x2015, size2MB, CMD_TYPE_SPI, "STMicro M25P16             (2MB) Serial"   ,32,size64K,   0,0, 0,0, 0,0 }, /* new */
   { 0x0020, 0x2016, size4MB, CMD_TYPE_SPI, "STMicro M25P32             (4MB) Serial"   ,64,size64K,   0,0, 0,0, 0,0 }, /* new */
   { 0x0020, 0x2017, size8MB, CMD_TYPE_SPI, "STMicro M25P64             (8MB) Serial"   ,128,size64K,  0,0, 0,0, 0,0 }, /* new */
   { 0x0020, 0x2018, size16MB, CMD_TYPE_SPI, "STMicro M25P128           (16MB) Serial"  ,32,size256K,  0,0, 0,0, 0,0 }, /* new */
   { 0x0020, 0x225C, size4MB, CMD_TYPE_AMD, "M29DW324DT 2Mx16 TopB      (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        }, /* new */
   { 0x0020, 0x225D, size4MB, CMD_TYPE_AMD, "M29DW324DB 2Mx16 BotB      (4MB)"   ,8,size8K,   63,size64K,     0,0,        0,0        }, /* new */
   { 0x0040, 0x0000, size2MB, CMD_TYPE_SPI, "Atmel AT45DB161B           (2MB) Serial"   ,512,sizeA4K,   0,0,          0,0,        0,0        }, /* new */
   { 0x007F, 0x2249, size2MB, CMD_TYPE_AMD, "EON EN29LV160A 1Mx16 BotB  (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K }, /* cl_bypass */
   { 0x007F, 0x22C4, size2MB, CMD_TYPE_AMD, "EON EN29LV160A 1Mx16 TopB  (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x007F, 0x22C9, size8MB, CMD_TYPE_AMD, "EON EN29LV640 4Mx16 TopB   (8MB)"   ,127,size64K, 8,size8K,   0,0,        0,0        }, /* cl_bypass */
   { 0x007F, 0x22Cb, size8MB, CMD_TYPE_AMD, "EON EN29LV640 4Mx16 BotB   (8MB)"   ,8,size8K,    127,size64K,   0,0,        0,0        }, /* cl_bypass */
   { 0x007f, 0x22F6, size4MB, CMD_TYPE_AMD, "EON EN29LV320 2Mx16 TopB   (4MB)"   ,63,size64K,  8,size8K,    0,0,   0,0  }, /* cl_bypass */
   { 0x007f, 0x22F9, size4MB, CMD_TYPE_AMD, "EON EN29LV320 2Mx16 BotB   (4MB)"   ,8,size8K,    63,size64K,     0,0,  0,0 }, /* wrt54gl v1.1 */
   { 0x0098, 0x0057, size8MB, CMD_TYPE_AMD, "TC58FVM6T2A  4Mx16 TopB    (8MB)"   ,127,size64K,   8,size8K,     0,0,        0,0       }, /* new */
   { 0x0098, 0x0058, size8MB, CMD_TYPE_AMD, "TC58FVM6B2A  4Mx16 BopB    (8MB)"   ,8,size8K,   127,size64K,     0,0,        0,0       }, /* new */
   { 0x0098, 0x009A, size4MB, CMD_TYPE_AMD, "TC58FVT321 2Mx16 TopB      (4MB)"   ,63,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x0098, 0x009C, size4MB, CMD_TYPE_AMD, "TC58FVB321 2Mx16 BotB      (4MB)"   ,1,size16K,    2,size8K,     1,size32K,  63,size64K },
   { 0x00BF, 0x2783, size4MB, CMD_TYPE_SST, "SST39VF320 2Mx16           (4MB)"   ,64,size64K,   0,0,          0,0,        0,0        },
   { 0x00C2, 0x0014, size2MB, CMD_TYPE_SPI, "Macronix MX25L160A         (2MB) Serial"   ,32,size64K,   0,0,          0,0,        0,0        }, /* new */
   { 0x00C2, 0x00A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x00C2, 0x00A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x00C2, 0x2015, size2MB, CMD_TYPE_SPI, "Macronix MX25L1605D        (2MB) Serial"   ,32,size64K,    0,0,          0,0,        0,0 }, /* new */
   { 0x00C2, 0x2016, size4MB, CMD_TYPE_SPI, "Macronix MX25L3205D        (4MB) Serial"   ,64,size64K,    0,0,          0,0,        0,0 }, /* new */
   { 0x00C2, 0x2017, size8MB, CMD_TYPE_SPI, "Macronix MX25L6405D        (8MB) Serial"   ,128,size64K,   0,0,          0,0,        0,0 }, /* new */
   { 0x00C2, 0x2249, size2MB, CMD_TYPE_AMD, "MX29LV160CB 1Mx16 BotB     (2MB)"   ,1,size16K,    2,size8K,     1,size32K,  31,size64K },
   { 0x00C2, 0x227E, size8MB, CMD_TYPE_AMD, "MX29LV640MTTC-90G 4Mx16    (8MB)"   ,256,size32K,   0,0,          0,0,        0,0        },
   { 0x00C2, 0x22A7, size4MB, CMD_TYPE_AMD, "MX29LV320T 2Mx16 TopB      (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        },
   { 0x00C2, 0x22A8, size4MB, CMD_TYPE_AMD, "MX29LV320B 2Mx16 BotB      (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x00C2, 0x22C9, size16MB, CMD_TYPE_AMD, "MX29LV640B 4Mx16 TopB     (16MB)"  ,127,size64K,  8,size8K,      0,0,        0,0        },
   { 0x00C2, 0x22CB, size16MB, CMD_TYPE_AMD, "MX29LV640B 4Mx16 BotB     (16MB)"  ,8,size8K,     127,size64K,   0,0,        0,0        },
   { 0x00C2, 0x22c4, size2MB, CMD_TYPE_AMD, "MX29LV160CT 1Mx16 TopB     (2MB)"   ,31,size64K,   1,size32K,    2,size8K,   1,size16K  },
   { 0x00DA, 0x222A, size4MB, CMD_TYPE_AMD, "W19B(L)320SB   2Mx16 BotB  (4MB)"   ,8,size8K,   63,size64K,     0,0,        0,0        }, /* new */
   { 0x00DA, 0x22BA, size4MB, CMD_TYPE_AMD, "W19B(L)320ST   2Mx16 TopB  (4MB)"   ,63,size64K,   8,size8K,     0,0,        0,0        }, /* new */
   { 0x00EC, 0x2275, size2MB, CMD_TYPE_AMD, "K8D1716UTC  1Mx16 TopB     (2MB)"   ,31,size64K,    8,size8K,     0,0,        0,0        },
   { 0x00EC, 0x2277, size2MB, CMD_TYPE_AMD, "K8D1716UBC  1Mx16 BotB     (2MB)"   ,8,size8K,      31,size64K,   0,0,        0,0        },
   { 0x00EC, 0x22E0, size8MB, CMD_TYPE_AMD, "K8D6316UTM  4Mx16 TopB     (8MB)"   ,127,size64K,    8,size8K,     0,0,        0,0        }, /* new */
   { 0x00EC, 0x22E2, size8MB, CMD_TYPE_AMD, "K8D6316UBM  4Mx16 BotB     (8MB)"   ,8,size8K,      127,size64K,   0,0,        0,0        }, /* new */
   { 0x00EF, 0x3016, size4MB, CMD_TYPE_SPI, "Winbond W25X32             (4MB) Serial"   ,64,size64K,   0,0,          0,0,        0,0        }, /* new */
   { 0x00EF, 0x3017, size8MB, CMD_TYPE_SPI, "Winbond W25X64             (8MB) Serial"   ,128,size64K,   0,0,          0,0,        0,0        }, /* new */
   { 0x017E, 0x1000, size8MB, CMD_TYPE_AMD, "Spansion S29GL064M BotB    (8MB)"   ,8,size8K,     127,size64K,   0,0,        0,0        },
   { 0x017E, 0x1001, size8MB, CMD_TYPE_AMD, "Spansion S29GL064M TopB    (8MB)"   ,127,size64K,     8,size8K,   0,0,        0,0        },
   { 0x017E, 0x1200, size16MB, CMD_TYPE_AMD, "Spansion S29GL128M U      (16MB)"   ,128,size128K,   0,0,      0,0,        0,0         },
   { 0x017E, 0x1A00, size4MB, CMD_TYPE_AMD, "Spansion S29GL032M BotB    (4MB)"   ,8,size8K,     63,size64K,   0,0,        0,0        },
   { 0x017E, 0x1A01, size4MB, CMD_TYPE_AMD, "Spansion S29GL032M TopB    (4MB)"   ,63,size64K,     8,size8K,   0,0,        0,0        },
   { 0x017E, 0x2101, size16MB, CMD_TYPE_AMD, "Spansion S29GL128P U      (16MB)"   ,128,size128K,     0,0,   0,0,        0,0        },
   { 0x017E, 0x2201, size32MB, CMD_TYPE_AMD, "Spansion S29GL256P U      (32MB)"   ,256,size128K,     0,0,   0,0,        0,0        },
   { 0x017E, 0x2301, size64MB, CMD_TYPE_AMD, "Spansion S29GL512P U      (64MB)"   ,512,size128K,     0,0,   0,0,        0,0        },
   { 0x017E, 0x2801, size128MB, CMD_TYPE_AMD, "Spansion S29GL01GP U     (128MB)"   ,1024,size128K,     0,0,   0,0,        0,0        },
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
   };
//###################################################################################################
//# Set TMS to specified value by driving TMS port/pin specified in configuration
//###################################################################################################
void set_tms (int tms) {
    setPort(TMS,tms);
}
//###################################################################################################
//# Set TDI to specified value by driving TDI port/pin specified in configuration
//###################################################################################################
void set_tdi (int tdi) {
    setPort(TDI,tdi);
}
//###################################################################################################
//# Set TDI to specified value by driving TDI port/pin specified in configuration
//###################################################################################################
void set_tms_tdi (int tms, int tdi) {
    setPort(TDI,tdi);
    setPort(TMS,tms);
}
//###################################################################################################
//# Toggle clock 1->0 by driving TCK port/pin specified in configuration
//###################################################################################################
void tog_tck10 (int count) {
int i;
for (i=0; i < count; i++){
    setPort(TCK,1);  /* set the TCK port to high */
    setPort(TCK,0);  /* set the TCK port to low  */
 #ifdef DEBUG
    if (debug1) jtag_tap_controller_state_machine();
 #endif
    }
}
//###################################################################################################
//# Toggle clock 0->1 by driving TCK port/pin specified in configuration
//###################################################################################################
void tog_tck (int count) {
int i;
for (i=0; i < count; i++){
    setPort(TCK,0);  /* set the TCK port to low  */
    setPort(TCK,1);  /* set the TCK port to high */
 #ifdef DEBUG
    if (debug1) jtag_tap_controller_state_machine();
 #endif
}
}
//###################################################################################################
//# Read TDO from port/pin specified in configuration
//###################################################################################################
#define get_tdo() readTDOBit()
//###################################################################################################
//###################################################################################################
/* tornado
static unsigned char clockin(int tms, int tdi)
{
    unsigned char data;
    tms = tms ? 1 : 0;
    tdi = tdi ? 1 : 0;
// yoon's remark we set wtrst_n to be d4 so we are going to drive it low
    if (wiggler) data = (1 << WTDO) | (0 << WTCK) | (tms << WTMS) | (tdi << WTDI)| (1 << WTRST_N);
    else        data = (1 << TDO) | (0 << TCK) | (tms << TMS) | (tdi << TDI);
    cable_wait();
#ifdef WINDOWS_VERSION   // ---- Compiler Specific Code ----
    _outp(0x378, data);
#else
    ioctl(pfd, PPWDATA, &data);
#endif
    if (wiggler) data = (1 << WTDO) | (1 << WTCK) | (tms << WTMS) | (tdi << WTDI) | (1 << WTRST_N);
    else        data = (1 << TDO) | (1 << TCK) | (tms << TMS) | (tdi << TDI);
    cable_wait();
#ifdef WINDOWS_VERSION   // ---- Compiler Specific Code ----
    _outp(0x378, data);
#else
    ioctl(pfd, PPWDATA, &data);
#endif
#ifdef WINDOWS_VERSION   // ---- Compiler Specific Code ----
    data = (unsigned char)_inp(0x379);
#else
    ioctl(pfd, PPRSTATUS, &data);
#endif
    data ^= 0x80;
    data >>= wiggler?WTDO:TDO;
    data &= 1;
    return data;
}
*/
//###################################################################################################
// wiggler type cable is set via compiler option in headerfile
static unsigned char clockin(int tms, int tdi)
{
    if (once == 0) {
        out_word.bits.one = 1;
        out_word.bits.zero = 0;
        once = 1;
    }
    out_word.bits.tms = (unsigned char) tms;
    out_word.bits.tdi = (unsigned char) tdi;
    out_word.bits.tck = (unsigned char) 0;
    #ifdef WINDOWS_VERSION
        Out32(PPORT_BASE, out_word.value );
    #else
        ioctl(pfd, PPWDATA, &out_word.value);
    #endif
    out_word.bits.tck = (unsigned char) 1;
    #ifdef WINDOWS_VERSION
        Out32(PPORT_BASE, out_word.value );
    #else
        ioctl(pfd, PPWDATA, &out_word.value);
    #endif
    #ifdef DEBUG
     if (debug1) jtag_tap_controller_state_machine();
    #endif
    #ifdef WINDOWS_VERSION
    in_word.value = Inp32(SPORT_BASE);
    #else
	ioctl(pfd, PPRSTATUS, &in_word.value);
    #endif
    return (!! (in_word.bits.tdo));

/* alternativ but slower
static unsigned char clockin(int tms, int tdi)
{
	set_tms_tdi (tms,tdi);
        setPort( TCK, 0 );// Set TCK low
        setPort( TCK, 1 );// Set TCK high
    #ifdef DEBUG
     if (debug1) jtag_tap_controller_state_machine();
    #endif
	return get_tdo();
}
*/
}
// ---------------------------------------
// ---- End of Compiler Specific Code ----
// ---------------------------------------
#ifdef DEBUG
static int state=TAP_TEST_LOGIC_RESET;
void jtag_tap_controller_state_machine(void){
	clkcount++;
	unsigned char tmsb = 0;
	tmsb = (out_word.bits.tms);
	static int nextstate=TAP_TEST_LOGIC_RESET;
	switch(state) {
        case(TAP_TEST_LOGIC_RESET): if(!tmsb) {nextstate=TAP_RUN_TEST_IDLE;} break;
	    case(TAP_RUN_TEST_IDLE):    if(!tmsb) {nextstate=TAP_RUN_TEST_IDLE;} else {nextstate=TAP_SELECT_DR_SCAN;} break;
	    case(TAP_SELECT_DR_SCAN):   if(!tmsb) {nextstate=TAP_CAPTURE_DR;} else {nextstate=TAP_SELECT_IR_SCAN;} break;
	    case(TAP_CAPTURE_DR):       if(!tmsb) {nextstate=TAP_SHIFT_DR;} else {nextstate=TAP_EXIT1_DR;} break;
	    case(TAP_SHIFT_DR):         if(!tmsb) {nextstate=TAP_SHIFT_DR;} else {nextstate=TAP_EXIT1_DR;} break;
	    case(TAP_EXIT1_DR):         if(!tmsb) {nextstate=TAP_PAUSE_DR;} else {nextstate=TAP_UPDATE_DR;} break;
	    case(TAP_PAUSE_DR):         if(!tmsb) {nextstate=TAP_PAUSE_DR;} else {nextstate=TAP_EXIT2_DR;} break;
	    case(TAP_EXIT2_DR):         if(!tmsb) {nextstate=TAP_SHIFT_DR;} else {nextstate=TAP_UPDATE_DR;} break;
	    case(TAP_UPDATE_DR):        if(!tmsb) {nextstate=TAP_RUN_TEST_IDLE;} else {nextstate=TAP_SELECT_DR_SCAN;} break;
	    case(TAP_SELECT_IR_SCAN):   if(!tmsb) {nextstate=TAP_CAPTURE_IR;} else {nextstate=TAP_TEST_LOGIC_RESET;} break;
	    case(TAP_CAPTURE_IR):       if(!tmsb) {nextstate=TAP_SHIFT_IR;} else {nextstate=TAP_EXIT1_IR;} break;
	    case(TAP_SHIFT_IR):         if(!tmsb) {nextstate=TAP_SHIFT_IR;} else {nextstate=TAP_EXIT1_IR;} break;
	    case(TAP_EXIT1_IR):         if(!tmsb) {nextstate=TAP_PAUSE_IR;} else {nextstate=TAP_UPDATE_IR;} break;
        case(TAP_PAUSE_IR):         if(!tmsb) {nextstate=TAP_PAUSE_IR;} else {nextstate=TAP_EXIT2_IR;} break;
	    case(TAP_EXIT2_IR):         if(!tmsb) {nextstate=TAP_SHIFT_IR;} else {nextstate=TAP_UPDATE_IR;} break;
        case(TAP_UPDATE_IR):        if(!tmsb) {nextstate=TAP_RUN_TEST_IDLE;} else {nextstate=TAP_SELECT_DR_SCAN;} break;
        default: nextstate=TAP_TEST_LOGIC_RESET;
       }
       state=nextstate;
}
int PrintState(char* st)
{
if ((!debug2) && (repeat == state)) return(state);
repeat=state;
    if (debug1){
	int i;
	printf(" TDO: %01d  ",(!! (in_word.bits.tdo)));
	printf(" PPort: ");
	for (i=0; i<8; i++) printf("%d", (out_word.value >> (7-i)) & 1);
	printf(" clkcount: %05d  ", clkcount);
	printf(" TDI: %01d  ", out_word.bits.tdi);
	printf(" TMS: %01d  ", out_word.bits.tms);
	printf( st," ");
        printf("  <-Soll/State\\Ist-> ");
	switch(state) {
            case(1):  printf("  1 TAP_TEST_RESET\n"); break;
	    case(2):  printf("  2 TAP_RUN___IDLE\n"); break;
	    case(3):  printf("  3 TAP_SELECT__DR\n"); break;
	    case(4):  printf("  4 TAP_CAPTURE_DR\n"); break;
	    case(5):  printf("  5 TAP_SHIFT___DR\n"); break;
	    case(6):  printf("  6 TAP_EXIT1___DR\n"); break;
	    case(7):  printf("  7 TAP_PAUSE___DR\n"); break;
	    case(8):  printf("  8 TAP_EXIT2___DR\n"); break;
	    case(9):  printf("  9 TAP_UPDATE__DR\n"); break;
	    case(10): printf(" 10 TAP_SELECT__IR\n"); break;
	    case(11): printf(" 11 TAP_CAPTURE_IR\n"); break;
	    case(12): printf(" 12 TAP_SHIFT___IR\n"); break;
	    case(13): printf(" 13 TAP_EXIT1___IR\n"); break;
            case(14): printf(" 14 TAP_PAUSE___IR\n"); break;
	    case(15): printf(" 15 TAP_EXIT2___IR\n"); break;
            case(16): printf(" 16 TAP_UPDATE__IR\n"); break;
        }
    }
return (state);
}
#endif
void printInfo (void)
{
printf( " [Key] ... [nKey] + [Enter] \n"
        " Keys 1 to 4 must be followed by Key 5 or 6 and Enter.\n"
        " Output on port is only updated with clock toggle, any key sequenze can be put in.\n"
        " The entered sequenze will be processed after the Enter key is pressed.\n"
        " 1) TMS set       ->1 \n"
        " 2) TMS reset     ->0 \n"
        " 3) TDI set       ->1 \n"
        " 4) TDI reset     ->0 \n"
        " 5) TCK toggle ->0->1 \n"
        " 6) TCK toggle ->1->0 \n"
        " 7) TDO read\n"
        " 8) TCK count 25 sec \n"
        " 9) Display IR-Chainlength \n"

);
}
void test_ports (void)
{
debug1=1;
int ch;
printInfo();
  do
  {
    switch(ch=getchar())
    {
      case ('1'): set_tms(1);
      #ifdef DEBUG
      PrintState(" tms: 1"); break;
      #endif
      case ('2'): set_tms(0);
      #ifdef DEBUG
      PrintState(" tms: 0");break;
      #endif
      case ('3'): set_tdi(1);
      #ifdef DEBUG
      PrintState(" tdi: 1");break;
      #endif
      case ('4'): set_tdi(0);
      #ifdef DEBUG
      PrintState(" tdi: 0");break;
      #endif
      case ('5'): tog_tck(1);
      #ifdef DEBUG
      PrintState("        ");break;
      #endif
      case ('6'): tog_tck10(1);
      #ifdef DEBUG
      PrintState("        ");break;
      #endif
      case ('7'): printf(" TDO: %d\n", get_tdo());break;
      case ('8'): tog_tck(4000000);
      #ifdef DEBUG
      PrintState("        "); break;
      #endif
      case ('9'): detectChainLength(); break;
     default: printInfo();
    }
  }while(ch != ESC_CODE);
   return;
}
void q_continue (void)
{
    printf( " Press 'Enter' key to continue!");
    getchar();
}

//###################################################################################################
void goToShiftDR(void) {
    set_tms(1);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0  3 TAP_SELECT__DR");
    #endif
    set_tms(0);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0  4 TAP_CAPTURE_DR");
    #endif
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0  5 TAP_SHIFT___DR");
    #endif
}
//###################################################################################################
void goToShiftIR(void){
    set_tms(1);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0  3 TAP_SELECT__DR");
    #endif
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0 10 TAP_SELECT__IR");
    #endif
    set_tms(0);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0 11 TAP_CAPTURE_IR");
    #endif
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0 12 TAP_SHIFT___IR");
    #endif
}
//###################################################################################################
// Initialize the JTAG chain to the RTI state.
// Required initial state : none
// Final state            : RTI
//###################################################################################################
void tap_reset(void)
{
  // Put device(s) into TLR state
    clkcount = 0;
    set_tms_tdi(1,0);
    tog_tck(6);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0  1 TAP_TEST_RESET");
    #endif
    set_tms(0);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0  2 TAP_RUN___IDLE");
    #endif
}
//----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------
void WrIR(int instr)
{
    int i;
    if (hir!=0) {
        //set_tdi(1); /* put header bypass */
	#ifdef DEBUG
        if (debug2)  printf("IR hir:%d hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\n",hir);
	#endif
        /* put header bypass, discard N bits if more as one chip is on the chain after the one in use */
	for (i=0; i < hir; i++){
	    clockin(0,1);
	    #ifdef DEBUG
	    PrintState("tms: 0 tdi: 1 12 TAP_SHIFT___IR" );
	    #endif
        }
    }
    #ifdef DEBUG
    if (debug2)  printf("IR instr length:%d -----------------------------------------------------------------------------------------------------------------\n",instruction_length);
    #endif
    for (i=0; i < instruction_length; i++)
    {
	if (tir==0) {
	    clockin((i == instruction_length - 1), (instr>>i)&1); /*set tms on last bit and clock out tdi*/
    	    #ifdef DEBUG
	    if (i!=(instruction_length - 1))
	    PrintState("tms: 0 tdi: - 12 TAP_SHIFT___IR" );
    	    if (i==(instruction_length - 1))
	    PrintState("tms: 1 tdi: - 13 TAP_EXIT1___IR" );
	    #endif
	} else {
	    clockin(0, (instr>>i)&1); /*reset tms, and clock out tdi*/
    	    #ifdef DEBUG
	    PrintState("tms: 0 tdi: - 12 TAP_SHIFT___IR" );
	    #endif
	}
    }
    if (tir!=0) {/* put trailer bypass, discard N bits if more as one chip is on the chain in front of the one in use*/
    #ifdef DEBUG
    if (debug2)  printf("IR IR tir:%d  tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt\n",tir);
    #endif
	for (i=0; i < tir; i++){
    	    clockin((i == tir-1), 1); /*set tms on last bit and clock out bypass*/
	    #ifdef DEBUG
	    if (i!=(tir-1))
	    PrintState("tms: 0 tdi: 1 12 TAP_SHIFT___IR" );
	    if (i==(tir-1))
	    PrintState("tms: 1 tdi: 1 13 TAP_EXIT1___IR" );
	    #endif
	}
    }
    #ifdef DEBUG
    if (debug2)  printf("IR --------------------------------------------------------------------------------------------------------------------------------\n");
    #endif

}
//----------------------------------------------------------------------------------------------------------------------------
// read and writets 32 bits
static unsigned int rwDR(unsigned int send_data, unsigned int count)
{
    int i;
    unsigned int recive_data = 0;
    unsigned char recive_bit;
    if (hdr!=0) {
        //set_tdi(0);
	    #ifdef DEBUG
        if (debug2)  printf("DR hdr:%d hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\n",hdr);
	    #endif
        /* put header bypass, discard N bits if more as one chip is on the chain after the one in use */
	for (i=0; i < hdr; i++){
	    clockin(0,0);
	    #ifdef DEBUG
	    PrintState("tms: 0 tdi: 0  5 TAP_SHIFT___DR" );
	    #endif
        }
    }
 #ifdef DEBUG
    if (debug2)  printf("DR 32 -----------------------------------------------------------------------------------------------------------------------------\n");
 #endif
    for(i = 0 ; i < count ; i++){
        if (tdr==0){
	    recive_bit  = clockin((i == count-1), ((send_data>>i)&1)); /*set tms on last bit and clock out tdi*/
	    #ifdef DEBUG
    	    if (i!=count-1)
	    PrintState("tms: 0 tdi: -  5 TAP_SHIFT___DR" );
    	    if (i==count-1)
	    PrintState("tms: 1 tdi: -  6 TAP_EXIT1___DR" );
	    #endif
        } else {
    	    recive_bit  = clockin(0, ((send_data>>i)&1)); /*reset tms, and clock out tdi*/
    	    #ifdef DEBUG
	    PrintState("tms: 0 tdi: -  5 TAP_SHIFT___IR" );
	    #endif
	}
	recive_data |= (recive_bit << i);
    }
    if (tdr!=0) { /* discard N bits if more as one chip is on the chain in front of the one in use*/
        if (debug2)  printf("DR tdr:%d tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt\n",tdr);
	for (i=0; i < tdr; i++){
    	    clockin((i == tdr-1), 0); /*set tms on last bit and clock out zerros*/
	    #ifdef DEBUG
	    if (i!=(tdr-1))
	    PrintState("tms: 0 tdi: 0  5 TAP_SHIFT___DR" );
	    if (i==(tdr-1))
	    PrintState("tms: 1 tdi: 0  6 TAP_EXIT1___DR" );
	    #endif
	}
    }
    #ifdef DEBUG
    if (debug2)  printf("DR --------------------------------------------------------------------------------------------------------------------------------\n");
    #endif
    return recive_data;
}
//----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------
void WriteToIR(int instr)
{
    goToShiftIR();
    WrIR(instr);
    set_tms(1);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0 16 TAP_UPDATE__IR");
    #endif
    set_tms(0);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0  2 TAP_RUN___IDLE");
    #endif
}
//----------------------------------------------------------------------------------------------------------------------------
#ifdef DEBUG
void PrintDebugInstr(int instr)
{
char *CONTROL="";
    if (debug1) {
    //if (instr == curinstr)   printf("Equal Insruction not exicuted agein!\n");
	switch(instr) {
            case(INSTR_EXTEST): CONTROL="INSTR_EXTEST"; break;
            case(INSTR_IDCODE): CONTROL="INSTR_IDCODE"; break;
            case(INSTR_SAMPLE): CONTROL="INSTR_SAMPLE"; break;
            case(INSTR_IMPCODE): CONTROL="INSTR_IMPCODE"; break;
            case(INSTR_ADDRESS): CONTROL="INSTR_ADDRESS"; break;
            case(INSTR_DATA): CONTROL="INSTR_DATA"; break;
            case(INSTR_CONTROL): CONTROL="INSTR_CONTROL"; break;
            case(INSTR_BYPASS): CONTROL="INSTR_BYPASS"; break;
	}

    printf("%s: ",CONTROL);
    ShowData(instr,instruction_length);
    printf("\n");
    }
}
#endif
//----------------------------------------------------------------------------------------------------------------------------
void WriteIR(int instr)
{
//add
    static int curinstr1 = 0xFFFFFFFF;

    if (instr == curinstr1)
       return;
//add <-
    #ifdef DEBUG
    PrintDebugInstr(instr);
    #endif
    //if (instr != curinstr)
    { WriteToIR(instr); curinstr = instr;}
}
//----------------------------------------------------------------------------------------------------------------------------
/* tornado
static unsigned int ReadWriteData(unsigned int in_data)
{
    int i;
    unsigned int out_data = 0;
    unsigned char out_bit;

    if (DEBUG) printf("INSTR: 0x%04x  ", curinstr);
    if (DEBUG) printf("W: 0x%08x ", in_data);

    clockin(1, 0);  // enter select-dr-scan
    clockin(0, 0);  // enter capture-dr
    clockin(0, 0);  // enter shift-dr
    for (i = 0 ; i < 32 ; i++)
    {
        out_bit  = clockin((i == 31), ((in_data >> i) & 1));
        out_data = out_data | (out_bit << i);
    }
    clockin(1,0);   // enter update-dr
    clockin(0,0);   // enter runtest-idle

    if (DEBUG) printf("R: 0x%08x\n", out_data);

    return out_data;
}
*/
static unsigned int ReadWriteData(unsigned int send_data, unsigned int count)
{
    unsigned int recive_data = 0;
    goToShiftDR();
    recive_data=rwDR(send_data, count);
    set_tms(1);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 1 tdi: 0  9 TAP_UPDATE__DR");
    #endif
    set_tms(0);
    tog_tck(1);
    #ifdef DEBUG
    PrintState("tms: 0 tdi: 0  2 TAP_RUN___IDLE");
    #endif
    return recive_data;
}
//----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------
static unsigned int ReadData(unsigned int count)
{
    return ReadWriteData(0x00,count);
}
void WriteData(unsigned int send_data, unsigned int count)
{
    ReadWriteData(send_data,count);
}
void ShowData(unsigned int value, unsigned int count)
{
    int i;
    for (i=0; i<count; i++)
        printf("%d", (value >> (count-1-i)) & 1);
    printf(" (%08X)\n", value);
}
void ShowDataLine(unsigned int value, unsigned int count)
{
    int i;
    for (i=0; i<count; i++)
        printf("%d", (value >> (count-1-i)) & 1);
}
// Yoon's extensions for exiting debug mode
static void return_from_debug_mode(void)
{
    ExecuteDebugModule(pracc_return_from_debug);
}
static unsigned int ejtag_dma_read(unsigned int addr)
{
    unsigned int data;
    int retries = RETRY_ATTEMPTS;

begin_ejtag_dma_read:

    // Setup Address
    WriteIR(INSTR_ADDRESS);
    WriteData(addr,32);

    // Initiate DMA Read & set DSTRT

    WriteIR(INSTR_CONTROL);
    ctrl_reg = ReadWriteData(DMAACC | DRWN | DMA_WORD | DSTRT | PROBEN | PRACC,32);

    // Wait for DSTRT to Clear - Problem Gv8 tornado only this if line is new
    if (!((proc_id & 0xfffffff) == 0x535417f))
    while (ReadWriteData(DMAACC | PROBEN | PRACC,32) & DSTRT);

    // Read Data
    WriteIR(INSTR_DATA);
    data = ReadData(32);

    // Clear DMA & Check DERR
    WriteIR(INSTR_CONTROL);
    if (ReadWriteData(PROBEN | PRACC,32) & DERR)
    {
        if (retries--)  goto begin_ejtag_dma_read;
        else  printf("DMA Read Addr = %08x  Data = (%08x)ERROR ON READ\n", addr, data);
    }

    return(data);
}
//tornado
static unsigned int ejtag_dma_read_h(unsigned int addr)
{
    unsigned int data;
    int retries = RETRY_ATTEMPTS;
begin_ejtag_dma_read_h:
    // Setup Address
    WriteIR(INSTR_ADDRESS);
    WriteData(addr,32);
    // Initiate DMA Read & set DSTRT
    WriteIR(INSTR_CONTROL);
    ctrl_reg = ReadWriteData(DMAACC | DRWN | DMA_HALFWORD | DSTRT | PROBEN | PRACC,32);
    // Wait for DSTRT to Clear
    while (ReadWriteData(DMAACC | PROBEN | PRACC,32) & DSTRT);
    // Read Data
    WriteIR(INSTR_DATA);
    data = ReadData(32);
    // Clear DMA & Check DERR
    WriteIR(INSTR_CONTROL);
    if (ReadWriteData(PROBEN | PRACC,32) & DERR)
    {
        if (retries--)  goto begin_ejtag_dma_read_h;
        else  printf("DMA Read Addr = %08x  Data = (%08x)ERROR ON READ\n", addr, data);
    }
    // Handle the bigendian / littleendian
    if ( addr & 0x2 ) data = (data>>16)&0xffff;
    else data = (data&0x0000ffff);
    return(data);
}
//ejtag_dma_write
void ejtag_dma_write(unsigned int addr, unsigned int data)
{
    int   retries = RETRY_ATTEMPTS;

begin_ejtag_dma_write:

    // Setup Address
    WriteIR(INSTR_ADDRESS);
    WriteData(addr,32);

    // Setup Data
    WriteIR(INSTR_DATA);
    WriteData(data,32);

    // Initiate DMA Write & set DSTRT
    WriteIR(INSTR_CONTROL);
    ctrl_reg = ReadWriteData(DMAACC | DMA_WORD | DSTRT | PROBEN | PRACC,32);

    // Wait for DSTRT to Clear
    while (ReadWriteData(DMAACC | PROBEN | PRACC,32) & DSTRT);

    // Clear DMA & Check DERR
    WriteIR(INSTR_CONTROL);
    if (ReadWriteData(PROBEN | PRACC,32) & DERR)
    {
        if (retries--)  goto begin_ejtag_dma_write;
        else  printf("DMA Write Addr = %08x  Data = ERROR ON WRITE\n", addr);
    }
}
// tornado
void ejtag_dma_write_h(unsigned int addr, unsigned int data)
{
    int   retries = RETRY_ATTEMPTS;

begin_ejtag_dma_write_h:

    // Setup Address
    WriteIR(INSTR_ADDRESS);
    WriteData(addr,32);

    // Setup Data
    WriteIR(INSTR_DATA);
    WriteData(data,32);

    // Initiate DMA Write & set DSTRT
    WriteIR(INSTR_CONTROL);
    ctrl_reg = ReadWriteData(DMAACC | DMA_HALFWORD | DSTRT | PROBEN | PRACC,32);

    // Wait for DSTRT to Clear
    while (ReadWriteData(DMAACC | PROBEN | PRACC,32) & DSTRT);

    // Clear DMA & Check DERR
    WriteIR(INSTR_CONTROL);
    if (ReadWriteData(PROBEN | PRACC,32) & DERR)
    {
        if (retries--)  goto begin_ejtag_dma_write_h;
        else  printf("DMA Write Addr = %08x  Data = ERROR ON WRITE\n", addr);
    }
}
#ifdef REPEAT_EJAG
// ejtag_pracc_read
static unsigned int ejtag_pracc_read(unsigned int addr)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    data_register    = 0x0;
    unsigned int  data_register2    = 0x0;
    int   retries = RETRY_ATTEMPTS;
    while ((ExecuteDebugModule(pracc_readword_code_module)) && (retries--));
    data_register2 = data_register;
    if (check) {
        retries = RETRY_ATTEMPTS;
        while ((ExecuteDebugModule(pracc_readword_code_module)) && (retries--));
     }
    if ((data_register2 == data_register) && (retries)) return(data_register); else {printf("ERROR in byte\n"); return(0x20);}
}
#else
static unsigned int ejtag_pracc_read(unsigned int addr)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    data_register    = 0x0;
    ExecuteDebugModule(pracc_readword_code_module);
    return(data_register);
}
#endif
#ifdef REPEAT_EJAG
static unsigned int ejtag_pracc_read_h(unsigned int addr)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    data_register    = 0x0;
    unsigned int  data_register2    = 0x0;
    int   retries = RETRY_ATTEMPTS;
    while ((ExecuteDebugModule(pracc_readhalf_code_module)) && (retries--));
    data_register2 = data_register;
    if (check) {
        retries = RETRY_ATTEMPTS;
        while ((ExecuteDebugModule(pracc_readhalf_code_module)) && (retries--));
    }
    if ((data_register2 == data_register) && (retries)) return(data_register); else {printf("ERROR in byte\n"); return(0x20);}
}
#else
static unsigned int ejtag_pracc_read_h(unsigned int addr)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    data_register    = 0x0;
    ExecuteDebugModule(pracc_readhalf_code_module);
    return(data_register);
}
#endif
// ejtag_pracc_write
#ifdef REPEAT_EJAG
static unsigned int ejtag_pracc_write(unsigned int addr, unsigned int data)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    unsigned int  data_register2    = 0x0;
    int   retries = RETRY_ATTEMPTS;
    int   retries2 = 10;
    repeat1:
    data_register    = data;
    while ((ExecuteDebugModule(pracc_writeword_code_module)) && (retries--));
    data_register2 = data_register;
    if (check) {
        retries = RETRY_ATTEMPTS;
        while ((ExecuteDebugModule(pracc_readword_code_module)) && (retries--));
    }
    if ((data_register2 != data_register) && (retries2--) && (check)) goto repeat1;
    if ((data_register2 == data_register) && (retries2)) return 0; else return 1;
}
#else
static unsigned int ejtag_pracc_write(unsigned int addr, unsigned int data)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    int   retries2 = 10;
    repeat2:
    data_register    = data;
    ExecuteDebugModule(pracc_writeword_code_module);
    if (check) ExecuteDebugModule(pracc_readword_code_module);
    if ((data != data_register) && (retries2--) && (check)) goto repeat2;
    if (((data == data_register) && (retries2)) || ( ! check )) return 0; else return 1;
}
#endif
#ifdef REPEAT_EJAG
static unsigned int ejtag_pracc_write_h(unsigned int addr, unsigned int data)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    unsigned int  data_register2    = 0x0;
    int   retries = RETRY_ATTEMPTS;
    int   retries2 = 10;
    repeat3:
    data_register    = data;
    while ((ExecuteDebugModule(pracc_writehalf_code_module)) && (retries--));
    data_register2 = data_register;
    if (check) {
        retries = RETRY_ATTEMPTS;
        while ((ExecuteDebugModule(pracc_readhalf_code_module)) && (retries--));
    }
    if ((data_register2 != data_register) && (retries2--) && (check)) goto repeat3;
    if ((data_register2 == data_register) && (retries2)) return 0; else return 1;
}
#else
static unsigned int ejtag_pracc_write_h(unsigned int addr, unsigned int data)
{
    address_register = addr | 0xA0000000;  // Force to use uncached segment
    int   retries2 = 10;
    repeat4:
    data_register    = data;
    ExecuteDebugModule(pracc_writehalf_code_module);
    if (check) ExecuteDebugModule(pracc_readhalf_code_module);
    if ((data != data_register) && (retries2--) && (check)) goto repeat4;
    if (((data == data_register) && (retries2)) || ( ! check )) return 0; else return 1;
}
#endif
unsigned short byteSwap(unsigned short data)
{
    //convert from little to big endian
    unsigned short tmp;
    tmp=(data<<8)|(data>>8);
    return tmp;
}
// ejtag_read
static unsigned int ejtag_read(unsigned int addr)
{
   if (USE_DMA) return(ejtag_dma_read(addr));
   else return(ejtag_pracc_read(addr));
}
static unsigned int ejtag_read_h(unsigned int addr)
{
   if (USE_DMA) return(ejtag_dma_read_h(addr));
   else return(ejtag_pracc_read_h(addr));
}
// ejtag_write
//void ejtag_write(unsigned int addr, unsigned int data)
//{
//    if (USE_DMA) ejtag_dma_write(addr, data);
//    else ejtag_pracc_write(addr, data);
//}
void ejtag_write(unsigned int addr, unsigned int data)
{
    if (USE_DMA) ejtag_dma_write(addr, data);
    else if (ejtag_pracc_write(addr, data)) printf("Write ERROR!");
}
//void ejtag_write_h(unsigned int addr, unsigned int data)
//{
//    if (USE_DMA) ejtag_dma_write_h(addr, data);
//    else ejtag_pracc_write_h(addr, data);
//}
void ejtag_write_h(unsigned int addr, unsigned int data)
{
    if (USE_DMA) ejtag_dma_write_h(addr, data);
    else if (ejtag_pracc_write_h(addr, data)) printf("Write ERROR!");
}
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
static unsigned int ExecuteDebugModule(unsigned int *pmodule)
{
   unsigned int ctrl_reg;
   unsigned int address;
   unsigned int data   = 0;
   unsigned int offset = 0;
   int finished = 0;
   int DEBUGMSG = debug;
   int timeout = 10000;

   if (DEBUGMSG) printf("CPU-DEBUG: Start module.\n");

   // Feed the chip an array of 32 bit values into the processor via the EJTAG port as instructions.
   while (1)
   {
        // Read the control register.  Make sure an access is requested, then do it.
        while(1)
        {
    	    WriteIR(INSTR_CONTROL);
            ctrl_reg = ReadWriteData(PRACC | PROBEN | SETDEV,32);
            if (ctrl_reg & PRACC)
        	break;
		if (timeout==0) return 1;
        	if ((DEBUGMSG) && (timeout==1)) printf("CPU-DEBUG: No memory access in progress!\n");
		timeout--;
        }
	if (DEBUGMSG) { printf("last reed/write  PRACC | PROBEN | SETDEV : ");  ShowData(ctrl_reg,32);}

        WriteIR(INSTR_ADDRESS);
        address = ReadData(32);
	if (DEBUGMSG) { printf("last address read                        : ");  ShowData(address,32);}

      // Check for read or write
      if (ctrl_reg & PRNW) // Bit set for a WRITE
      {
         // Read the data out
         WriteIR(INSTR_DATA);
         data = ReadData(32);
	if (DEBUGMSG) { printf("last data_reg read                       : ");  ShowData(data,32);}
         // Clear the access pending bit (let the processor eat!)
         WriteIR(INSTR_CONTROL);
         ctrl_reg = ReadWriteData(PROBEN | SETDEV,32);
      	 if (DEBUGMSG) { printf("last ctrl_reg read/write PROBEN | SETDEV : ");  ShowData(ctrl_reg,32);}
         // Processor is writing to us
         if (DEBUGMSG) printf("1-CPU-DEBUG: Write 0x%08X to address 0x%08X\n", data, address);
         // Handle Debug Write
         // If processor is writing to one of our psuedo virtual registers then save off data
         if (address == MIPS_VIRTUAL_ADDRESS_ACCESS)  address_register = data;
         if (address == MIPS_VIRTUAL_DATA_ACCESS)     data_register    = data;
      }
      else
      {
         // Check to see if its reading at the debug vector.  The first pass through
         // the module is always read at the vector, so the first one we allow.  When
         // the second read from the vector occurs we are done and just exit.
        if (address == MIPS_DEBUG_VECTOR_ADDRESS)
         {
            if (finished++) // Allows ONE pass
            {
               if (DEBUGMSG) printf("CPU-DEBUG: Finished module.\n");
               return 0;
            }
         }
         // Processor is reading from us
         if (address >= MIPS_DEBUG_VECTOR_ADDRESS)
         {
            // Reading an instruction from our module so fetch the instruction from the module
            offset = (address - MIPS_DEBUG_VECTOR_ADDRESS) / 4;
            //printf("2-CPU-DEBUG: Instruction read at 0x%08X  offset -> %04d  data -> 0x%08X\n", address, offset, data); //fflush(stdout);
                     if (offset > 9999)
                     { if (DEBUGMSG) printf("ERROR: Check your wireing, some wrong: Instruction read at 0x%08X  offset -> %04d  data -> 0x%08X\n", address, offset, data); //fflush(stdout);
                        return 1;
                     }
          data = *(unsigned int *)(pmodule + offset);
            if (DEBUGMSG) printf("2-CPU-DEBUG: Instruction read at 0x%08X  offset -> %04d  data -> 0x%08X\n", address, offset, data); //fflush(stdout);
         }
         else
         {
            // Reading from our virtual register area
            if (DEBUGMSG) printf("3-CPU-DEBUG: Read virtual address 0x%08X  data = 0x%08X\n", address, data);
            // Handle Debug Read
            // If processor is reading from one of our psuedo virtual registers then give it data
            if (address == MIPS_VIRTUAL_ADDRESS_ACCESS)  data = address_register;
            else if (address == MIPS_VIRTUAL_DATA_ACCESS)     data = data_register;
            else {
                if (DEBUGMSG) printf("Flash adressing ERROR! Check wireing.");
                return 1;
            }
         }
         // Send the data out
	 if (DEBUGMSG) { printf("last data send                           : ");  ShowData(data,32);}
         WriteIR(INSTR_DATA);
         data = ReadWriteData(data,32);
	 if (DEBUGMSG) { printf("last data_reg read                       : ");  ShowData(data,32);}

         // Clear the access pending bit (let the processor eat!)
         WriteIR(INSTR_CONTROL);
         ctrl_reg = ReadWriteData(PROBEN | SETDEV,32);
      	 if (DEBUGMSG) { printf("last ctrl_reg read/write PROBEN | SETDEV : ");  ShowData(ctrl_reg,32);}
	}
   }
}
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//###################################################################################################
void ShowChipData(unsigned int value, unsigned int count)
{
    int i;
    printf("Chip ID: ");
    for (i=0; i<count; i++)
        printf("%d", (value >> (count-1-i)) & 1);
    printf(" (%08X)", value);
}
//###################################################################################################
void lookupCipList(unsigned int idcode, unsigned char notquiet ) {
       int NotFoundOne=1;
       processor_chip_type*   processor_chip = processor_chip_list;
       instruction = INSTR_IDCODE;
       instr_l = instrlen; /*set to commandline option*/
       if (notquiet || debug1)  {ShowChipData(idcode,32); printf("\n");}

       while (processor_chip->chip_id)
       {
          if ((idcode & processor_chip->chip_mask) == (processor_chip->chip_id ))
          {
             if (notquiet) printf(" *** Found a %s chip ***\n", processor_chip->chip_descr);
             instruction = processor_chip->chip_IDCODE;
             instr_l = processor_chip->instr_length;
	     idcode_in_use= processor_chip->chip_id;
	     NotFoundOne=0;
          }
          processor_chip++;
       }
       //if (instrlen) instr_l = instrlen;
       if (NotFoundOne) printf(" *** Unknown or NO Chip ID Detected ***\n");
}
/*###################################################################################################
// Required initial state : RTI
// Final state            : RTI
###################################################################################################
    // "ndevs" was set by autodecet
    // "device" was set before as well
    // Start with the last device in the chain, working backwards to device 0.
    // there must be a divice entry for each device in the divicelist
###################################################################################################*/
void set_tir_hir(void) {
    int d;
    goToShiftIR();
    for (d = ndevs-1; d >= 0; d-- ) {
	lookupCipList(idcodes[d], 0);
	if (d != device) {
	    if (d > device) {
	      tir=tir+instr_l;
	    }
	    if (d < device) {
	      hir=hir+instr_l;
	    }
	}
    }
}
//###################################################################################################
// Required initial state : ShiftDR
// Final state            : ShiftDR
//###################################################################################################
unsigned int readCountDR(unsigned char count) {
    unsigned int recive_data = 0;
    unsigned char recive_bit;
    unsigned char i   = 0;
    for(i = 0 ; i < count ; i++){
      setPort( TCK, 0 );
      recive_bit = get_tdo();
      recive_data |= (recive_bit << i);
      #ifdef DEBUG
      if (debug1) ShowDataLine(recive_bit,1);
      #endif
      setPort( TCK, 1 );
    #ifdef DEBUG
     if (debug1) jtag_tap_controller_state_machine();
     PrintState("tms: 0 tdi: 0  5 TAP_SHIFT___DR");
    #endif
    }
return (recive_data);
}
//###################################################################################################
// Detect single device in the JTAG chain, selected via commandline option, .
// Required initial state : none
// Final state            : RTI
//###################################################################################################
void detectOne(void) {
   unsigned char count   = 32;
   unsigned char x   = 0;
    x=(32 * device);
    //printf ("'%d' Device * 32\n", x);
    if ((selected_device > 9) || (selected_device < 0)) printf (" You must select a device number in the range of 1 ... 10, by option: /dv:XX");
    if (debug1) printf ("\n Device '%d' is selcted \n", (selected_device+1) );
    if (debug1) printf ("Beginning scan for cpu\n");
    tap_reset();
    goToShiftDR();
    set_tdi(0);
    tog_tck(x);
    if (debug1) printf("\n");
    printf ("---- Selected: '%d' ", ndevs-device);
    if (debug1) printf("\n");
    lookupCipList((readCountDR(count)), 1);
    printf("\n");
    // Return to RTI state
    tap_reset();
}
//###################################################################################################
// Autodetect devices in the JTAG chain.
// Required initial state : none
// Final state            : RTI
//###################################################################################################
void autodetect(unsigned char notquiet ) {
   unsigned char count   = 32;
   unsigned char max_chipcount = 10;
   unsigned char recive_bit;
   unsigned char recive_bit32 =1;
   unsigned int recive_data = 0;
   unsigned char i   = 0;
   ndevs=0;
  // Initialize the chain to ensure we start from the RTI state
  tap_reset();
  goToShiftDR();
  // Collect 32 bits of data from each device's IDCODE register.
  // JTAG spec requires that each device select its IDCODE register
  // for shifting out on TDO after device reset (probably during the TLR state).
  // All 0's are shifted in on TDI, so when the 32 bits collected is all 0's, we
  // know all the devices in the chain have been identified.
  while ((recive_bit32 == 1) && (max_chipcount > 0)) {
    max_chipcount--;
    recive_data = 0;                       	// reset for each new set of 32 bits
    recive_bit32 = 0;
    set_tdi(0);                 		// shift in 0s on TDI
    for(i = 0 ; i < count ; i++){
      setPort( TCK, 0 );
      recive_bit = get_tdo();     		// collect 32 bits of TDO data; build word from right to left
      if (i==0) recive_bit32=recive_bit;
      recive_data |= (recive_bit << i);
      if (debug1) ShowDataLine(recive_bit,1);
      setPort( TCK, 1 );
    #ifdef DEBUG
     if (debug1) jtag_tap_controller_state_machine();
      PrintState("tms: 0 tdi: 0  5 TAP_SHIFT___DR");
    #endif
    }
    if (debug1) printf("\n");
    if (recive_bit32){
      idcodes[ndevs]=recive_data;             	// push idcodes onto stack, last device in the chain goes in first
      //ShowData(idcodes[ndevs],32);
      ndevs++;
    }
  }
  // The first device in the chain (closest to the TDI signal from the PC) must be device 0.
  for  (i = ndevs; i > 0; i--) {
    if (notquiet) printf ("Device number: '%d' ", ndevs-i+1);
    lookupCipList(idcodes[i-1], notquiet);
    if (debug1) printf("\n");
  }
  // Return to RTI state
  tap_reset();
}
//###################################################################################################
// Read the IDCODE register for a pre-configured device in the chain.
// Required initial state : none
// Final state            : RTI
   // If there are any any aditional devices in the chain exept the selected
   // device, the data we want must get through each subsequent
   // device's bypass register, which is 1 bit long for each bypassed device.
   // This means that if there are "N" devices in the chain exept the selected device, and the
   // number of bits of data being shifted is "C", the total number of shifts
   // must be "N"+"C".  Additionally, the "N" bits of data received on
   // TDO should be discarded.
//###################################################################################################
void setHeaderTrailer(void) {
   unsigned int x=0;
   if (debug1) printf("\n");
   autodetect(1); // Get the number of devices on the chain
   if (debug1) printf("\n");
   if (ndevs==0) { // autoscan did not find the number of devices
     printf ("Could not set the bypass bits, you must do this by optins! ") ;
     exit(0); }
   // Ensure selected device is in range
   if (selected_device > ndevs)  {
    printf ("Selected device number %d to identify is not defined in scan chain\n", selected_device) ;
    exit(0);
   }
   //devices found are saved upside down
   device = ndevs-selected_device-1;
   //printf ("\ndevice: '%d' ndevs: '%d' \n", device, ndevs);
   //set device
   if (setBypass) set_tir_hir(); /* parameter 0 means take instr from chip table */
   detectOne();
   if (debug1) printf("\n");
   int instruct=instruction;
   instruction_length=instr_l;
   if (!hdr) hdr = ndevs-1-selected_device; //Calculate header drbits count
   if (!tdr) tdr = ndevs-1-hdr; //Calculate trailer drbits count
   printf ("\nCount devives: '%d' Selected device: '%d' count header bits added to DR: '%d' count trailing bits added to DR: '%d'\n", ndevs, device+1, hdr, tdr);
   if (((!hir) && (!tir)) && (ndevs!=1)) { printf ("You must specify /tir:X or /hir:X by Option! \n\n"); exit (0);
   } else {
     if (!tir && ChainLength)  tir = (ChainLength)-instruction_length-hir; //Calculate trailer irbits count
     if (!hir && ChainLength)  hir = (ChainLength)-instruction_length-tir; //Calculate header irbits count
     printf ("Chain length: '%d' Selected IR length: '%d' Sum of added header bits to IR: '%d' Sum of added trailer bits to IR: '%d'\n\n", ChainLength, instruction_length, hir, tir);
   }
   WriteIR(instruct);
   x=ReadData(32);
   lookupCipList(x, 1);
   //test
   if (debug1) {
	printf ("\nDevice number: '%d'\n", selected_device+1);
	printf ("\nInsruction:\n");
	ShowDataLine(instruct,instruction_length);
	printf ("\nChip ID wanted:\n");
	ShowDataLine(idcode_in_use,32);
	printf ("\n");
   }
   if ((idcode_in_use) != (x)) {
	printf ("\n---- Chip is not selected as disired!! ----\n");
	printf ("\nDevice number: '%d'\n", selected_device+1);
	printf ("\nInsruction:\n");
	ShowDataLine(instruct,instruction_length);
	printf ("\nChip ID wanted:\n");
	ShowDataLine(idcode_in_use,32);
	printf ("\n");
    lookupCipList(x, 1);
	printf ("\n");
	exit(0);
   }
}
//###################################################################################################
//###################################################################################################
/*###################################################################################################
#  IR  chain length
# Required initial state : RTI
# Final state            : RTI
###################################################################################################*/
void detectChainLength(void)
{
    int i;
    unsigned int retries = 10000;
    unsigned int recive_data = 0;
    unsigned char recive_bit = 0;
    printf("Beginning detect scan leangth... \n");
    printf("Switch on power!...\n");
    rep:
    tap_reset();
    goToShiftIR();
    get_tdo();
    for(i = 0 ; i < 64 ; i++){
        recive_bit = get_tdo();
	//ShowDataLine(recive_bit,1);
	recive_data |= (recive_bit << i);
	set_tdi(0);                 // shift in 0s on TDI
	tog_tck(1);
	#ifdef DEBUG
	PrintState("tms: 0 tdi: 0 12 TAP_SHIFT___IR");
	#endif
    }
    //printf("\n");
    for(i = 0 ; i < 64 ; i++){
        recive_bit = get_tdo();
	//ShowDataLine(recive_bit,1);
	set_tdi(1);                 // shift in 1s on TDI
	tog_tck(1);
        #ifdef DEBUG
	PrintState("tms: 0 tdi: 1 12 TAP_SHIFT___IR");
	#endif
	if (recive_bit==1) {i--; if (debug1) printf("\n"); break;};
//	if (recive_bit==1) {i--; printf("\n"); break;};
    }
    //printf("\n");
    if ((i<=0) || (i==64)) {
       if (retries--) goto rep;
	printf("\n\n==================================\n");
	printf("Chain leangh could not be detected.\n");
	printf("Not powerd on, or TDI TDO shorted!\n");
	printf("Or Watchdog is on.\n");
	printf("==================================\n\n");
        exit (0);
    }
    printf("Chain lenght: %d IR-Chain: ",i);
    ShowData(recive_data,i);
    ChainLength=i;
    // Return to RTI state
    //tap_reset();
    //printf ("Auto-detect complete\n");
}
//###################################################################################################*/
void chip_detect(void)
{
    printf("Probing bus ...\n");
    tap_reset();
    hir = selected_hir;
    tir = selected_tir;
    hdr = selected_hdr;
    tdr = selected_tdr;
    if (selected_hir)   printf ("'%d' Header bits added to IR, through commmand line option\n", selected_hir);
    if (selected_tir)   printf ("'%d' Trailer bits added to IR, through commmand line option\n", selected_tir);
    if (selected_hdr)   printf ("'%d' Header bits added to DR, through commmand line option\n", selected_hdr);
    if (selected_tdr)   printf ("'%d' Trailer bits added to DR, through commmand line option\n", selected_tdr);
    if (instrlen) instruction_length=instrlen;
    if (instrlen) printf("Instruction length set to %d, through commmand line option\n",instrlen);
    if (skipdetect) printf("\n*** CHIP Device number: '%d' SET BY COMMANDLINE OPTION ***\n", selected_device+1);
    else
    {
        printf ("Beginning scan chain auto-detection\n");
	    autodetect(1);
	    instruction_length=instr_l;
        printf("Done\n");
	    printf("\nProcessing is stopped now, you must specify new commandline options now:\n");
	    printf("/skipdetect and /dv:XX with the device number of the CPU found.\n");
	    chip_shutdown();
        /*if (ndevs==0)
        {
            printf("*** Possible Causes:\n");
            printf("*** Unknown or NO CPU Chip ID Detected ***\n\n");
            printf("*** Possible Causes:\n");
            printf("    1) Device is not Connected.\n");
            printf("    2) Device is not Powered On.\n");
            printf("    3) Improper JTAG Cable.\n");
            printf("    4) Unrecognized CPU Chip ID.\n");
        }*/
	    exit(0);
    }
    setHeaderTrailer(); // Detect the number of devices on the chain and set bits
}
//###################################################################################################*/
void chip_detecty(void)
{
    hir = selected_hir;
    tir = selected_tir;
    hdr = selected_hdr;
    tdr = selected_tdr;
    printf (" Hir: '%d' Tir: '%d' Hdr: '%d' Tdr: '%d'\n", selected_hir, selected_tir, selected_hdr, selected_tdr);
    unsigned int id = 0x0;
    processor_chip_type*   processor_chip = processor_chip_list;
    tap_reset();
    if (skipdetect)
    {
       // Manual Override CPU Chip ID
       instruction_length = instrlen;
       WriteIR(INSTR_IDCODE);
       id = ReadData(32);
       //printf("Done\n\n");
       //printf("Instruction Length set to %d\n\n",instruction_length);
       printf("CPU Chip ID: ");  ShowData(id,32);  printf("*** CHIP DETECTION OVERRIDDEN ***\n");
       return;
    }
    else
    {
    	 // Auto Detect CPU Chip ID
       while (processor_chip->chip_id)
       {
          if (instrlen)
             instruction_length = instrlen;
          else
	      instruction_length = processor_chip->instr_length;
          WriteIR(INSTR_IDCODE);
          id = ReadData(32);
          if (id == processor_chip->chip_id)
          {
             //printf("Done\n\n");
             printf("Instruction Length set to %d\n\n",instruction_length);
             printf("CPU Chip ID: ");  ShowData(id,32);  printf("***  Found a %s chip ***\n", processor_chip->chip_descr);
             return;
          }
          processor_chip++;
       }
    }
    printf("CPU Chip ID: ");  ShowData(id,32);  printf("*** Unknown or NO CPU Chip ID Detected ***\n");
}
void check_ejtag_features()
{
    unsigned int features;

    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);
    WriteIR(INSTR_IMPCODE);
    features = ReadData(32);
    printf("    - EJTAG IMPCODE ....... : ");   ShowData(features,32);

    // EJTAG Version
    ejtag_version = (features >> 29) & 7;
    printf("    - EJTAG Version ....... : ");
    if (ejtag_version == 0)       printf("1 or 2.0\n");
    else if (ejtag_version == 1)  printf("2.5\n");
    else if (ejtag_version == 2)  printf("2.6\n");
    else if (ejtag_version == 3)  printf("3.1\n");
    else                          printf("Unknown (%d is a reserved value)\n", ejtag_version);

    // EJTAG DMA Support
    USE_DMA = !(features & (1 << 14));
    printf("    - EJTAG DMA Support ... : %s\n", USE_DMA ? "Yes" : "No");
    printf( "    - EJTAG Implementation flags:%s%s%s%s%s%s%s\n",
            (features & (1 << 28)) ? " R3k"	: " R4k",
            (features & (1 << 24)) ? " DINTsup"	: "",
            (features & (1 << 22)) ? " ASID_8"	: "",
            (features & (1 << 21)) ? " ASID_6"	: "",
            (features & (1 << 16)) ? " MIPS16"	: "",
            (features & (1 << 14)) ? " NoDMA"	: "",
            (features & (1      )) ? " MIPS64"	: " MIPS32" );
    if (force_dma)   { USE_DMA = 1;  printf("    *** DMA Mode Forced On ***\n"); }
    if (force_nodma) { USE_DMA = 0;  printf("    *** DMA Mode Forced Off ***\n"); }

    printf("\n");
}
void chip_shutdown(void)
{
    fflush(stdout);
    tap_reset();
}
void run_backup(char *filename, unsigned int start, unsigned int length)
{
    unsigned int addr, data;
    FILE *fd;
    int counter = 0;
    int percent_complete = 0;
    char newfilename[128] = "";
//    int swp_endian = (cmd_type == CMD_TYPE_SPI);
    time_t start_time = time(0);
    time_t end_time, elapsed_seconds;
    struct tm* lt = localtime(&start_time);
    char time_str[16]; //char time_str[15];
    sprintf(time_str, "%04d%02d%02d_%02d%02d%02d",
            lt->tm_year + 1900, lt->tm_mon + 1, lt->tm_mday,
            lt->tm_hour, lt->tm_min, lt->tm_sec
           );
    printf("*** You Selected to Backup the %s ***\n\n",filename);
    strcpy(newfilename,filename);
    strcat(newfilename,".SAVED");
    if (issue_timestamp)
    {
        strcat(newfilename,"_");
        strcat(newfilename,time_str);
    }
    fd = fopen(newfilename, "wb" );
    if (fd<=0)
    {
        fprintf(stderr,"Could not open %s for writing\n", newfilename);
        exit(1);
    }
    printf("=========================\n");
    printf("Backup Routine Started\n");
    printf("=========================\n");
    printf("\nSaving %s to Disk...\n",newfilename);
    for (addr=start; addr<(start+length); addr+=4)
    {
        counter += 4;
        percent_complete = (counter * 100 / length);
        if (!silent_mode)
            if ((addr&0xF) == 0)  printf("[%3d%% Backed Up]   %08x: ", percent_complete, addr);
        data = ejtag_read(addr);
        if (swap_endian) data = byteSwap_32(data);
        fwrite( (unsigned char*) &data, 1, sizeof(data), fd);
        if (silent_mode)  printf("%4d%%   byte count: %d\r", percent_complete, counter);
        else              printf("%08x%c", data, (addr&0xF)==0xC?'\n':' ');
        fflush(stdout);
    }
    fclose(fd);
    printf("Done  (%s saved to Disk OK)\n\n",newfilename);
    printf("bytes written: %d\n", counter);
    printf("=========================\n");
    printf("Backup Routine Complete\n");
    printf("=========================\n");
    time(&end_time);
    elapsed_seconds = difftime(end_time, start_time);
    printf("elapsed time: %d seconds\n", (int)elapsed_seconds);
}
void run_flash(char *filename, unsigned int start, unsigned int length)
{
    unsigned int addr, data ;
    FILE *fd ;
    int counter = 0;
    int percent_complete = 0;
    time_t start_time = time(0);
    time_t end_time, elapsed_seconds;
    printf("*** You Selected to Flash the %s ***\n\n",filename);
    fd=fopen(filename, "rb" );
    if (fd<=0)
    {
        fprintf(stderr,"Could not open %s for reading\n", filename);
        exit(1);
    }
    printf("=========================\n");
    printf("Flashing Routine Started\n");
    printf("=========================\n");
    if (issue_erase) sflash_erase_area(start,length);
    if (cl_bypass) unlock_bypass();
    printf("\nLoading %s to Flash Memory...\n",filename);
    for (addr=start; addr<(start+length); addr+=4)
    {
        counter += 4;
        percent_complete = (counter * 100 / length);
        if (!silent_mode)
        if ((addr&0xF) == 0)  printf("[%3d%% Flashed]   %08x: ", percent_complete, addr);
        fread((unsigned char*) &data, 1,sizeof(data), fd);
        // Erasing Flash Sets addresses to 0xFF's so we can avoid writing these (for speed)
        if (issue_erase){
            if (!(data == 0xFFFFFFFF))
            sflash_write_word(addr, data);
        }
        else sflash_write_word(addr, data);  // Otherwise we gotta flash it all
        // original if (silent_mode)  printf("%4d%%   bytes = %d\r", percent_complete, counter);
        if (silent_mode)  printf("%4d%%   bytes = %d (%08x)@(%08x)=%08x\r", percent_complete, counter, counter, addr, data);
        else              printf("%08x%c", data, (addr&0xF)==0xC?'\n':' ');
        fflush(stdout);
        data = 0xFFFFFFFF;  // This is in case file is shorter than expected length
    }
    fclose(fd);
    printf("Done  (%s loaded into Flash Memory OK)\n\n",filename);
    sflash_reset();
    printf("=========================\n");
    printf("Flashing Routine Complete\n");
    printf("=========================\n");
    time(&end_time);
    elapsed_seconds = difftime(end_time, start_time);
    printf("elapsed time: %d seconds\n", (int)elapsed_seconds);
}
void run_erase(char *filename, unsigned int start, unsigned int length)
{
    time_t start_time = time(0);
    time_t end_time, elapsed_seconds;

    printf("*** You Selected to Erase the %s ***\n\n",filename);

    printf("=========================\n");
    printf("Erasing Routine Started\n");
    printf("=========================\n");

    sflash_erase_area(start,length);
    sflash_reset();

    printf("=========================\n");
    printf("Erasing Routine Complete\n");
    printf("=========================\n");

    time(&end_time);
    elapsed_seconds = difftime(end_time, start_time);
    printf("elapsed time: %d seconds\n", (int)elapsed_seconds);
}
void sflash_erase_area(unsigned int start, unsigned int length)
{
    int cur_block;
    int tot_blocks;
    unsigned int reg_start;
    unsigned int reg_end;
    reg_start = start;
    reg_end   = reg_start + length;
    tot_blocks = 0;
    for (cur_block = 1;  cur_block <= block_total;  cur_block++)
    {
        block_addr = blocks[cur_block];
        if ((block_addr >= reg_start) && (block_addr < reg_end))  tot_blocks++;
    }
    printf("Total Blocks to Erase: %d\n\n", tot_blocks);
    for (cur_block = 1;  cur_block <= block_total;  cur_block++)
    {
        block_addr = blocks[cur_block];
        if ((block_addr >= reg_start) && (block_addr < reg_end))
        {
            printf("Erasing block: %d (addr = %08x)...", cur_block, block_addr);
            fflush(stdout);
            sflash_erase_block(block_addr);
            printf("Done\n");
            fflush(stdout);
        }
    }
}
void identify_flash_part(void)
{
    flash_chip_type*   flash_chip = flash_chip_list;
    flash_area_type*   flash_area = flash_area_list;
    // Important for these to initialize to zero
    block_addr  = 0;
    block_total = 0;
    flash_size  = 0;
    cmd_type    = 0;
    strcpy(flash_part,"");
    /*     Spansion ID workaround (kb1klk) 30 Dec 2007
         Vendor ID altered to 017E to avoid ambiguity in lookups.
         Spansion uses vend 0001 dev 227E for numerous chips.
         This code reads device SubID from its address and combine this into
         the unique devid that will be used in the lookup table. */
    if (((vendid & 0x00ff) == 0x0001) && (devid == 0x227E))
    {
        unsigned int devsubid_m, devsubid_l;
        vendid = 0x017E;
        devsubid_m = 0x00ff & ejtag_read_h(FLASH_MEMORY_START+0x1C);  // sub ID step 1
        devsubid_l = 0x00ff & ejtag_read_h(FLASH_MEMORY_START+0x1E);  // sub ID step 2
        devid = (0x0100 * devsubid_m) + (0x0000 + devsubid_l);
    }
    // WinBond extended ID query - 27 Jan 2008
    if (((vendid & 0x00ff) == 0x00DA) && ((devid & 0x00ff) == 0x007E))
    {
        unsigned int devsubid_m, devsubid_l;
        vendid = 0xDA7E;
        devsubid_m = 0x00ff & ejtag_read_h(FLASH_MEMORY_START+0x1C);  // sub ID step 1
        devsubid_l = 0x00ff & ejtag_read_h(FLASH_MEMORY_START+0x1E);  // sub ID step 2
        devid = (0x0100 * devsubid_m) + (0x0000 + devsubid_l);
    }
    while (flash_chip->vendid)
    {
        if ((flash_chip->vendid == vendid) && (flash_chip->devid == devid))
        {
            flash_size = flash_chip->flash_size;
            cmd_type   = flash_chip->cmd_type;
            strcpy(flash_part, flash_chip->flash_part);
            if (strcasecmp(AREA_NAME,"CUSTOM")==0)
            {
                FLASH_MEMORY_START = selected_window;
            }
            else
            {
                switch (proc_id)
                {
                case IXP425_266:
                case IXP425_400:
                    //   case IXP425_533:
                    //       FLASH_MEMORY_START = 0x50000000;
                    //       break;
                case ARM_940T:
                    FLASH_MEMORY_START = 0x00400000;
                    break;
                case 0x0635817F:
                    FLASH_MEMORY_START = 0x1F000000;
                    break;
//    case ATH_PROC:
//        FLASH_MEMORY_START = 0xA8000000;
//        break;
                default:
                    if (flash_size >= size8MB )
                    {
                        FLASH_MEMORY_START = 0x1C000000;
                    }
                    else
                    {
                        FLASH_MEMORY_START = 0x1FC00000;
                    }
                }
            }
            if (proc_id == 0x00000001)
            {
                if ((strcasecmp(AREA_NAME,"CFE")==0)  && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-CFE");
                if ((strcasecmp(AREA_NAME,"NVRAM")==0) && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-NVRAM");
                if ((strcasecmp(AREA_NAME,"KERNEL")==0) && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-KERNEL");
                if ((strcasecmp(AREA_NAME,"WHOLEFLASH")==0) && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-WHOLEFLASH");
                if ((strcasecmp(AREA_NAME,"BSP")==0) && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-BSP");
                if ((strcasecmp(AREA_NAME,"RED")==0) && flash_size >= size8MB)
                    strcpy(AREA_NAME, "AR-RED");
            }
            while (flash_area->chip_size)
            {
                if ((flash_area->chip_size == flash_size) && (strcasecmp(flash_area->area_name, AREA_NAME)==0))
                {
                    strcat(AREA_NAME,".BIN");
                    AREA_START  = flash_area->area_start;
                    AREA_LENGTH = flash_area->area_length;
                    break;
                }
                flash_area++;
            }
            if (strcasecmp(AREA_NAME,"CUSTOM")==0)
            {
                strcat(AREA_NAME,".BIN");
                FLASH_MEMORY_START = selected_window;
                AREA_START         = selected_start;
                AREA_LENGTH        = selected_length;
            }
            if (flash_chip->region1_num)  define_block(flash_chip->region1_num, flash_chip->region1_size);
            if (flash_chip->region2_num)  define_block(flash_chip->region2_num, flash_chip->region2_size);
            if (flash_chip->region3_num)  define_block(flash_chip->region3_num, flash_chip->region3_size);
            if (flash_chip->region4_num)  define_block(flash_chip->region4_num, flash_chip->region4_size);
            sflash_reset();
            printf("Done\n\n");
            printf("Flash Vendor ID: ");
            ShowData(vendid,32);
            printf("Flash Device ID: ");
            ShowData(devid,32);
            if (selected_fc != 0)
                printf("*** Manually Selected a %s Flash Chip ***\n\n", flash_part);
            else
                printf("*** Found a %s Flash Chip ***\n\n", flash_part);
            printf("    - Flash Chip Window Start .... : %08x\n", FLASH_MEMORY_START);
            printf("    - Flash Chip Window Length ... : %08x\n", flash_size);
            printf("    - Selected Area Start ........ : %08x\n", AREA_START);
            printf("    - Selected Area Length ....... : %08x\n\n", AREA_LENGTH);
            break;
        }
        flash_chip++;
    }
}
void define_block(unsigned int block_count, unsigned int block_size)
{
  unsigned int  i;
  if (block_addr == 0)  block_addr = FLASH_MEMORY_START;
  for (i = 1; i <= block_count; i++)
  {
     block_total++;
     blocks[block_total] = block_addr;
     block_addr = block_addr + block_size;
  }
}
void sflash_config(void)
{
   flash_chip_type*   flash_chip = flash_chip_list;
   int counter = 0;
   printf("\nManual Flash Selection ...\n");
   while (flash_chip->vendid)
   {
      counter++;
      if (counter == selected_fc)
      {
         vendid = flash_chip->vendid;
         devid  = flash_chip->devid;
         identify_flash_part();
         break;
      }
      flash_chip++;
   }
   if (strcasecmp(flash_part,"")==0) printf("*** Unknown or NO Flash Chip Selected ***\n");
}
void sflash_probe(void)
{
    //int retries = 0;
    int retries = 30;
    int check1= check;
    check = 0;
    if (strcasecmp(AREA_NAME,"CUSTOM")==0)
    {
        FLASH_MEMORY_START = selected_window;
    }
    else
    {
        switch (proc_id)
        {
        case IXP425_266:
        case IXP425_400:
            //   case IXP425_533:
            //       FLASH_MEMORY_START = 0x50000000;
            //       break;
        case ARM_940T:
            FLASH_MEMORY_START = 0x00400000;
            break;
        case 0x0635817F:
            FLASH_MEMORY_START = 0x1F000000;
            break;
//    case ATH_PROC:
//        FLASH_MEMORY_START = 0xA8000000;
//        break;
        default:
            if (flash_size >= size8MB )
            {
                FLASH_MEMORY_START = 0x1c000000;
            }
            else
            {
                FLASH_MEMORY_START = 0x1FC00000;
            }
        }
    }
    printf("\nProbing Flash at (Flash Window: 0x%08x) ", FLASH_MEMORY_START);
again:
    strcpy(flash_part,"");
    // Probe using cmd_type for AMD
    if (strcasecmp(flash_part,"")==0)
    {
        cmd_type = CMD_TYPE_AMD;
        sflash_reset();
        ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START + (0x2AA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00900090);
        vendid = ejtag_read_h(FLASH_MEMORY_START);
        devid  = ejtag_read_h(FLASH_MEMORY_START+2);
        if (Flash_DEBUG)
        {
            printf("\nDebug AMD Vendid :    ");
            ShowData (vendid,31);
            printf("Debug AMD Devdid :    ");
            ShowData (devid,31);
        }
        identify_flash_part();
    }
    if (strcasecmp(flash_part,"")==0)
    {
        cmd_type = CMD_TYPE_SST;
        sflash_reset();
        ejtag_write_h(FLASH_MEMORY_START + (0x5555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START + (0x2AAA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START + (0x5555 << 1), 0x00900090);
        vendid = ejtag_read_h(FLASH_MEMORY_START);
        devid  = ejtag_read_h(FLASH_MEMORY_START+2);
        if (Flash_DEBUG)
        {
            printf("\nDebug SST Vendid :    ");
            ShowData (vendid,31);
            printf("Debug SST Devdid :    ");
            ShowData (devid,31);
        }
        identify_flash_part();
    }
    // Probe using cmd_type for BSC & SCS
    if (strcasecmp(flash_part,"")==0)
    {
        cmd_type = CMD_TYPE_BSC;
        sflash_reset();
        ejtag_write_h(FLASH_MEMORY_START, 0x00900090);
        vendid = ejtag_read(FLASH_MEMORY_START);
        devid  = ejtag_read(FLASH_MEMORY_START+2);
        if (Flash_DEBUG)
        {
            printf("\nDebug BSC-SCS Vendid :");
            ShowData (vendid,31);
            printf("Debug BCS-SCS Devdid :");
            ShowData (devid,31);
        }
        identify_flash_part();
    }
    if (strcasecmp(flash_part,"")==0)
    {
        int id;
        cmd_type = CMD_TYPE_SPI;
        if (bcmproc)
        {
            id = spiflash_sendcmd(BCM_SPI_RD_ID);
            //id2 = spiflash_sendcmd(BCM_SPI_RD_RES);
        }
        else
        id = spiflash_sendcmd(SPI_RD_ID);
        id <<= 8;
        id = byteSwap_32(id);
        vendid = id >> 16;
        devid  = id & 0x0000ffff;
        if (Flash_DEBUG)
        {
            printf("\nDebug SPI id :    ");
            ShowData (id,31);
            printf("\nDebug SPI Vendid :    ");
            ShowData (vendid,31);
            printf("Debug SPI Devdid :    ");
            ShowData (devid,31);
        }
        identify_flash_part();
    }
    if (strcasecmp(flash_part,"")==0)
    {
        if (retries--)
            goto again;
        else
        {
            printf("Done\n\n");
            printf("*** Unknown or NO Flash Chip Detected ***");
            waitTime(300000);
        }
    }
    check = check1;
    return;
}
int spiflash_poll(void)
{
    int reg, finished=0;
    /* Check for ST Write In Progress bit */
    spiflash_sendcmd(SPI_RD_STATUS);
    reg = ejtag_read(spi_flash_data);
    if (!(reg & SPI_STATUS_WIP))
    {
        finished = TRUE;
        printf("REG SPIFLASH_POLL 0x%08x\n", reg);
    }
    while (!finished);
    return 0;
}
uint32_t spiflash_regread32(int reg)
{
    uint32_t data = ejtag_read( spi_flash_mmr + reg );
    if (Flash_DEBUG)
        printf("REGREAD32 data 0x%08x spi_flash_mmr 0x%08x reg 0x%08x\n", data, spi_flash_mmr, reg );
    return data;
}
static void spiflash_regwrite32(int reg, uint32_t data)
{

    ejtag_write(spi_flash_mmr + reg, data );
    if (Flash_DEBUG)
        printf("REG 0x%08x REGWRITE32 0x%08x\n", reg, data);

    return;
}
uint32_t spiflash_sendcmd(int op)
{
    uint32_t reg, mask;
    struct opcodes *ptr_opcode;
    ptr_opcode = &stm_opcodes[op];
    if (bcmproc)
        ejtag_write(0x18000040, 0x0000);
    /* wait for CPU spiflash activity. */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    /* send the command */
    spiflash_regwrite32(spi_flash_opcode, ptr_opcode->code);
    if (Flash_DEBUG)
        printf("SPI_FLASH_OPCODE 0x%08x PTR_OPCODE 0x%08x\n", spi_flash_opcode, ptr_opcode->code);
    if (bcmproc)
        reg = (reg  & ~SPI_CTL_TX_RX_CNT_MASK) | ptr_opcode->code | spi_ctl_start;
    else
        reg = (reg & ~SPI_CTL_TX_RX_CNT_MASK) | ptr_opcode->tx_cnt | (ptr_opcode->rx_cnt << 4)| spi_ctl_start;
    spiflash_regwrite32(spi_flash_ctl, reg);
    if (Flash_DEBUG)
        printf("SPI_FLASH_CTL SEND -> 0x%08x reg 0x%08x\n", spi_flash_ctl, reg);
    /* wait for CPU spiflash activity */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    if (ptr_opcode->rx_cnt > 0)
    {
        reg = (uint32_t) spiflash_regread32(spi_flash_data);
        switch (ptr_opcode->rx_cnt)
        {
        case 1:
            mask = 0x000000ff;
            break;
        case 2:
            mask = 0x0000ffff;
            break;
        case 3:
            mask = 0x00ffffff;
            break;
        default:
            mask = 0xffffffff;
            break;
        }
        reg &= mask;
    }
    else
    {
        reg = 0;
    }
    return reg;
}
int spi_chiperase(uint32_t offset)
{
    ejtag_write(0x18000040, 0x0000);
    spiflash_sendcmd(SPI_WRITE_ENABLE);
    ejtag_write(BRCM_FLASHADDRESS, offset);
    ejtag_write(0x18000040, 0x800000c7);
    return 0;
}
static int spiflash_erase_block( uint32_t addr )
{
    struct opcodes *ptr_opcode;
    uint32_t temp, reg;
    int finished = FALSE;
    /* We are going to do 'sector erase', do 'write enable' first. */
    if (bcmproc)
        ptr_opcode = &stm_opcodes[BCM_SPI_SECTOR_ERASE];
    else
        ptr_opcode = &stm_opcodes[SPI_SECTOR_ERASE];
    if (bcmproc)
        ejtag_write(0x18000040, 0x0000);
    spiflash_sendcmd(SPI_WRITE_ENABLE);
    /* we are not really waiting for CPU spiflash activity, just need the value of the register. */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    /* send our command */
    if (bcmproc)
        temp = ((uint32_t) addr) | (uint32_t)(ptr_opcode->code);
    else
        temp = ((uint32_t) addr << 8) | (uint32_t)(ptr_opcode->code);
    spiflash_regwrite32(spi_flash_opcode, temp);
    if (bcmproc)
        reg = (reg & ~SPI_CTL_TX_RX_CNT_MASK) | ptr_opcode->code | spi_ctl_start;
    else
        reg = (reg & ~SPI_CTL_TX_RX_CNT_MASK) | ptr_opcode->tx_cnt | spi_ctl_start;
    spiflash_regwrite32(spi_flash_ctl, reg );
    if (bcmproc)
        ejtag_write(0x18000040, 0x0000);
    /* wait for CPU spiflash activity */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    /* wait for 'write in progress' to clear */
    do
    {
        if (bcmproc)
            reg = spiflash_sendcmd(BCM_SPI_RD_STATUS);
        else
            reg = spiflash_sendcmd(SPI_RD_STATUS);
        if (!(reg & SPI_STATUS_WIP)) finished = TRUE;
    }
    while (!finished);
    return (0);
}
void spiflash_write_word(uint32_t addr, uint32_t data)
{
    int finished;
    uint32_t reg, opcode;
    if (bcmproc)
    {
        ejtag_write(spi_flash_ctl, 0x000);
        spiflash_sendcmd(BCM_SPI_WRITE_ENABLE);
    }
    else
        spiflash_sendcmd(SPI_WRITE_ENABLE);
    /* we are not really waiting for CPU spiflash activity, just need the value of the register. */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    /* send write command */
    spiflash_regwrite32(spi_flash_data, data);
    if (bcmproc)
        opcode = (addr);
    else
        opcode = STM_OP_PAGE_PGRM | (addr << 8);
    spiflash_regwrite32(spi_flash_opcode, opcode);
    if (bcmproc)
        reg = (reg & ~SPI_CTL_TX_RX_CNT_MASK) | 0x0402 | spi_ctl_start;
    else
        reg = (reg & ~SPI_CTL_TX_RX_CNT_MASK) | (4 + 4) | spi_ctl_start;
    spiflash_regwrite32(spi_flash_ctl, reg);
    if (Flash_DEBUG)
        printf("spi_flash_ctl 0x%08x reg 0x%08x\n", spi_flash_ctl, reg);

    finished = 0;
    /* wait CPU spi activity */
    do
    {
        reg = spiflash_regread32(spi_flash_ctl);
    }
    while (reg & spi_ctl_busy);
    do
    {
        if (bcmproc)
            reg = spiflash_sendcmd(BCM_SPI_RD_STATUS);
        else
            reg = spiflash_sendcmd(SPI_RD_STATUS);
        if (!(reg & SPI_STATUS_WIP))
        {
            finished = TRUE;
        }
    }
    while (!finished);
}
void sflash_poll(unsigned int addr, unsigned int data)
{
    if ((cmd_type == CMD_TYPE_BSC) || (cmd_type == CMD_TYPE_SCS))
    {
        // Wait Until Ready
        while ( (ejtag_read_h(FLASH_MEMORY_START) & STATUS_READY) != STATUS_READY );
    }
    else
    {
        // Wait Until Ready
        while ( (ejtag_read_h(addr) & STATUS_READY) != (data & STATUS_READY) );
    }
}
void sflash_erase_block(unsigned int addr)
{
    if (cmd_type == CMD_TYPE_SPI)
    {
        spiflash_erase_block(addr);
    }
    if (cmd_type == CMD_TYPE_AMD)
    {
            //Unlock Block
        ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00800080);
        //Erase Block
        ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
        ejtag_write_h(addr, 0x00300030);
        // Wait for Erase Completion
        sflash_poll(addr, 0xFFFF);
    }
    if (cmd_type == CMD_TYPE_SST)
    {
        //Unlock Block
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00800080);
        //Erase Block
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
        ejtag_write_h(addr, 0x00500050);
        // Wait for Erase Completion
        sflash_poll(addr, 0xFFFF);
    }
    if ((cmd_type == CMD_TYPE_BSC) || (cmd_type == CMD_TYPE_SCS))
    {
        //Unlock Block
        ejtag_write_h(addr, 0x00500050);     // Clear Status Command
        ejtag_write_h(addr, 0x00600060);     // Unlock Flash Block Command
        ejtag_write_h(addr, 0x00D000D0);     // Confirm Command
        ejtag_write_h(addr, 0x00700070);
        // Wait for Unlock Completion
        sflash_poll(addr, STATUS_READY);
        //Erase Block
        ejtag_write_h(addr, 0x00500050);     // Clear Status Command
        ejtag_write_h(addr, 0x00200020);     // Block Erase Command
        ejtag_write_h(addr, 0x00D000D0);     // Confirm Command
        ejtag_write_h(addr, 0x00700070);
        // Wait for Erase Completion
        sflash_poll(addr, STATUS_READY);
    }
    sflash_reset();
}
void chip_erase(void)
{
    printf("Chip Erase\n");
    FLASH_MEMORY_START = (0x1fc0000);
    //Unlock Block
    ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
    ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
    ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00800080);
    //Erase Block
    ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
    ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
    ejtag_write_h(0x1fc00000, 0x00100010);
}
void sflash_reset(void)
{
    if ((cmd_type == CMD_TYPE_AMD) || (cmd_type == CMD_TYPE_SST))
    {
        ejtag_write_h(FLASH_MEMORY_START, 0x00F000F0);    // Set array to read mode
    }
    if ((cmd_type == CMD_TYPE_BSC) || (cmd_type == CMD_TYPE_SCS))
    {
        ejtag_write_h(FLASH_MEMORY_START, 0x00500050);    // Clear CSR
        ejtag_write_h(FLASH_MEMORY_START, 0x00ff00ff);    // Set array to read mode
    }
}
void sflash_write_word(unsigned int addr, unsigned int data)
{
    unsigned int data_lo, data_hi;
    if (USE_DMA)
    {
        // DMA Uses Byte Lanes
        data_lo = data;
        data_hi = data;
    }
    else
    {
        // PrAcc Does Not
        // Speedtouch does not accept flashing with DMA, so you have to use /nodma
        data_lo = (data & 0xFFFF);
        data_hi = ((data >> 16) & 0xFFFF);
    }
    if (cmd_type == CMD_TYPE_SPI)
    {
        spiflash_write_word(addr, data);
    }
    if (cmd_type == CMD_TYPE_AMD)
    {
        if (cl_bypass)
        {
            if (proc_id == 0x00000001)
            {
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr+2, data_lo);
                tnano(100);
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr, data_hi);
                tnano(100);
            }
            else
            {
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr, data_lo);
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr+2, data_hi);
            }
        }
        else
            if (speedtouch || proc_id == 0x00000001)
            {
                // Speedtouch uses a different flash address pattern.
                // Handle Half Of Word
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
                ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr+2, data_lo);
                // Wait for Completion
                sflash_poll(addr, (data & 0xffff));
                // Now Handle Other Half Of Word
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00AA00AA);
                ejtag_write_h(FLASH_MEMORY_START+(0x2AA << 1), 0x00550055);
                ejtag_write_h(FLASH_MEMORY_START+(0x555 << 1), 0x00A000A0);
                ejtag_write_h(addr, data_hi);
                // Wait for Completion
                sflash_poll(addr+2, ((data >> 16) & 0xffff));
            }
            else
            {
                ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
                ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
                ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00A000A0);
                ejtag_write_h(addr, data_lo);
                // Wait for Completion
                sflash_poll(addr, (data & 0xffff));
                // Now Handle Other Half Of Word
                ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
                ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
                ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00A000A0);
                ejtag_write_h(addr+2, data_hi);
                // Wait for Completion
                sflash_poll(addr+2, ((data >> 16) & 0xffff));
            }
    }
    if (cmd_type == CMD_TYPE_SST)
    {
        // Handle Half Of Word
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00A000A0);
        ejtag_write_h(addr, data_lo);
        // Wait for Completion
        sflash_poll(addr, (data & 0xffff));
        // Now Handle Other Half Of Word
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00AA00AA);
        ejtag_write_h(FLASH_MEMORY_START+(0x2AAA << 1), 0x00550055);
        ejtag_write_h(FLASH_MEMORY_START+(0x5555 << 1), 0x00A000A0);
        ejtag_write_h(addr+2, data_hi);
        // Wait for Completion
        sflash_poll(addr+2, ((data >> 16) & 0xffff));
    }
    if ((cmd_type == CMD_TYPE_BSC) || (cmd_type == CMD_TYPE_SCS))
    {
        // Handle Half Of Word
        ejtag_write_h(addr, 0x00500050);     // Clear Status Command
        ejtag_write_h(addr, 0x00400040);     // Write Command
        ejtag_write_h(addr, data_lo);        // Send HalfWord Data
//       ejtag_write_h(addr, 0x00700070);     // Check Status Command
        // Wait for Completion
        sflash_poll(addr, STATUS_READY);
        // Now Handle Other Half Of Word
        ejtag_write_h(addr+2, 0x00500050);   // Clear Status Command
        ejtag_write_h(addr+2, 0x00400040);   // Write Command
        ejtag_write_h(addr+2, data_hi);      // Send HalfWord Data
        //     ejtag_write_h(addr+2, 0x00700070);   // Check Status Command
        sflash_poll(addr, STATUS_READY);
    }
}
void show_usage(void)
{

   flash_chip_type*      flash_chip = flash_chip_list;
   processor_chip_type*  processor_chip = processor_chip_list;
   int counter = 0;

   printf( " ABOUT: This program reads/writes flash memory on compatible routers \n"
           "        via EJTAG using either DMA Access routines or PrAcc routines. \n"
           "        (slower/more compatible).\n"
           "        The following Processor chips are supported:\n\n"
           "            Supported Chips\n"
           "            ---------------\n");
           while (processor_chip->chip_id)
           {
              printf("            %-40.40s\n", processor_chip->chip_descr);
              processor_chip++;
           }
   printf( "\n\n");
   printf( " USAGE: wrt54g [parameter] </optional-switch> ... </optional-switch> \n\n"
           "            Required parameter is one of this list:\n"
           "            ------------------\n"
           "            -backup:cfe\n"
           "            -backup:nvram\n"
           "            -backup:kernel\n"
           "            -backup:wholeflash\n"
           "            -backup:custom\n"
           "            -backup:bsp\n"
           "            -erase:cfe\n"
           "            -erase:nvram\n"
           "            -erase:kernel\n"
           "            -erase:wholeflash\n"
           "            -erase:custom\n"
           "            -erase:bsp\n"
           "            -flash:cfe\n"
           "            -flash:nvram\n"
           "            -flash:kernel\n"
           "            -flash:wholeflash\n"
           "            -flash:custom\n"
           "            -flash:bsp\n"
           "            -probeonly\n"
           "            -probeonly:custom\n"
           "            -erase:, -flash: wgrv8bdata, wgrv9bdata, cfe128\n"
           "            -----------------\n"
           "            Optional Switches:\n"
           "            -----------------\n"
           "            /noreset ........... prevent Issuing EJTAG CPU reset\n"
           "            /noemw ............. prevent Enabling Memory Writes\n"
           "            /nocwd ............. prevent Clearing CPU Watchdog Timer\n"
           "            /nobreak ........... prevent Issuing Debug Mode JTAGBRK\n"
           "            /noerase ........... prevent Forced Erase before Flashing\n"
           "            /notimestamp ....... prevent Timestamping of Backups\n"
           "            /dma ............... force use of DMA routines\n"
           "            /nodma ............. force use of PRACC routines (No DMA)\n"
           "            /window:XXXXXXXX ... custom flash window base (in HEX)\n"
           "            /start:XXXXXXXX .... custom start location (in HEX)\n"
           "            /length:XXXXXXXX ... custom length (in HEX)\n"
           "            /silent ............ prevent scrolling display of data\n"
           "            /skipdetect ........ skip auto detection of CPU Chip ID\n"
           "            /instrlen:XX ....... set instruction length manually\n"
           "            /hir:XX ............ custom istruktion prefix\n"
           "            /tir:XX ............ custom istruktion postfix\n"
           "            /hdr:XX ............ custom data prefix\n"
           "            /tdr:XX ............ custom data postfix\n"
           "            /bypass ............ autodedect trailer bits\n"
           "            /clbypass .......... enables unlock bypass command for\n"
           "                                 some AMD/Spansion type flashes,\n"
           "                                 it also disables polling\n\n"
           "            /debug1 ............ display EJTAG states, \n"
           "                                 only if compiled for debug\n"
           "            /dedub2 ............ show all EJTAG states, \n"
           "                                 only if compiled for debug\n"
           "            /dedug ............. show all CPU read/write\n"
           "            /test .............. manual set of ports, siglstep, ...\n"
           "            /check ............. check every flash write\n"
           "            /fc:XX ............. Optional (Manual) Flash Chip Selection\n"
           "            /dv:XX ............. Optional (Manual) CPU Chip Selection\n"
           "            /wiggler ........... use wiggler cable, this option is no\n"
           "                                 logeger supported, \n"
           "            /st5 ............... Use Speedtouch ST5xx flash routines \n"
           "                                 instead of WRT routines\n"
           "            /reboot............. sets the process and reboots\n"
           "            /swap_endian........ swap endianess during backup - most \n"
           "                                 Atheros based routers\n"
           "            /flash_debug........ flash chip debug messages, show flash \n"
           "                                 MFG and Device ID\n\n"
           "            -----------------------------------------------\n");
           while (flash_chip->vendid)
           {
              printf("            /fc:%02d ............. %-40.40s\n", ++counter, flash_chip->flash_part);
              flash_chip++;
           }
   printf( "\n\n");
   printf( " NOTES: 1) If 'flashing' - the source filename must exist as follows:\n"
           "           CFE.BIN, NVRAM.BIN, KERNEL.BIN, WHOLEFLASH.BIN or CUSTOM.BIN\n"
           "           BSP.BIN\n\n"
           "        2) If you have difficulty auto-detecting a particular flash \n"
           "           you can manually specify your flash type using the /fc:XX option.\n\n"
           "        3) If you have difficulty with the older bcm47xx chips or when no CFE\n"
           "           is currently active/operational you may want to try both the\n"
           "           /noreset and /nobreak command line options together.  Some bcm47xx\n"
           "           chips *may* always require both these options to function properly.\n\n"
           "        4) When using this utility, usually it is best to type the command line\n"
           "           out, then plug in the router, and then hit <ENTER> quickly to avoid\n"
           "           the CPUs watchdog interfering with the EJTAG operations.\n\n"
           "        5) Test option useds a subset off keys to set or toggle port lines.\n"
           "           You my use single nuber keys followed by the enter key or multible\n"
           "           keys followed by the enter key, in this way you produce a puttern.\n"
           "           Use this to make sure the hardware is connected correcly.\n"
           "           You may also us the test mode to enter the states of the tap bus.\n"
           "           So you could progam a chip step by step as well, if it would not\n"
           "           be to timeconsuming. But for lerning and displaying the states,\n"
           "           this is usefull.\n"
           " .............................................................................\n"
           " If /bypass is used some off the the folllowing parameters may still be needed. \n"
           " .............................................................................\n"
           "     Parameter           Name                                Description\n"
           " .............................................................................\n"
           "hir   Header            The number of bits to shift before the target set of\n"
           "      Instruction       instruction bits. These bits put the non-target devices\n"
           "      Register          after the target device into bypass mode.\n"
           "                        The 'hir' value must be equivalent to the sum of\n"
           "                        instruction register lengths for devices following the\n"
           "                        target device in the scan chain.\n"
           "tir   Trailer           The number of bits to shift after the target set of\n"
           "      Instruction       instruction bits. These bits put the non-target devices\n"
           "      Register          before the target device into bypass mode.\n"
           "                        The 'tir' value must be equivalent to the sum of\n"
           "                        instruction register lengths for devices preceding the\n"
           "                        target device in the scan chain.\n"
           "hdr   Header Data       The number of (zero) bits to shift before the target set\n"
           "      Register          of data bits. These bits are placeholders that fill the\n"
           "                        bypass data registers in the non-target devices after\n"
           "                        the target device. One bit for a device.\n"
           "                        The 'hdr' value must be equivalent to the sum of devices\n"
           "                        following the target device in the scan chain.\n"
           "tdr   Trailer Data      The number of (zero) bits to shift after the target set\n"
           "      Register          of data bits. These bits are placeholders that fill the\n"
           "                        bypass data registers in the non-target devices before\n"
           "                        the target device. One bit for a device.\n"
           "                        The 'tdr' value must be equivalent to the sum of devices\n"
           " ***************************************************************************\n"
           " * Flashing the KERNEL or WHOLEFLASH will take a very long time using JTAG *\n"
           " * via this utility.  You are better off flashing the CFE & NVRAM files    *\n"
           " * & then using the normal TFTP method to flash the KERNEL via ethernet.   *\n"
           " ***************************************************************************\n\n");
}
unsigned char ATstatus_reg(void)
{
    unsigned char status;

    ejtag_write(0x1fc00000, 0x57);
    status = ejtag_read(0x1fc00000 &0x80);
    printf("id bit = 0x%08x\n", status&0x3c);
    ShowData(status,32);
    return status;
}
unsigned int ATready(void)
{
    int status;
    for (;;)
    {
        status = ATstatus_reg();
        status = (status&0xF<<7);
//        printf("status1 = 0x%08x\n", status);
//        ShowData(status,32);
        if (status != 0x80)
        {
            //  printf("Status BSY 0x%08x\n", status);
            status = 0;
            tnano(10000);
        }
        if (status == 0x80)	/* RDY/nBSY */
            return status;
    }
}
void mscan(void)
{
    unsigned int addr = 0x18000000, val=0, i;
    for (i=0; i < 20000; i++)
    {
        // val = ((ejtag_read(addr)) &CID_ID_MASK);
        val = ejtag_dma_read(addr);
        // if (val != NULL && val != 0x0);
        printf("data 0x%08x addr 0x%08x\n", val, addr);
        addr += 0x100;
    }
}
void isbrcm(void)
{
    /*
                if ((proc_id & 0xfff) == 0x17f)
                {
                    struct chipcregs *cc;
                    uint32_t reg;
                    unsigned long osh = 0x18000000; //0x18000000;
                    cc = (chipcregs_t *)osh;
                    reg = ejtag_read((uintptr_t) &cc->chipid) &CID_ID_MASK;
                    printf("\n\nChip id %x\n", reg);
                    reg = ejtag_read((uintptr_t) &cc->chipid) &CID_REV_MASK;
                    reg = (reg >> CID_REV_SHIFT);
                    printf("Chip Rev %x\n", reg);
                    reg = ejtag_read((uintptr_t) &cc->chipid) &CID_PKG_MASK;
                    reg = (reg >> CID_PKG_SHIFT);
                    printf("Package Options %x\n", reg);
                    reg = ejtag_read((uintptr_t) &cc->chipid) &CID_CC_MASK;
                    reg = (reg >> CID_CC_SHIFT);
                    printf("Number of Cores %x\n", reg );
                    reg = ejtag_read((uintptr_t) &cc->chipid) & 0x00007000;
                    reg = ((reg >> 8) |  0x0000000F);
                    printf("Core Revision %x\n",  reg);
                    reg = ejtag_read((uintptr_t) &cc->chipid) & 0x00008FF0;
                    printf("Core Type %x\n", reg);
                    reg = ejtag_read((uintptr_t) &cc->chipid) & 0xFFFF0000;
                    printf("Core Vendor ID %x\n", reg);
                    reg = ejtag_read((uintptr_t) &cc->capabilities) &CC_CAP_FLASH_MASK;
                    printf("Flash Type %x\n", reg);
                    printf("REG = %lu CC = %lu \n", sizeof(reg ), sizeof(cc->chipid) );
                    switch (reg)
                    {
                    case FLASH_NONE:
                        printf("Flash Type = FLASH_NONE\n");
                        break;
                    case SFLASH_ST:
                        printf("Flash Type = SFLASH_ST\n");
                        break;
                    case SFLASH_AT:
                        printf("Flash Type = FLASH_AT\n");
                        break;
                    case PFLASH:
                        printf("Flash Type = PFLASH\n");
                        break;
                    default:
                        break;
                    }
                    reg = ejtag_read((unsigned long) &cc->capabilities) &CC_CAP_MIPSEB;
                    if (reg == 0)
                    {
                        printf("Endian Type is LE %x\n", reg);
                    }
                    else
                        printf("Endian Type is BE %x\n", reg);
                    reg = ejtag_read((unsigned long) &cc->capabilities) &CC_CAP_PLL_MASK;
                    printf("PLL Type %08x\n", reg);
                }
    */
    if ((proc_id & 0x00000fff) == 0x17f)
    {
        bcmproc = 1;
        spi_flash_read = BRCM_SPI_READ;
        spi_flash_mmr = BRCM_SPI_MMR;
        spi_flash_mmr_size = BRCM_SPI_MMR_SIZE;
        spi_flash_ctl = BRCM_SPI_CTL;
        spi_flash_opcode = BRCM_SPI_OPCODE;
        spi_flash_data = BRCM_SPI_DATA;
        spi_ctl_start = BRCM_SPI_CTL_START;
        spi_ctl_busy = BRCM_SPI_CTL_BUSY;
    }
    else
    {
        spi_flash_read = AR531XPLUS_SPI_READ;
        spi_flash_mmr = AR531XPLUS_SPI_MMR;
        spi_flash_mmr_size = AR531XPLUS_SPI_MMR_SIZE;
        spi_flash_ctl = AR531XPLUS_SPI_CTL;
        spi_flash_opcode = AR531XPLUS_SPI_OPCODE;
        spi_flash_data = AR531XPLUS_SPI_DATA;
        spi_ctl_start = AR_SPI_CTL_START;
        spi_ctl_busy = AR_SPI_CTL_BUSY;
    }
    if (Flash_DEBUG)
    {
        printf("spi_flash_read 0x%08x\n", spi_flash_read);
        printf("spi_flash_mmr  0x%08x\n", spi_flash_mmr);
        printf("spi_flash_mmr_size 0x%08x\n", spi_flash_mmr_size);
        printf("spi_flash_ctl  0x%08x\n", spi_flash_ctl);
        printf("spi_flash_opcode 0x%08x\n", spi_flash_opcode);
        printf("spi_flash_data 0x%08x\n", spi_flash_data);
        printf("spi_ctl_start 0x%08x\n", spi_ctl_start );
        printf("spi_ctl_busy 0x%08x\n", spi_ctl_busy);
    }
}
void run_load(char *filename, unsigned int start)
{
    unsigned int addr, data ;
    FILE *fd ;
    size_t result;
    int counter = 0;
    int percent_complete = 0;
    unsigned int length = 0;
    time_t start_time = time(0);
    time_t end_time, elapsed_seconds;
    printf("*** You Selected to program the %s ***\n\n",filename);
    fd=fopen(filename, "rb" );
    if (fd<=0)
    {
        fprintf(stderr,"Could not open %s for reading\n", filename);
        exit(1);
    }
    // get file size
    fseek(fd, 0, SEEK_END);
    length = ftell(fd);
    fseek(fd, 0, SEEK_SET);
    printf("===============================\n");
    printf("Programming RAM Routine Started\n");
    printf("===============================\n");
    printf("\nLoading %s to RAM...\n",filename);
    for (addr=start; addr<(start+length); addr+=4)
    {
        counter += 4;
        percent_complete = (counter * 100 / length);
        if (!silent_mode)
            if ((addr&0xF) == 0)  printf("[%3d%%]   %08x: ", percent_complete, addr);
        result = fread((unsigned char*) &data, 1,sizeof(data), fd);
        ejtag_write(addr, data);
        if (silent_mode)  printf("%4d%%   bytes = %d (%08x)@(%08x)=%08x\r", percent_complete, counter, counter, addr, data);
        else              printf("%08x%c", data, (addr&0xF)==0xC?'\n':' ');
        fflush(stdout);
        data = 0xFFFFFFFF;  // This is in case file is shorter than expected length
    }
    fclose(fd);
    printf("Done  (%s loaded into Memory OK)\n\n",filename);
    sflash_reset();
    printf("================================\n");
    printf("Programming RAM Routine Complete\n");
    printf("================================\n");
    time(&end_time);
    elapsed_seconds = difftime(end_time, start_time);
    printf("elapsed time: %d seconds\n", (int)elapsed_seconds);
    /*
        printf("Resuming Processor ... ");
        WriteIR(INSTR_CONTROL);
        ReadWriteData((PRACC | PROBEN | PROBTRAP) & ~JTAGBRK,32 );
        if (ReadWriteData(PRACC | PROBEN | PROBTRAP) & BRKST,32)
            printf("<Processor is in the Run Mode!> ... ");
        else
            printf("<Processor is in the Debug Mode!> ... ");
        ReadWriteData(PRRST | PERRST,32);
        printf("Done\n");
    */
}
void unlock_bypass(void)
{
    ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00900090 ); /* unlock bypass reset */
    ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00aa00aa ); /* unlock bypass */
    ejtag_write_h(FLASH_MEMORY_START + (0x2aa << 1), 0x00550055 );
    ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00200020 );
    printf("\nEntered Unlock bypass mode->\n");
}
void unlock_bypass_reset(void)
{
    ejtag_write_h(FLASH_MEMORY_START + (0x555 << 1), 0x00900090 ); /* unlock bypass reset */
    ejtag_write_h(FLASH_MEMORY_START + (0x000), 0x00000000 );
}
int main(int argc, char** argv)
{
    char choice[128];
    int run_option;
    int j;
    printf("\n");
    printf("==================================================\n");
    printf("WRT54G/GS/AVM/Speedport EJTAG Debrick Utility v5.2\n");
    printf("==================================================\n");
    if (argc < 2)
    {
        show_usage();
        exit(1);
    }
    strcpy(choice,argv[1]);
    run_option = 0;
    if (strcasecmp(choice,"-backup:cfe")==0)                { run_option = 1; strcpy(AREA_NAME, "CFE"); }
    if (strcasecmp(choice,"-backup:cf1")==0)                { run_option = 1; strcpy(AREA_NAME, "CF1"); }
    if (strcasecmp(choice,"-backup:cfe128")==0)             { run_option = 1; strcpy(AREA_NAME, "CFE128"); }
    if (strcasecmp(choice,"-backup:nvram")==0)              { run_option = 1; strcpy(AREA_NAME, "NVRAM"); }
    if (strcasecmp(choice,"-backup:kernel")==0)             { run_option = 1; strcpy(AREA_NAME, "KERNEL"); }
    if (strcasecmp(choice,"-backup:wholeflash")==0)         { run_option = 1; strcpy(AREA_NAME, "WHOLEFLASH"); }
    if (strcasecmp(choice,"-backup:custom")==0)             { run_option = 1; strcpy(AREA_NAME, "CUSTOM"); custom_options++; }
    if (strcasecmp(choice,"-backup:bsp")==0)                { run_option = 1; strcpy(AREA_NAME, "BSP"); }
    if (strcasecmp(choice,"-backup:red")==0)                { run_option = 1; strcpy(AREA_NAME, "RED"); }
    if (strcasecmp(choice,"-backup:wgrv8bdata")==0)         { run_option = 1; strcpy(AREA_NAME, "WGRV8BDATA"); }
    if (strcasecmp(choice,"-backup:wgrv9bdata")==0)         { run_option = 1; strcpy(AREA_NAME, "WGRV9BDATA"); }
    if (strcasecmp(choice,"-erase:cfe")==0)                 { run_option = 2; strcpy(AREA_NAME, "CFE"); }
    if (strcasecmp(choice,"-erase:wgrv9bdata")==0)          { run_option = 2; strcpy(AREA_NAME, "WGRV9BDATA"); }
    if (strcasecmp(choice,"-erase:wgrv9nvram")==0)          { run_option = 2; strcpy(AREA_NAME, "WGRV9NVRAM"); }
    if (strcasecmp(choice,"-erase:wgrv8bdata")==0)          { run_option = 2; strcpy(AREA_NAME, "WGRV8BDATA"); }
    if (strcasecmp(choice,"-erase:cf1")==0)                 { run_option = 2; strcpy(AREA_NAME, "CF1"); }
    if (strcasecmp(choice,"-erase:cfe128")==0)              { run_option = 2; strcpy(AREA_NAME, "CFE128"); }
    if (strcasecmp(choice,"-erase:nvram")==0)               { run_option = 2; strcpy(AREA_NAME, "NVRAM"); }
    if (strcasecmp(choice,"-erase:kernel")==0)              { run_option = 2; strcpy(AREA_NAME, "KERNEL"); }
    if (strcasecmp(choice,"-erase:wholeflash")==0)          { run_option = 2; strcpy(AREA_NAME, "WHOLEFLASH"); }
    if (strcasecmp(choice,"-erase:custom")==0)              { run_option = 2; strcpy(AREA_NAME, "CUSTOM"); custom_options++; }
    if (strcasecmp(choice,"-erase:bsp")==0)                 { run_option = 2; strcpy(AREA_NAME, "BSP"); }
    if (strcasecmp(choice,"-spi_chiperase")==0)             { run_option = 6;}
    if (strcasecmp(choice,"-erase:red")==0)                 { run_option = 2; strcpy(AREA_NAME, "RED"); }
    if (strcasecmp(choice,"-flash:cfe")==0)                 { run_option = 3; strcpy(AREA_NAME, "CFE"); }
    if (strcasecmp(choice,"-flash:cf1")==0)                 { run_option = 3; strcpy(AREA_NAME, "CF1"); }
    if (strcasecmp(choice,"-flash:cfe128")==0)              { run_option = 3; strcpy(AREA_NAME, "CFE128"); }
    if (strcasecmp(choice,"-flash:nvram")==0)               { run_option = 3; strcpy(AREA_NAME, "NVRAM"); }
    if (strcasecmp(choice,"-flash:wgrv8bdata")==0)          { run_option = 3; strcpy(AREA_NAME, "WGRV8BDATA"); }
    if (strcasecmp(choice,"-flash:wgrv9bdata")==0)          { run_option = 3; strcpy(AREA_NAME, "WGRV9BDATA"); }
    if (strcasecmp(choice,"-flash:kernel")==0)              { run_option = 3; strcpy(AREA_NAME, "KERNEL"); }
    if (strcasecmp(choice,"-flash:wholeflash")==0)          { run_option = 3; strcpy(AREA_NAME, "WHOLEFLASH"); }
    if (strcasecmp(choice,"-flash:custom")==0)              { run_option = 3; strcpy(AREA_NAME, "CUSTOM"); custom_options++; }
    if (strcasecmp(choice,"-flash:bsp")==0)                 { run_option = 3; strcpy(AREA_NAME, "BSP"); }
    if (strcasecmp(choice,"-flash:red")==0)                 { run_option = 3; strcpy(AREA_NAME, "RED"); }
    if (strcasecmp(choice,"-probeonly")==0)                 { run_option = 4; }
    if (strcasecmp(choice,"-probeonly:custom")==0)          { run_option = 4; strcpy(AREA_NAME, "CUSTOM"); }
    if (strncasecmp(choice,"-load:", 5)==0)                 { run_option = 5; strcpy(AREA_NAME, &choice[6]); }
    if (run_option == 0)                                    { show_usage(); printf("\n*** ERROR - Invalid [option] specified ***\n\n"); exit(1); }
    if (argc > 2)
    {
        j = 2;
        while (j < argc)
        {
            strcpy(choice,argv[j]);
            if (strcasecmp(choice,"/noreset")==0)              	issue_reset = 0;
            else if (strcasecmp(choice,"/noemw")==0)           	issue_enable_mw = 0;
            else if (strcasecmp(choice,"/nocwd")==0)           	issue_watchdog = 0;
            else if (strcasecmp(choice,"/nobreak")==0)         	issue_break = 0;
            else if (strcasecmp(choice,"/noerase")==0)         	issue_erase = 0;
            else if (strcasecmp(choice,"/notimestamp")==0)     	issue_timestamp = 0;
            else if (strcasecmp(choice,"/dma")==0)             	force_dma = 1;
            else if (strcasecmp(choice,"/nodma")==0)           	force_nodma = 1;
            else if (strncasecmp(choice,"/fc:",4)==0)          	selected_fc = strtoul(((char *)choice + 4),NULL,10);
            else if (strncasecmp(choice,"/window:",8)==0)    	{ selected_window = strtoul(((char *)choice + 8),NULL,16); custom_options++;  }
            else if (strncasecmp(choice,"/start:",7)==0)     	{ selected_start  = strtoul(((char *)choice + 7),NULL,16); custom_options++;  }
            else if (strncasecmp(choice,"/length:",8)==0)    	{ selected_length = strtoul(((char *)choice + 8),NULL,16); custom_options++;  }
            else if (strcasecmp(choice,"/bypass")==0)           setBypass = 1;
            else if (strcasecmp(choice,"/clbypass")==0)         cl_bypass = 1;
            else if (strcasecmp(choice, "/reboot")==0)          issue_reboot = 1;
            else if (strncasecmp(choice,"/window:",8)==0)      	{ selected_window = strtoul(((char *)choice + 8),NULL,16); custom_options++; probe_options++; }
            else if (strncasecmp(choice,"/start:",7)==0)        { selected_start  = strtoul(((char *)choice + 7),NULL,16); custom_options++; }
            else if (strncasecmp(choice,"/length:",8)==0)       { selected_length = strtoul(((char *)choice + 8),NULL,16);custom_options++; }
            else if (strncasecmp(choice,"/instrlen:",10)==0)   	instrlen = strtoul(((char *)choice + 10),NULL,10);
            else if (strcasecmp(choice,"/silent")==0)          	silent_mode = 1;
            else if (strcasecmp(choice,"/skipdetect")==0)      	skipdetect = 1;
            else if (strcasecmp(choice,"/wiggler")==0)         	wiggler = 1;
            else if (strcasecmp(choice,"/st5")==0)		        speedtouch = 1;
            else if (strcasecmp(choice,"/flash_debug")==0)     	Flash_DEBUG = 1;
            else if (strncasecmp(choice,"/freq:",6)==0)        	frequency = strtoul(((char *)choice + 6),NULL,10);
            else if (strcasecmp(choice,"/xbit")==0)            	xbit = 1;
            else if (strcasecmp(choice,"/swap_endian")==0)      swap_endian = 1;
            else if (strcasecmp(choice,"/debug")==0)        	debug = 1;
    #ifdef DEBUG
            else if (strcasecmp(choice,"/debug1")==0)        	debug1 = 1;
            else if (strcasecmp(choice,"/debug2")==0)        	{debug2 = 1; debug1 = 1;}
    #endif
            else if (strcasecmp(choice,"/test")==0)        	    {test = 1; debug2 = 1;}
            else if (strcasecmp(choice,"/check")==0)        	check = 1;
            else if (strncasecmp(choice,"/dv:",4)==0)           { selected_device = (strtoul(((char *)choice + 4),NULL,10)); if (selected_device) selected_device -=1;}
            else if (strncasecmp(choice,"/hir:",5)==0)    	    selected_hir = strtoul(((char *)choice + 5),NULL,10);
            else if (strncasecmp(choice,"/tir:",5)==0)   		selected_tir = strtoul(((char *)choice + 5),NULL,10);
            else if (strncasecmp(choice,"/hdr:",5)==0)    	    selected_hdr = strtoul(((char *)choice + 5),NULL,10);
            else if (strncasecmp(choice,"/tdr:",5)==0)    	    selected_tdr = strtoul(((char *)choice + 5),NULL,10);
            else if (strcasecmp(choice,"/old")==0)        	    old = 1;
            else
            {
             //show_usage();
             printf("\n*** ERROR - Invalid <option> specified ***\n\n");
             exit(1);
            }
          j++;
       }
    }
    if (strcasecmp(AREA_NAME,"CUSTOM")==0)
    {
       if ((run_option != 4) && (custom_options != 0) && (custom_options != 4))
       {
           show_usage();
           printf("\n*** ERROR - 'CUSTOM' also requires '/window' '/start' and '/length' options ***\n\n");
           exit(1);
       }
       if ((run_option == 4) && (probe_options != 1))
       {
           show_usage();
           printf("\n*** ERROR - 'PROBEONLY:CUSTOM' requires '/window' option ***\n\n");
           exit(1);
       }
    }
    // ----------------------------------
    lpt_openport();
    printf("\n***-----------------------------------------------------------------***\n\n");
    //Initialize the chain to ensure we start from the RTI state
    //tap_reset();
    // ----------------------------------
    if (test) { test_ports();} else
    {
      // Detect Chain length
      // ----------------------------------
      if (! skipdetect || setBypass) {detectChainLength();int i; if (! debug2 ) { for(i = 0  ; i < 10000 ; i++){tap_reset();}}}
      // ----------------------------------
      // Detect CPU
      // ----------------------------------
      if (old) chip_detecty();
      else chip_detect();
      // ----------------------------------
      // Find Implemented EJTAG Features
      // ----------------------------------
      printf("\ncheck EJTAG ... \n");
      check_ejtag_features();
      // ----------------------------------
      // Reset State Machine For Good Measure
      // ----------------------------------
      printf("\nTAP reset ... \n");
      tap_reset();
      if (issue_reset)
      {
        if ((proc_id & 0xfffffff) == 0x535417f)
        {
        printf("\nIssuing Processor / Peripheral Reset ... \n");
        WriteIR(INSTR_CONTROL);
        WriteData(PRRST | PERRST,32);
        WriteData(0,32);
        printf("Done\n");
        }
        else
        {
        printf("\nIssuing Processor / Peripheral Reset ... \n");
        WriteIR(INSTR_CONTROL);
        ctrl_reg = ReadWriteData(PRRST | PERRST,32);
        if (debug) { printf("PRRST | PERRST: ");  ShowData(PRRST | PERRST,32); printf("in <- : "); ShowData(ctrl_reg,32); printf("\n");}
        printf("Done\n");
        }
      }
      // ----------------------------------
      // Enable Memory Writes
      // ----------------------------------
      // Always skip for EJTAG versions 2.5 and 2.6 since they do not support DMA transactions.
      // Memory Protection bit only applies to EJTAG 2.0 based chips.
      if (ejtag_version != 0)  issue_enable_mw = 0;
      if (issue_enable_mw)
      {
        printf("Enabling Memory Writes ... ");
        // Clear Memory Protection Bit in DCR
        ejtag_dma_write(0xff300000, (ejtag_dma_read(0xff300000) & ~(1<<2)) );
        printf("Done\n");
      }
      else printf("Enabling Memory Writes Skipped\n");
      // ----------------------------------
      // Put into EJTAG Debug Mode
      // ----------------------------------
      //
      if (issue_break)
      {
        //printf("\nTAP reset ... \n");
        //tap_reset();
        printf("-- > Halting Processor ... \n");
        WriteIR(INSTR_CONTROL);
        ctrl_reg = ReadWriteData(PRACC | PROBEN | SETDEV | JTAGBRK,32);
        if (debug) { printf("out-> PRACC | PROBEN | SETDEV | JTAGBRK: "); ShowData(PRACC | PROBEN | SETDEV | JTAGBRK,32); printf("in <- : "); ShowData(ctrl_reg,32);}
        ctrl_reg = ReadWriteData(PRACC | PROBEN | SETDEV,32);
        if (debug) { printf("out-> PRACC | PROBEN | SETDEV: "); ShowData(PRACC | PROBEN | SETDEV,32); printf("in <- : "); ShowData(ctrl_reg,32);}
        if (debug) { printf("BRKST ? ");  ShowData(BRKST,32); printf("\n");}
        if ( !(ctrl_reg & BRKST))  printf("!!! Processor did NOT enter Debug Mode !!! --> Programexecution stoped!\n");
        else
        {
         printf("<------ Processor Entered Debug Mode ------>\n");
         // ----------------------------------
         // Clear Watchdog
         // ----------------------------------
         if (issue_watchdog)
         {
            if (proc_id == 0x00000001)
            {
                printf("Atheros - Clearing Watchdog (0xb8000080) ... Done\n");
                ejtag_write(0xbc003000, 0xffffffff);
                ejtag_write(0xbc003008, 0); // Atheros AR5312
                ejtag_write(0xbc004000, 0x05551212);
                printf("Done\n");
            }
            else
            {
                printf("Clearing Watchdog (0xb8000080) ... Done\n");
                ejtag_write(0xb8000080,0);
                printf("Done\n");
            }
        }
        isbrcm(); //set broadcom or spi registers
        //mscan();
        //------------------------------------
        // Enable Flash Read/Write for Atheros
        //------------------------------------
        if (proc_id == 0x00000001)
        {
            printf("\nEnabling Atheros Flash Read/Write ... ");
            //ejtag_write(0xb8400000, 0x000e3ce1); //8bit
            ejtag_write(0xb8400000, 0x100e3ce1); //16bit
            printf("Done\n");
        //----------------------------------------------------------------
        // Enable Flash Read/Write for Atheros and check Revision Register
        //
        // Ejtag IDCODE does not tell us what Atheros Processor it has found..
        // so lets try to detect via the Revision Register
            printf("\n.RE-Probing Atheros processor....");
            uint32_t ARdevid;
            ARdevid = (ejtag_read(AR5315_SREV) &AR5315_REV_MAJ) >> AR5315_REV_MAJ_S;
            switch (ARdevid)
            {
            case 0x9:
                printf("\n..Found a Atheros AR2317\n");
                break;
                /* FIXME: how can we detect AR2316? */
            case 0x8:
                printf("\n..Found a Atheros AR2316\n");
                break;
            default:
                //mips_machtype = ATHEROS AR2315;
                break;
            }
        }
        //printf("\nTAP reset ... \n");
        //tap_reset();
        // ----------------------------------
        // Flash Chip Detection
        //printf("<------ flash ------>\n");
        // ----------------------------------
        if (selected_fc != 0) sflash_config(); else sflash_probe();
        // ----------------------------------
        // Execute Requested Operation
        // ----------------------------------
        if ((flash_size > 0) && (AREA_LENGTH > 0))
        {
    		if (run_option == 1 )  run_backup(AREA_NAME, AREA_START, AREA_LENGTH);
    		if (run_option == 2 )  run_erase(AREA_NAME, AREA_START, AREA_LENGTH);
    		if (run_option == 3 )  run_flash(AREA_NAME, AREA_START, AREA_LENGTH);
        ////        if (run_option == 4 ) {};  // Probe was already run so nothing else needed
        }
        if (run_option == 5 )  run_load(AREA_NAME, 0x80040000);
        if (run_option == 6 )  spi_chiperase(0x1fc00000);
	    printf("\n\n *** REQUESTED OPERATION IS COMPLETE ***\n\n");
        if (issue_reboot)
        {
            printf("Reset Processor ...\n");
            ExecuteDebugModule(pracc_read_depc);
            printf("DEPC: 0x%08x\n", data_register);
            address_register = 0xA0000000;
            data_register    = 0xBFC00000;
            //data_register    -= 4;
            ExecuteDebugModule(pracc_write_depc);
            // verify my return address
            ExecuteDebugModule(pracc_read_depc);
            printf("DEPC: 0x%08x\n", data_register);
        }
        if (proc_id == 0x00000001)
        {
            printf("Resuming Processor ...\n");
            return_from_debug_mode();
            WriteIR(INSTR_RESET);
            tap_reset();
            WriteIR(INSTR_CONTROL);
            ctrl_reg = ReadWriteData(PRRST | PERRST,32);
            printf(" ECR: 0x%08x\n", ctrl_reg);
        }
       }
      }
    } //not test end
    waitTime(300000);
    chip_shutdown();
    lpt_closeport();
    return 0;
} //main ende
// **************************************************************************
// **************************************************************************
// End of File
// **************************************************************************
