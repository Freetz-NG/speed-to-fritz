/*****************************************************************************
* File:         micro.h
* Description:  This header file contains the function prototype to the
*               primary interface function for the XSVF player.
* Usage:        FIRST - PORTS.C
*               Customize the ports.c function implementations to establish
*               the correct protocol for communicating with your JTAG ports
*               (setPort() and readTDOBit()) "agepasst! rest nicht geaendert,
*		micro.c main funktion entfernt"
*		and tune the waitTime() delay
*               function.  Also, establish access to the XSVF data source
*               in the readByte() function.
*               FINALLY - Call xsvfExecute().
*****************************************************************************/
#ifndef XSVF_MICRO_H
#define XSVF_MICRO_H

/* Legacy error codes for xsvfExecute from original XSVF player v2.0 */
#define XSVF_LEGACY_SUCCESS 1
#define XSVF_LEGACY_ERROR   0

/* 4.04 [NEW] Error codes for xsvfExecute. */
/* Must #define XSVF_SUPPORT_ERRORCODES in micro.c to get these codes */
#define XSVF_ERROR_NONE         0
#define XSVF_ERROR_UNKNOWN      1
#define XSVF_ERROR_TDOMISMATCH  2
#define XSVF_ERROR_MAXRETRIES   3   /* TDO mismatch after max retries */
#define XSVF_ERROR_ILLEGALCMD   4
#define XSVF_ERROR_ILLEGALSTATE 5
#define XSVF_ERROR_DATAOVERFLOW 6   /* Data > lenVal MAX_LEN buffer size*/
/* Insert new errors here */
#define XSVF_ERROR_LAST         7

/*****************************************************************************
* Function:     xsvfExecute
* Description:  Process, interpret, and apply the XSVF commands.
*               See port.c:readByte for source of XSVF data.
*               xsvfExecute supports dynamic device target assignment.
* Parameters:   iHir    - # bits to shift before instruction.
*                       = Sum of IR lengths following target device.
*               iTir    - # bits to shift after instruction.
*                       = Sum of IR lengths prior to target device.
*               iHdr    - # bits to shift before data.
*                       = # of devices (BYPASS reg.) following target device.
*               iTdr    - # bits to shift after data.
*                       = # of devices (BYPASS reg.) prior to target device.
*               iHdrFpga- # bits to shift before FPGA data.
*                       = special 32-bit alignment.
* Returns:      int - For error codes see above.
*****************************************************************************/
extern int xsvfExecute( int iHir, int iTir, int iHdr, int iTdr, int iHdrFpga );

#endif  /* XSVF_MICRO_H */

