
acoral.elf:     file format elf32-littlearm

SYMBOL TABLE:
00000000 l    d  .init	00000000 .init
30000a68 l    d  .text	00000000 .text
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
00000064 l       .init	00000000 ResetHandler
00000040 l       .init	00000000 HandleUndef
00000044 l       .init	00000000 HandleSWI
0000004c l       .init	00000000 HandlePabort
00000048 l       .init	00000000 HandleDabort
00000038 l       .init	00000000 HandleFIQ
00000050 l       .init	00000000 _text_load_addr
00000054 l       .init	00000000 _text_start
00000058 l       .init	00000000 _bss_load_addr
0000005c l       .init	00000000 _bss_start
00000060 l       .init	00000000 _bss_end
00000220 l       .init	00000000 memsetup
000001bc l       .init	00000000 InitStacks
000000e0 l       .init	00000000 copy_self
00000244 l       .init	00000000 mem_clear
0000010c l       .init	00000000 copy_from_rom
0000012c l       .init	00000000 copy_from_nand
00000118 l       .init	00000000 start_copy
00000170 l       .init	00000000 ok_nand_read
00000150 l       .init	00000000 bad_nand_read
0000017c l       .init	00000000 go_next
00000198 l       .init	00000000 notmatch
000001b8 l       .init	00000000 out
00000260 l       .init	00000000 mem_cfg_val
00000000 l    df *ABS*	00000000 hal_nand.c
000002cc l     F .init	00000060 nand_wait
0000032c l     F .init	00000080 nand_reset
000003e8 l     F .init	00000194 is_bad_block
0000057c l     F .init	000001b0 nand_read_page
0000072c l     F .init	00000090 nand_read_id
00000000 l    df *ABS*	00000000 ch1.c
00000000 l    df *ABS*	00000000 hal/src/hal_int_s.o
30000bb4 g       .text	00000000 EXP_HANDLER
30000bf8 g       .text	00000000 HAL_INTR_RESTORE
30000b78 g       .text	00000000 HAL_INTR_ENTRY
00000200 g       *ABS*	00000000 IRQ_stack_size
000003ac g     F .init	0000003c nand_init
000007bc g     F .init	000002ac nand_read
00000000 g       .init	00000000 __ENTRY
30000be4 g       .text	00000000 HAL_INTR_DISABLE
00000200 g       *ABS*	00000000 SVC_stack_size
33ffff00 g       *ABS*	00000000 stack_base
00000a68 g       *ABS*	00000000 text_load_addr
30000c24 g       *ABS*	00000000 heap_start
00000100 g       *ABS*	00000000 Abort_stack_size
30000bd4 g       .text	00000000 HAL_INTR_ENABLE
30000c00 g       .text	00000000 HAL_INTR_DISABLE_SAVE
30000a68 g     F .text	00000110 acoral_start
33fffd00 g       *ABS*	00000000 ABT_stack
30000c24 g       .bss	00000000 bss_end
00000c24 g       .bss	00000000 bss_load_addr
00000000 g       *ABS*	00000000 FIQ_stack_size
00000a68 g       .init	00000000 init_end
00000200 g       *ABS*	00000000 SYS_stack_size
30000c24 g       .bss	00000000 bss_start
33fffc00 g       *ABS*	00000000 UDF_stack
00000100 g       *ABS*	00000000 Undef_stack_size
33f00000 g       *ABS*	00000000 MMU_base
30000a68 g       .text	00000000 text_start
33fff900 g       *ABS*	00000000 SYS_stack
33eff000 g       *ABS*	00000000 heap_end
0000003c g       .init	00000000 HandleIRQ
33ffff00 g       *ABS*	00000000 IRQ_stack
33ffff00 g       *ABS*	00000000 FIQ_stack
33fffb00 g       *ABS*	00000000 SVC_stack


