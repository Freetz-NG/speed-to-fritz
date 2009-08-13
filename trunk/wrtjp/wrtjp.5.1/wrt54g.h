// **************************************************************************
//  Written by HairyDairyMaid (a.k.a. - lightbulb)
//  hairydairymaid@yahoo.com
//  Some changes made by johann.pascher at gmail.com
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
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
// --- JPascher Statemachine ---
#define TAP_TEST_LOGIC_RESET 1
#define TAP_RUN_TEST_IDLE 2
#define TAP_SELECT_DR_SCAN 3
#define TAP_CAPTURE_DR 4
#define TAP_SHIFT_DR 5
#define TAP_EXIT1_DR 6
#define TAP_PAUSE_DR 7
#define TAP_EXIT2_DR 8
#define TAP_UPDATE_DR 9
#define TAP_SELECT_IR_SCAN 10
#define TAP_CAPTURE_IR 11
#define TAP_SHIFT_IR 12
#define TAP_EXIT1_IR 13
#define TAP_PAUSE_IR 14
#define TAP_EXIT2_IR 15
#define TAP_UPDATE_IR 16
//ESC
#define ESC_CODE  27
/* definitions made by aka*/
#define true  1
#define false 0
#define RETRY_ATTEMPTS 16
// --- Some EJTAG Instruction Registers ---
#define INSTR_EXTEST    0x00
#define INSTR_IDCODE    0x01
#define INSTR_SAMPLE    0x02
#define INSTR_IMPCODE   0x03
#define INSTR_ADDRESS   0x08
#define INSTR_DATA      0x09
#define INSTR_CONTROL   0x0A
#define INSTR_BYPASS    0xFF
// --- Some EJTAG Bit Masks ---
#define TOF             (1 << 1 )
#define TIF             (1 << 2 )
#define BRKST           (1 << 3 )

#define DLOCK           (1 << 5 )


#define DRWN            (1 << 9 )
#define DERR            (1 << 10)
#define DSTRT           (1 << 11)
#define JTAGBRK         (1 << 12)

#define SETDEV          (1 << 14)
#define PROBEN          (1 << 15)
#define PRRST           (1 << 16)
#define DMAACC          (1 << 17)
#define PRACC           (1 << 18)
#define PRNW            (1 << 19)
#define PERRST          (1 << 20)

#define SYNC            (1 << 23)

#define DNM             (1 << 28)

#define ROCC            (1 << 31)

#define DMA_BYTE        0x00000000  //DMA tranfser size BYTE
#define DMA_HALFWORD    0x00000080  //DMA transfer size HALFWORD
#define DMA_WORD        0x00000100  //DMA transfer size WORD
#define DMA_TRIPLEBYTE  0x00000180  //DMA transfer size TRIPLEBYTE

#define  size4K        0x1000
#define  size8K        0x2000
#define  size16K       0x4000
#define  size32K       0x8000
#define  size64K       0x10000
#define  size128K      0x20000
#define  size256K      0x40000
#define  size512K      0x80000
#define  size1MB       0x100000
#define  size2MB       0x200000
#define  size4MB       0x400000
#define  size8MB       0x800000
#define  size16MB      0x1000000
#define  size32MB      0x2000000
#define  size64MB      0x4000000
#define  size128MB      0x8000000

#define  CMD_TYPE_BSC  0x01
#define  CMD_TYPE_SCS  0x02
#define  CMD_TYPE_AMD  0x03
#define  CMD_TYPE_SST  0x04

#define  STATUS_READY  0x0080

// EJTAG DEBUG Unit Vector on Debug Break
#define MIPS_DEBUG_VECTOR_ADDRESS           0xFF200200

// Our 'Pseudo' Virtual Memory Access Registers
#define MIPS_VIRTUAL_ADDRESS_ACCESS         0xFF200000
#define MIPS_VIRTUAL_DATA_ACCESS            0xFF200004

// --- Uhh, Just Because I Have To ---

/* read the TDO bit and clock out tms tdo first*/
static unsigned char clockin(int tms, int tdi);

static unsigned int ReadWriteData(unsigned int send_data, unsigned int count);
static unsigned int ReadData(unsigned int count);
void WriteData(unsigned int send_data, unsigned int count);
void WriteIR(int instr);
void ShowData(unsigned int value, unsigned int count);
void detectChainLength(void);
void tap_reset(void);
void count_Chain_length(int max_instruction_length);

void set_cain_position(int instr);
void chip_shutdown(void);
void chip_detect(void);

void jtag_tap_controller_state_machine(void);

