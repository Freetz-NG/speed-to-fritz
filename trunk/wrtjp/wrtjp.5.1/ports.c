/*******************************************************/
/* file: ports.c                                       */
/* abstract:  This file contains the routines to       */
/*            output values on the JTAG ports, to read */
/*            the TDO bit, and to read a byte of data  */
/*            from the prom                            */
/*                                                     */
/*******************************************************/
#include "ports.h"
#include "stdio.h"
#if ( defined(linux) || defined(__linux))
  #define LINUX_VERSION
#else
  #define WINDOWS_VERSION
#endif
// #define __FreeBSD__       // uncomment only this for FreeBSD
#ifdef WINDOWS_VERSION
#include "inpout32.h"    // our non-system header in quotes
//     HINSTANCE hLib;
//   #include "conio.h"
   #include <windows.h>
   #define strcasecmp  stricmp
   #define strncasecmp strnicmp
   #define PPORT_BASE ((short) 0x378)
   #define SPORT_BASE ((short) 0x379)
#else
   #include <unistd.h>
   #ifdef __FreeBSD__
      #include <dev/ppbus/ppi.h>
      #include <dev/ppbus/ppbconf.h>
      #define PPWDATA PPISDATA
      #define PPRSTATUS PPIGSTATUS
    #else
      #include <linux/ppdev.h>
      #include <sys/ioctl.h>
    #endif
#endif

typedef union outPortUnion {
    unsigned char value;
    struct opBitsStr {
    PPort
    } bits;
} outPortType;

typedef union inPortUnion {
    unsigned char value;
    struct ipBitsStr {
    SPort
    } bits;
} inPortType;

static inPortType in_word;
static outPortType out_word;
static int once = 0;

int pfd;


void lpt_openport(void)
{
   #ifdef WINDOWS_VERSION
   // Attempt to initialize the interface
    if (inpout32_init() != 0) {
          fprintf(stderr,
               "ERROR: Failed to initialize giveio.sys interface!\n giveio.sys must be preset within the same directory.\n Run ddw_ntdriver.exe as well!");
        exit (-1);
     }
   #else
      #ifdef __FreeBSD__
         pfd = open("/dev/ppi0", O_RDWR);
         if (pfd < 0)   {   perror("Failed to open /dev/ppi0");   exit(0);   }
         if ((ioctl(pfd, PPEXCL) < 0) || (ioctl(pfd, PPCLAIM) < 0))  {   perror("Failed to lock /dev/ppi0");   close(pfd);   exit(0);   }
      #else
         pfd = open("/dev/parport0", O_RDWR);
         if (pfd < 0)   {   perror("Failed to open /dev/parport0");   exit(0);   }
         if ((ioctl(pfd, PPEXCL) < 0) || (ioctl(pfd, PPCLAIM) < 0))   {   perror("Failed to lock /dev/parport0");   close(pfd);   exit(0);   }
      #endif
   #endif
}
void lpt_closeport(void)
{
   #ifdef WINDOWS_VERSION
    //  inpout32_unload();
   #else
      #ifndef __FreeBSD__
         if (ioctl(pfd, PPRELEASE) < 0)  {  perror("Failed to release /dev/parport0");  close(pfd);  exit(0);  }
      #endif
      close(pfd);
   #endif

}
void setPort(short p,short val)
{
   if (once == 0) {
        out_word.bits.one = 1;
        out_word.bits.zero = 0;
        once = 1;
    }
    if (p==TMS)
        out_word.bits.tms = (unsigned char) val;
    if (p==TDI)
        out_word.bits.tdi = (unsigned char) val;
    if (p==TCK) {
        out_word.bits.tck = (unsigned char) val;
    #ifdef WINDOWS_VERSION
        /// Write the data register
        Out32(PPORT_BASE, out_word.value );
    #else
        ioctl(pfd, PPWDATA, &out_word.value);
    #endif
    }
}
/* toggle tck LH */
void pulseClock()
{
    setPort(TCK,0);  /* set the TCK port to low  */
    setPort(TCK,1);  /* set the TCK port to high */
}
/* read the TDO bit from port */
unsigned char readTDOBit()
{
    #ifdef WINDOWS_VERSION
     /* Try to read */
	in_word.value = Inp32(SPORT_BASE);
    #else
	ioctl(pfd, PPRSTATUS, &in_word.value);
    #endif
    return (!! (in_word.bits.tdo));
}
/* Wait at least the specified number of microsec.                           */
/* Use a timer if possible; otherwise estimate the number of instructions    */
/* necessary to be run based on the microcontroller speed.  For this example */
/* we pulse the TCK port a number of times based on the processor speed.     */
void waitTime(long microsec)
{
    static long tckCyclesPerMicrosec    = 1;
    long        tckCycles   = microsec * tckCyclesPerMicrosec;
    long        i;
    /* For systems with TCK rates >= 1 MHz;  This implementation is fine. */
    for ( i = 0; i < tckCycles; ++i )
    {
        pulseClock();
    }
}
