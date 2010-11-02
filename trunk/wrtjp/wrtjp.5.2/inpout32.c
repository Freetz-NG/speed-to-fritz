/**  @file inpout32.c
     @brief DLL Interface and Wrapper for Inpout32.
*/
#include <windows.h>
#include <stdio.h>
#include "inpout32.h"

// Local pointers to functions
static inpfuncPtr inp32fp = NULL;
static oupfuncPtr oup32fp = NULL;

static HINSTANCE hLib;

int inpout32init(void)
{

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
//Alternativ with Giveio.sys is three times faster!
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
HANDLE Giveio_Handle;
int inpout32_init(void)
{
    /* Open Port Driver or try installing and starting it */
    Giveio_Handle = CreateFile("\\\\.\\Giveio", GENERIC_READ,
      0, NULL, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL, NULL);
      if(Giveio_Handle == INVALID_HANDLE_VALUE) {
           StartGiveioDriver();
            /* Once more, before failing */
        Giveio_Handle = CreateFile("\\\\.\\Giveio", GENERIC_READ,
            0, NULL, OPEN_EXISTING,
            FILE_ATTRIBUTE_NORMAL, NULL);
            CloseHandle(Giveio_Handle);
    }
    if (Giveio_Handle != INVALID_HANDLE_VALUE) return 0; else return 1;
}
void InstallGiveioDriver(void)
{
    SC_HANDLE  SchSCManager;
    SC_HANDLE  schService;
    DWORD      err;
    CHAR         DriverFileName[80];

    if (!GetSystemDirectory(DriverFileName, 55))
        {
         printf("Giveio: Failed to get System Directory.\n");
         printf("Copy Giveio.sys to your system32/driver directory.\n");
        }
    /* Append Driver Name */
    lstrcat(DriverFileName,"\\Drivers\\Giveio.sys");
    printf("Giveio: Copying driver to %s\n",DriverFileName);
    /* Copy Driver to System32/drivers directory, fails if the file doesn't exist. */

    if (!CopyFile("Giveio.sys", DriverFileName, FALSE))
        {
         printf("Giveio: Failed to copy driver to %s\n",DriverFileName);
         printf("Giveio: Please manually copy driver to your system32/driver directory.\n");
        }
    /* Open Handle to Service Control Manager */
    SchSCManager = OpenSCManager (NULL,                   /* machine (NULL == local) */
                                  NULL,                   /* database (NULL == default) */
                                  SC_MANAGER_ALL_ACCESS); /* access required */

    /* Create Service/Driver - This adds the appropriate registry keys in */
    /* HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services - It doesn't  */
    /* care if the driver exists, or if the path is correct.              */
    schService = CreateService (SchSCManager,                      /* SCManager database */
                                "Giveio",                          /* name of service */
                                "Giveio",                          /* name to display */
                                SERVICE_ALL_ACCESS,                /* desired access */
                                SERVICE_KERNEL_DRIVER,             /* service type */
                                SERVICE_DEMAND_START,              /* start type */
                                SERVICE_ERROR_NORMAL,              /* error control type */
                                "System32\\Drivers\\Giveio.sys",   /* service's binary */
                                NULL,                              /* no load ordering group */
                                NULL,                              /* no tag identifier */
                                NULL,                              /* no dependencies */
                                NULL,                              /* LocalSystem account */
                                NULL                               /* no password */
                                );
    if (schService == NULL) {
         err = GetLastError();
         if (err == ERROR_SERVICE_EXISTS)
               printf("Giveio: Driver exists. No action taken.\n");
         else  printf("Giveio: Unknown error while creating Service.\n");
    }
    else printf("Giveio: Driver successfully installed.\n");
    /* Close Handle to Service Control Manager */
    CloseServiceHandle (schService);
}
void CloseGiveio(void)
{
    CloseHandle(Giveio_Handle);
}
unsigned char StartGiveioDriver(void)
{
    SC_HANDLE  SchSCManager;
    SC_HANDLE  schService;
    BOOL       ret;
    DWORD      err;
    /* Open Handle to Service Control Manager */
    SchSCManager = OpenSCManager (NULL,                        /* machine (NULL == local) */
                                  NULL,                        /* database (NULL == default) */
                                  SC_MANAGER_ALL_ACCESS);      /* access required */

    if (SchSCManager == NULL)
      if (GetLastError() == ERROR_ACCESS_DENIED) {
         printf("Giveio: You do not have permission to access the Service Control Manager,\n");
         printf("Giveio: the Giveio driver is not installed or started.  \n");
         printf("Giveio: Use administrator rights to install the driver.\n");
         return(0);
         }
    do {
         /* Open a Handle to the Giveio Service Database */
         schService = OpenService(SchSCManager,         /* handle to service control manager database */
                                  "Giveio",             /* pointer to name of start of service */
                                  SERVICE_ALL_ACCESS);  /* type of access */

         if (schService == NULL)
            switch (GetLastError()){
                case ERROR_ACCESS_DENIED:
                        printf("Giveio: You do not have permission to the Giveio service database\n");
                        return(0);
                case ERROR_INVALID_NAME:
                        printf("Giveio: The specified service name is invalid.\n");
                        return(0);
                case ERROR_SERVICE_DOES_NOT_EXIST:
                        printf("Giveio: The Giveio driver does not exist. Installing driver.\n");
                        //printf("Giveio: Wait, this can take up to 30 seconds ...\n");
                        InstallGiveioDriver();
                        break;
            }
         } while (schService == NULL);
    ret = StartService (schService,    /* service identifier */
                        0,             /* number of arguments */
                        NULL);         /* pointer to arguments */
    if (ret) printf("Giveio: The Giveio driver has been successfully started.\n");
    else {
        err = GetLastError();
        if (err == ERROR_SERVICE_ALREADY_RUNNING)
          printf("Giveio: Driver is already running.\n");
        else {
          printf("Giveio: Unknown error while starting driver service.\n");
          printf("Does Giveio.sys exist in your \\System32\\Drivers Directory?\n");
          InstallGiveioDriver();
          return(1);
        }
    }
    /* Close handle to Service Control Manager */
    CloseServiceHandle (schService);
    return(TRUE);
}