static unsigned int ejtag_dma_read(unsigned int addr);
static unsigned int ejtag_dma_read_h(unsigned int addr);
void ejtag_dma_write(unsigned int addr, unsigned int data);
void ejtag_dma_write_h(unsigned int addr, unsigned int data);

static unsigned int ejtag_pracc_read(unsigned int addr);
static unsigned int ejtag_pracc_read_h(unsigned int addr);
static unsigned int ejtag_pracc_write(unsigned int addr, unsigned int data);
static unsigned int ejtag_pracc_write_h(unsigned int addr, unsigned int data);

static unsigned int ejtag_read(unsigned int addr);
static unsigned int ejtag_read_h(unsigned int addr);
void ejtag_write(unsigned int addr, unsigned int data);
void ejtag_write_h(unsigned int addr, unsigned int data);

void check_ejtag_features(void);

void sflash_probe(void);
void sflash_reset(void);
void sflash_config(void);
void identify_flash_part(void);

void define_block(unsigned int block_count, unsigned int block_size);

void sflash_erase_area(unsigned int start, unsigned int length);
void sflash_erase_block(unsigned int addr);
void sflash_write_word(unsigned int addr, unsigned int data);

void run_backup(char *filename, unsigned int start, unsigned int length);
void run_erase(char *filename, unsigned int start, unsigned int length);
void run_flash(char *filename, unsigned int start, unsigned int length);


static unsigned int ExecuteDebugModule(unsigned int *pmodule);
void show_usage(void);

unsigned int pracc_readword_code_module[] = {
               // #
               // # HairyDairyMaid's Assembler PrAcc Read Word Routine
               // #
               // start:
               //
               // # Load R1 with the address of the pseudo-address register
  0x3C01FF20,  // lui $1,  0xFF20
  0x34210000,  // ori $1,  0x0000
               //
               // # Load R2 with the address for the read
  0x8C220000,  // lw $2,  ($1)
               //
               // # Load R3 with the word @R2
  0x8C430000,  // lw $3, 0($2)
               //
               // # Store the value into the pseudo-data register
  0xAC230004,  // sw $3, 4($1)
               //
  0x00000000,  // nop
  0x1000FFF9,  // beq $0, $0, start
  0x00000000}; // nop
unsigned int pracc_writeword_code_module[] = {
               // #
               // # HairyDairyMaid's Assembler PrAcc Write Word Routine
               // #
               // start:
               //
               // # Load R1 with the address of the pseudo-address register
  0x3C01FF20,  // lui $1,  0xFF20
  0x34210000,  // ori $1,  0x0000
               //
               // # Load R2 with the address for the write
  0x8C220000,  // lw $2,  ($1)
               //
               // # Load R3 with the data from pseudo-data register
  0x8C230004,  // lw $3, 4($1)
               //
               // # Store the word at @R2 (the address)
  0xAC430000,  // sw $3,  ($2)
               //
  0x00000000,  // nop
  0x1000FFF9,  // beq $0, $0, start
  0x00000000}; // nop
unsigned int pracc_readhalf_code_module[] = {
               // #
               // # HairyDairyMaid's Assembler PrAcc Read HalfWord Routine
               // #
               // start:
               //
               // # Load R1 with the address of the pseudo-address register
  0x3C01FF20,  // lui $1,  0xFF20
  0x34210000,  // ori $1,  0x0000
               //
               // # Load R2 with the address for the read
  0x8C220000,  // lw $2,  ($1)
               //
               // # Load R3 with the half word @R2
  0x94430000,  // lhu $3, 0($2)
               //
               // # Store the value into the pseudo-data register
  0xAC230004,  // sw $3, 4($1)
               //
  0x00000000,  // nop
  0x1000FFF9,  // beq $0, $0, start
  0x00000000}; // nop
unsigned int pracc_writehalf_code_module[] = {
               // #
               // # HairyDairyMaid's Assembler PrAcc Write HalfWord Routine
               // #
               // start:
               //
               // # Load R1 with the address of the pseudo-address register
  0x3C01FF20,  // lui $1,  0xFF20
  0x34210000,  // ori $1,  0x0000
               //
               // # Load R2 with the address for the write
  0x8C220000,  // lw $2,  ($1)
               //
               // # Load R3 with the data from pseudo-data register
  0x8C230004,  // lw $3, 4($1)
               //
               // # Store the half word at @R2 (the address)
  0xA4430000,  // sh $3,  ($2)
               //
  0x00000000,  // nop
  0x1000FFF9,  // beq $0, $0, start
  0x00000000}; // nop
// **************************************************************************
// End of File
// **************************************************************************
