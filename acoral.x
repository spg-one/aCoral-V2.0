
acoral.elf:     file format elf32-littlearm
acoral.elf
architecture: armv4t, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000010

Program Header:
    LOAD off    0x00010010 vaddr 0x00000010 paddr 0x00000010 align 2**16
         filesz 0x00000c14 memsz 0x00000c14 flags rwx
private flags = 5000200: [Version5 EABI] [soft-float ABI]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000c14  00000010  00000010  00010010  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .bss          00000000  00000c24  00000c24  00010c24  2**0
                  ALLOC
  2 .ARM.attributes 00000026  00000000  00000000  00010c24  2**0
                  CONTENTS, READONLY
  3 .comment      00000075  00000000  00000000  00010c4a  2**0
                  CONTENTS, READONLY
  4 .debug_line   000004f5  00000000  00000000  00010cbf  2**0
                  CONTENTS, READONLY, DEBUGGING
  5 .debug_info   000002e7  00000000  00000000  000111b4  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_abbrev 00000198  00000000  00000000  0001149b  2**0
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_aranges 00000080  00000000  00000000  00011638  2**3
                  CONTENTS, READONLY, DEBUGGING
  8 .debug_str    000001f4  00000000  00000000  000116b8  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_frame  00000138  00000000  00000000  000118ac  2**2
                  CONTENTS, READONLY, DEBUGGING
SYMBOL TABLE:
00000010 l    d  .text	00000000 .text
00000c24 l    d  .bss	00000000 .bss
00000000 l    d  .ARM.attributes	00000000 .ARM.attributes
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    df *ABS*	00000000 hal/src/start.o
0000006c l       .text	00000000 ResetHandler
00000050 l       .text	00000000 HandleUndef
00000054 l       .text	00000000 HandleSWI
0000005c l       .text	00000000 HandlePabort
00000058 l       .text	00000000 HandleDabort
00000048 l       .text	00000000 HandleFIQ
00000060 l       .text	00000000 _text_start
00000064 l       .text	00000000 _bss_start
00000068 l       .text	00000000 _bss_end
00000224 l       .text	00000000 memsetup
000001c0 l       .text	00000000 InitStacks
000000e8 l       .text	00000000 copy_self
00000248 l       .text	00000000 mem_clear
00000114 l       .text	00000000 copy_from_rom
00000130 l       .text	00000000 copy_from_nand
00000174 l       .text	00000000 ok_nand_read
00000154 l       .text	00000000 bad_nand_read
00000180 l       .text	00000000 go_next
0000019c l       .text	00000000 notmatch
000001bc l       .text	00000000 out
00000260 l       .text	00000000 mem_cfg_val
00000000 l    df *ABS*	00000000 ch1.c
00000000 l    df *ABS*	00000000 hal/src/hal_int_s.o
00000000 l    df *ABS*	00000000 hal_nand.c
00000488 l     F .text	00000060 nand_wait
000004e8 l     F .text	00000080 nand_reset
000005a4 l     F .text	00000194 is_bad_block
00000738 l     F .text	000001b0 nand_read_page
000008e8 l     F .text	00000090 nand_read_id
00000418 g       .text	00000000 EXP_HANDLER
0000045c g       .text	00000000 HAL_INTR_RESTORE
000003dc g       .text	00000000 HAL_INTR_ENTRY
00000200 g       *ABS*	00000000 IRQ_stack_size
00000568 g     F .text	0000003c nand_init
00000978 g     F .text	000002ac nand_read
00000010 g       .text	00000000 __ENTRY
00000448 g       .text	00000000 HAL_INTR_DISABLE
00000200 g       *ABS*	00000000 SVC_stack_size
33ffff00 g       *ABS*	00000000 stack_base
00000c24 g       *ABS*	00000000 heap_start
00000100 g       *ABS*	00000000 Abort_stack_size
00000438 g       .text	00000000 HAL_INTR_ENABLE
00000464 g       .text	00000000 HAL_INTR_DISABLE_SAVE
000002cc g     F .text	00000110 acoral_start
33fffd00 g       *ABS*	00000000 ABT_stack
00000c24 g       .bss	00000000 bss_end
00000000 g       *ABS*	00000000 FIQ_stack_size
00000200 g       *ABS*	00000000 SYS_stack_size
00000c24 g       .bss	00000000 bss_start
33fffc00 g       *ABS*	00000000 UDF_stack
00000100 g       *ABS*	00000000 Undef_stack_size
33f00000 g       *ABS*	00000000 MMU_base
00000010 g       .text	00000000 text_start
33fff900 g       *ABS*	00000000 SYS_stack
33eff000 g       *ABS*	00000000 heap_end
0000004c g       .text	00000000 HandleIRQ
33ffff00 g       *ABS*	00000000 IRQ_stack
33ffff00 g       *ABS*	00000000 FIQ_stack
33fffb00 g       *ABS*	00000000 SVC_stack


