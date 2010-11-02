/*******************************************************/
/* file: ports.h                                       */
/* abstract:  This file contains extern declarations   */
/*            for providing stimulus to the JTAG ports.*/
/*******************************************************/

#define xsvf_iDebugLevel 1
//#define iDebugLevel 0
// #define WIGGLER  // define this if WIGGLER type interface is used
#ifndef ports_dot_h
#define ports_dot_h

/* these constants are used to send the appropriate ports to setPort */
/* they should be enumerated types, but some of the microcontroller  */
/* compilers don't like enumerated types */
#ifdef WIGGLER
// --- Wiggler Type Cable ---
#define PPort\
        unsigned char bit1:1;\
        unsigned char tms:1;\
        unsigned char tck:1;\
        unsigned char tdi:1;\
        unsigned char trst_n:1;\
        unsigned char zero:1;\
        unsigned char one:1;\
        unsigned char bit7:1;
#define SPort\
        unsigned char bit0:1;\
        unsigned char bit1:1;\
        unsigned char bit2:1;\
        unsigned char bit3:1;\
        unsigned char bit4:1;\
        unsigned char bit5:1;\
        unsigned char bit6:1;\
        unsigned char tdo:1;
#else
#define PPort\
        unsigned char tdi:1;\
        unsigned char tck:1;\
        unsigned char tms:1;\
        unsigned char zero:1;\
        unsigned char one:1;\
        unsigned char bit5:1;\
        unsigned char bit6:1;\
        unsigned char bit7:1;
#define SPort\
        unsigned char bit0:1;\
        unsigned char bit1:1;\
        unsigned char bit2:1;\
        unsigned char bit3:1;\
        unsigned char tdo:1;\
        unsigned char bit5:1;\
        unsigned char bit6:1;\
        unsigned char bit7:1;
#endif
#define TCK (short) 0
#define TMS (short) 1
#define TDI (short) 2


/* set the port "p" (TCK, TMS, or TDI) to val (0 or 1) */
extern void setPort(short p, short val);

/* read the TDO bit and store it in val */
extern unsigned char readTDOBit();


/* make clock go down->up->down*/
extern void pulseClock();

/* read the next byte of data from the xsvf file */
extern void readByte(unsigned char *data);

extern void waitTime(long microsec);

#endif
