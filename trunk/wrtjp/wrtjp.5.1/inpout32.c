/**  @file inpout32.c
     @brief DLL Interface and Wrapper for Inpout32.

     Find more information about Inpout32 at
     http://www.logix4u.net/inpout32.htm

<br> Copyright (C) 2007 Douglas Beattie Jr
<br> beattidp@ieee.org
<br> http://www.hytherion.com/beattidp/

     @note
	Last change: DBJR 12/25/2007 7:40:59 PM
*/
#include <windows.h>
#include <stdio.h>

#include "inpout32.h"  //our non-system header in quotes

// Local pointers to functions
static inpfuncPtr inp32fp = NULL;
static oupfuncPtr oup32fp = NULL;

static HINSTANCE hLib;

int inpout32init(void)
{

//     short x;
//     int i;

     /* Load the library */
     hLib = LoadLibrary("inpout32.dll");

     if (hLib == NULL) {

          fprintf(stderr,"LoadLibrary Failed.\n");
          return -1;
     }

     /* get the address of the function */

     inp32fp = (inpfuncPtr) GetProcAddress(hLib, "Inp32");

     if (inp32fp == NULL) {

          fprintf(stderr,"GetProcAddress for Inp32 Failed.\n");
          return -1;
     }

     oup32fp = (oupfuncPtr) GetProcAddress(hLib, "Out32");

     if (oup32fp == NULL) {

          fprintf(stderr,"GetProcAddress for Oup32 Failed.\n");
          return -1;
     }

     return 0;
}


void inpout32_unload(void)
{
     (void) FreeLibrary(hLib);

     return;
}


/* Wrapper Functions */

short  Inp_32 (short portaddr)
{
     return (inp32fp)(portaddr);
}

void  Out_32 (short portaddr, short datum)
{
     (oup32fp)(portaddr,datum);
}

//----------------------------------
//Alternativ with giveio.sys is three times faster!
unsigned char Inp32 ( short portaddr )
{
  unsigned char value;
  asm volatile
  (
    "in %1, %0" :
    "=a" (value) :
    "d" (portaddr)
  );
  return value;
}

void Out32 ( short portaddr, unsigned char value )
{
  asm volatile
  (
    "out %1, %0" ::
    "d" (portaddr), "a" (value)
  );
}

int inpout32_init(void)
{
  HANDLE h;
  h = CreateFile("\\\\.\\giveio", GENERIC_READ,
    0, NULL, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, NULL);
  CloseHandle(h);
  if (h != INVALID_HANDLE_VALUE) return 0; else return 1;
}


