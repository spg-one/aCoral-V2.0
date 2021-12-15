
acoral.elf:     file format elf32-littlearm
acoral.elf
architecture: armv4t, flags 0x00000112:
EXEC_P, HAS_SYMS, D_PAGED
start address 0x00000000

Program Header:
    LOAD off    0x00010000 vaddr 0x00000000 paddr 0x00000000 align 2**16
         filesz 0x00000134 memsz 0x00000134 flags r-x
private flags = 5000200: [Version5 EABI] [soft-float ABI]

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00000134  00000000  00000000  00010000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .comment      00000075  00000000  00000000  00010134  2**0
                  CONTENTS, READONLY
  2 .debug_aranges 00000040  00000000  00000000  000101b0  2**3
                  CONTENTS, READONLY, DEBUGGING
  3 .debug_info   00000069  00000000  00000000  000101f0  2**0
                  CONTENTS, READONLY, DEBUGGING
  4 .debug_abbrev 0000004d  00000000  00000000  00010259  2**0
                  CONTENTS, READONLY, DEBUGGING
  5 .debug_line   000000cb  00000000  00000000  000102a6  2**0
                  CONTENTS, READONLY, DEBUGGING
  6 .debug_frame  00000030  00000000  00000000  00010374  2**2
                  CONTENTS, READONLY, DEBUGGING
  7 .debug_str    000000c5  00000000  00000000  000103a4  2**0
                  CONTENTS, READONLY, DEBUGGING
  8 .ARM.attributes 00000026  00000000  00000000  00010469  2**0
                  CONTENTS, READONLY
SYMBOL TABLE:
00000000 l    d  .text	00000000 .text
00000000 l    d  .comment	00000000 .comment
00000000 l    d  .debug_aranges	00000000 .debug_aranges
00000000 l    d  .debug_info	00000000 .debug_info
00000000 l    d  .debug_abbrev	00000000 .debug_abbrev
00000000 l    d  .debug_line	00000000 .debug_line
00000000 l    d  .debug_frame	00000000 .debug_frame
00000000 l    d  .debug_str	00000000 .debug_str
00000000 l    d  .ARM.attributes	00000000 .ARM.attributes
00000000 l    df *ABS*	00000000 start.o
00000000 l    df *ABS*	00000000 ch1.c
00010134 g       .text	00000000 _bss_end__
00010134 g       .text	00000000 __bss_start__
00010134 g       .text	00000000 __bss_end__
00000000 g       .text	00000000 _start
00010134 g       .text	00000000 __bss_start
00000014 g     F .text	00000120 main
00010134 g       .text	00000000 __end__
00010134 g       .text	00000000 _edata
00010134 g       .text	00000000 _end
00080000 g       .text	00000000 _stack
00010134 g       .text	00000000 __data_start


