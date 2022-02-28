
acoral.elf:     file format elf32-littlearm
acoral.elf
architecture: armv4t, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x30000000

Program Header:
    LOAD off    0x00010000 vaddr 0x30000000 paddr 0x00000000 align 2**16
         filesz 0x00000c24 memsz 0x00000c24 flags rwx
private flags = 5000200: [Version5 EABI] [soft-float ABI]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000c24  30000000  00000000  00010000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .bss          00000000  30000c24  00000c24  00010c24  2**0
                  ALLOC
  2 .ARM.attributes 00000026  00000000  00000000  00010c24  2**0
                  CONTENTS, READONLY
  3 .comment      00000075  00000000  00000000  00010c4a  2**0
                  CONTENTS, READONLY
  4 .debug_line   000004f6  00000000  00000000  00010cbf  2**0
                  CONTENTS, READONLY, DEBUGGING
  5 .debug_info   000002e7  00000000  00000000  000111b5  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_abbrev 00000198  00000000  00000000  0001149c  2**0
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_aranges 00000080  00000000  00000000  00011638  2**3
                  CONTENTS, READONLY, DEBUGGING
  8 .debug_str    000001f4  00000000  00000000  000116b8  2**0
                  CONTENTS, READONLY, DEBUGGING
  9 .debug_frame  00000138  00000000  00000000  000118ac  2**2
                  CONTENTS, READONLY, DEBUGGING
SYMBOL TABLE:
30000000 l    d  .text	00000000 .text
30000c24 l    d  .bss	00000000 .bss
00000000 l    d  .ARM.attributes	00000000 .ARM.attributes
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    df *ABS*	00000000 hal/src/start.o
30000064 l       .text	00000000 ResetHandler
30000040 l       .text	00000000 HandleUndef
30000044 l       .text	00000000 HandleSWI
3000004c l       .text	00000000 HandlePabort
30000048 l       .text	00000000 HandleDabort
30000038 l       .text	00000000 HandleFIQ
30000050 l       .text	00000000 _text_load_addr
30000054 l       .text	00000000 _text_start
30000058 l       .text	00000000 _bss_load_addr
3000005c l       .text	00000000 _bss_start
30000060 l       .text	00000000 _bss_end
30000220 l       .text	00000000 memsetup
300001bc l       .text	00000000 InitStacks
300000e0 l       .text	00000000 copy_self
30000244 l       .text	00000000 mem_clear
3000010c l       .text	00000000 copy_from_rom
3000012c l       .text	00000000 copy_from_nand
30000170 l       .text	00000000 ok_nand_read
30000150 l       .text	00000000 bad_nand_read
3000017c l       .text	00000000 go_next
30000198 l       .text	00000000 notmatch
300001b8 l       .text	00000000 out
30000260 l       .text	00000000 mem_cfg_val
00000000 l    df *ABS*	00000000 ch1.c
00000000 l    df *ABS*	00000000 hal/src/hal_int_s.o
00000000 l    df *ABS*	00000000 hal_nand.c
30000488 l     F .text	00000060 nand_wait
300004e8 l     F .text	00000080 nand_reset
300005a4 l     F .text	00000194 is_bad_block
30000738 l     F .text	000001b0 nand_read_page
300008e8 l     F .text	00000090 nand_read_id
30000418 g       .text	00000000 EXP_HANDLER
3000045c g       .text	00000000 HAL_INTR_RESTORE
300003dc g       .text	00000000 HAL_INTR_ENTRY
00000200 g       *ABS*	00000000 IRQ_stack_size
30000568 g     F .text	0000003c nand_init
30000978 g     F .text	000002ac nand_read
30000000 g       .text	00000000 __ENTRY
30000448 g       .text	00000000 HAL_INTR_DISABLE
00000200 g       *ABS*	00000000 SVC_stack_size
33ffff00 g       *ABS*	00000000 stack_base
00000000 g       *ABS*	00000000 text_load_addr
30000c24 g       *ABS*	00000000 heap_start
00000100 g       *ABS*	00000000 Abort_stack_size
30000438 g       .text	00000000 HAL_INTR_ENABLE
30000464 g       .text	00000000 HAL_INTR_DISABLE_SAVE
300002cc g     F .text	00000110 acoral_start
33fffd00 g       *ABS*	00000000 ABT_stack
30000c24 g       .bss	00000000 bss_end
00000c24 g       .bss	00000000 bss_load_addr
00000000 g       *ABS*	00000000 FIQ_stack_size
00000200 g       *ABS*	00000000 SYS_stack_size
30000c24 g       .bss	00000000 bss_start
33fffc00 g       *ABS*	00000000 UDF_stack
00000100 g       *ABS*	00000000 Undef_stack_size
33f00000 g       *ABS*	00000000 MMU_base
30000000 g       .text	00000000 text_start
33fff900 g       *ABS*	00000000 SYS_stack
33eff000 g       *ABS*	00000000 heap_end
3000003c g       .text	00000000 HandleIRQ
33ffff00 g       *ABS*	00000000 IRQ_stack
33ffff00 g       *ABS*	00000000 FIQ_stack
33fffb00 g       *ABS*	00000000 SVC_stack


