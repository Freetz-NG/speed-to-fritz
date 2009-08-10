/**  @file inpout32.h
     @brief Header file for inpout32
       (DLL Interface and Wrapper).

     Find more information about Inpout32 at
     http://www.logix4u.net/inpout32.htm

<br> Copyright (C) 2007 Douglas Beattie Jr
<br> beattidp@ieee.org
<br> http://www.hytherion.com/beattidp/

     @note
	Last change: DBJR 12/25/2007 7:42:08 PM
*/

/* Definitions in the build of inpout32.dll are:            */
/*   short _stdcall Inp32(short PortAddress);               */
/*   void _stdcall Out32(short PortAddress, short data);    */

/* prototype (function typedef) for DLL function Inp32: */

typedef short (_stdcall *inpfuncPtr)(short portaddr);
typedef void (_stdcall *oupfuncPtr)(short portaddr, short datum);

extern int inpout32_init(void);
extern void inpout32_unload(void);
extern short Inp32(short portaddr);
extern void Out32(short portaddr,short datum);

