/**  @file inpout32.h
     @brief Header file for inpout32
*/

/* Definitions in the build of inpout32.dll are:            */
/*   short _stdcall Inp32(short PortAddress);               */
/*   void _stdcall Out32(short PortAddress, short data);    */

/* prototype (function typedef) for DLL function Inp32: */

typedef short (_stdcall *inpfuncPtr)(short portaddr);
typedef void (_stdcall *oupfuncPtr)(short portaddr, short datum);

int inpout32_init(void);
void inpout32_unload(void);
extern unsigned char Inp32(short portaddr);
extern void Out32(short portaddr, unsigned char datum);
void InstallGiveioDriver(void);
void CloseGiveio(void);
unsigned char StartGiveioDriver(void);

