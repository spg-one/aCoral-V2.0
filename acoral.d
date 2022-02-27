
acoral.elf:     file format elf32-littlearm


Disassembly of section .text:

00000010 <__ENTRY>:
	.extern acoral_start

	.global __ENTRY
	.global HandleIRQ
__ENTRY:
	b	ResetHandler
  10:	ea000015 	b	6c <ResetHandler>
	b	HandleUndef		@handler for Undefined mode
  14:	ea00000d 	b	50 <HandleUndef>
	b	HandleSWI       @handler for SWI interrupt
  18:	ea00000d 	b	54 <HandleSWI>
	b	HandlePabort	@handler for PAbort
  1c:	ea00000e 	b	5c <HandlePabort>
	b	HandleDabort	@handler for DAbort
  20:	ea00000c 	b	58 <HandleDabort>
	b   .				@reserved
  24:	eafffffe 	b	24 <__ENTRY+0x14>
	b   HandleIRQ 		@handler for IRQ interrupt
  28:	ea000007 	b	4c <HandleIRQ>
	b	HandleFIQ		@handler for FIQ interrupt
  2c:	ea000005 	b	48 <HandleFIQ>
	...
  38:	00000010 	.word	0x00000010
  3c:	00000988 	.word	0x00000988
  40:	00000000 	.word	0x00000000
@ 0x2C: this contains the platform, cpu and machine id
	.long   2440
@ 0x30:  capabilities
	.long   0
@ 0x34:
	b   	.
  44:	eafffffe 	b	44 <__ENTRY+0x34>

00000048 <HandleFIQ>:
@****************************************************************
@ intvector setup
@****************************************************************

HandleFIQ:
	ldr pc,=acoral_start
  48:	e59ff244 	ldr	pc, [pc, #580]	; 294 <mem_cfg_val+0x34>

0000004c <HandleIRQ>:
HandleIRQ:
	ldr pc,=HAL_INTR_ENTRY
  4c:	e59ff244 	ldr	pc, [pc, #580]	; 298 <mem_cfg_val+0x38>

00000050 <HandleUndef>:
HandleUndef:
	ldr pc,=EXP_HANDLER
  50:	e59ff244 	ldr	pc, [pc, #580]	; 29c <mem_cfg_val+0x3c>

00000054 <HandleSWI>:
HandleSWI:
	ldr pc,=EXP_HANDLER
  54:	e59ff240 	ldr	pc, [pc, #576]	; 29c <mem_cfg_val+0x3c>

00000058 <HandleDabort>:
HandleDabort:
	ldr pc,=EXP_HANDLER
  58:	e59ff23c 	ldr	pc, [pc, #572]	; 29c <mem_cfg_val+0x3c>

0000005c <HandlePabort>:
HandlePabort:
	ldr pc,=EXP_HANDLER
  5c:	e59ff238 	ldr	pc, [pc, #568]	; 29c <mem_cfg_val+0x3c>

00000060 <_text_start>:
  60:	00000010 	.word	0x00000010

00000064 <_bss_start>:
  64:	00000c24 	.word	0x00000c24

00000068 <_bss_end>:
  68:	00000c24 	.word	0x00000c24

0000006c <ResetHandler>:
@****************************************************************
@             ResetHandler fuction
@****************************************************************
ResetHandler:
	@ disable watch dog timer
	mov	r1, #0x53000000
  6c:	e3a01453 	mov	r1, #1392508928	; 0x53000000
	mov	r2, #0x0
  70:	e3a02000 	mov	r2, #0
	str	r2, [r1]
  74:	e5812000 	str	r2, [r1]

	@ disable all interrupts
	mov	r1, #INT_CTL_BASE
  78:	e3a0144a 	mov	r1, #1241513984	; 0x4a000000
	mov	r2, #0xffffffff
  7c:	e3e02000 	mvn	r2, #0
	str	r2, [r1, #oINTMSK]
  80:	e5812008 	str	r2, [r1, #8]
	ldr	r2, =0x7ff
  84:	e59f2214 	ldr	r2, [pc, #532]	; 2a0 <mem_cfg_val+0x40>
	str	r2, [r1, #oINTSUBMSK]
  88:	e581201c 	str	r2, [r1, #28]

	@ initialise system clocks
	mov	r1, #CLK_CTL_BASE
  8c:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mvn	r2, #0xff000000
  90:	e3e024ff 	mvn	r2, #-16777216	; 0xff000000
	str	r2, [r1, #oLOCKTIME]
  94:	e5812000 	str	r2, [r1]

	mov	r1, #CLK_CTL_BASE
  98:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mov	r2, #M_DIVN
  9c:	e3a02005 	mov	r2, #5
	str	r2, [r1, #oCLKDIVN]
  a0:	e5812014 	str	r2, [r1, #20]

	mrc	p15, 0, r1, c1, c0, 0	@ read ctrl register
  a4:	ee111f10 	mrc	15, 0, r1, cr1, cr0, {0}
	orr	r1, r1, #0xc0000000	@ Asynchronous
  a8:	e3811103 	orr	r1, r1, #-1073741824	; 0xc0000000
	mcr	p15, 0, r1, c1, c0, 0	@ write ctrl register
  ac:	ee011f10 	mcr	15, 0, r1, cr1, cr0, {0}

	mov	r1, #CLK_CTL_BASE
  b0:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	ldr 	r2, =vMPLLCON	        @ clock user set
  b4:	e59f21e8 	ldr	r2, [pc, #488]	; 2a4 <mem_cfg_val+0x44>
	str	r2, [r1, #oMPLLCON]
  b8:	e5812004 	str	r2, [r1, #4]

	bl	memsetup
  bc:	eb000058 	bl	224 <memsetup>
	ldr r0, [r1]  
	tst r0, #PMST_SMR  
	bne WakeupStart 
#endif
		
	bl      InitStacks
  c0:	eb00003e 	bl	1c0 <InitStacks>

	adr  r0,__ENTRY
  c4:	e24f00bc 	sub	r0, pc, #188	; 0xbc
	ldr  r1,_text_start
  c8:	e51f1070 	ldr	r1, [pc, #-112]	; 60 <_text_start>
	cmp  r0,r1
  cc:	e1500001 	cmp	r0, r1
	blne copy_self  
  d0:	1b000004 	blne	e8 <copy_self>

	ldr  r0,_bss_start
  d4:	e51f0078 	ldr	r0, [pc, #-120]	; 64 <_bss_start>
	ldr  r1,_bss_end
  d8:	e51f1078 	ldr	r1, [pc, #-120]	; 68 <_bss_end>
	bl    mem_clear
  dc:	eb000059 	bl	248 <mem_clear>
	ldr    pc,=acoral_start	
  e0:	e59ff1ac 	ldr	pc, [pc, #428]	; 294 <mem_cfg_val+0x34>
	b 	.
  e4:	eafffffe 	b	e4 <ResetHandler+0x78>

000000e8 <copy_self>:

#endif
 
copy_self:

        ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )		/* address of Internal SRAM  0x4000002C*/
  e8:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	mov	r0, #0		
  ec:	e3a00000 	mov	r0, #0
	str	r0, [r1]
  f0:	e5810000 	str	r0, [r1]


	mov	r1, #0x2c		               /* address of men  0x0000002C*/
  f4:	e3a0102c 	mov	r1, #44	; 0x2c
	ldr	r0, [r1]
  f8:	e5910000 	ldr	r0, [r1]
	cmp	r0, #0
  fc:	e3500000 	cmp	r0, #0
	bne	copy_from_rom
 100:	1a000003 	bne	114 <copy_from_rom>
        
        ldr	r0, =(2440)
 104:	e59f019c 	ldr	r0, [pc, #412]	; 2a8 <mem_cfg_val+0x48>
	ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )
 108:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	str	r0, [r1]
 10c:	e5810000 	str	r0, [r1]
	b       copy_from_nand 
 110:	ea000006 	b	130 <copy_from_nand>

00000114 <copy_from_rom>:



copy_from_rom:
	ldr   r1,   _text_start
 114:	e51f10bc 	ldr	r1, [pc, #-188]	; 60 <_text_start>
	ldr   r3,   _bss_start
 118:	e51f30bc 	ldr	r3, [pc, #-188]	; 64 <_bss_start>
	ldr   r2,   [r0],#4
 11c:	e4902004 	ldr	r2, [r0], #4
	str   r2,   [r1],#4
 120:	e4812004 	str	r2, [r1], #4
	cmp   r1,   r3
 124:	e1510003 	cmp	r1, r3
	blt   copy_from_rom	
 128:	bafffff9 	blt	114 <copy_from_rom>
	mov   pc,  lr
 12c:	e1a0f00e 	mov	pc, lr

00000130 <copy_from_nand>:

copy_from_nand:
	stmfd   sp!, {lr}
 130:	e92d4000 	stmfd	sp!, {lr}
	bl      nand_init
 134:	eb00010b 	bl	568 <nand_init>
	ldr     r0,  _text_start
 138:	e51f00e0 	ldr	r0, [pc, #-224]	; 60 <_text_start>
	mov     r1,  #0
 13c:	e3a01000 	mov	r1, #0
	ldr     r3,  _bss_start
 140:	e51f30e4 	ldr	r3, [pc, #-228]	; 64 <_bss_start>
        sub     r2,  r3, r0
 144:	e0432000 	sub	r2, r3, r0

        bl      nand_read
 148:	eb00020a 	bl	978 <nand_read>
        cmp	r0,  #0x0
 14c:	e3500000 	cmp	r0, #0
	beq     ok_nand_read
 150:	0a000007 	beq	174 <ok_nand_read>

00000154 <bad_nand_read>:


bad_nand_read:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
 154:	e59f0150 	ldr	r0, [pc, #336]	; 2ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00001000        
 158:	e3a01a01 	mov	r1, #4096	; 0x1000
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
 15c:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
 160:	e59f0148 	ldr	r0, [pc, #328]	; 2b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
 164:	e3a01000 	mov	r1, #0
                                        @ 可让LED2熄灭
         str     r1,[r0]             @ GPB5输出0，LED2点亮
 168:	e5801000 	str	r1, [r0]

         b       .
 16c:	eafffffe 	b	16c <bad_nand_read+0x18>

	 b	bad_nand_read	@ infinite loop
 170:	eafffff7 	b	154 <bad_nand_read>

00000174 <ok_nand_read>:


ok_nand_read:    	

	mov	r0, #0
 174:	e3a00000 	mov	r0, #0
	ldr	r1, _text_start
 178:	e51f1120 	ldr	r1, [pc, #-288]	; 60 <_text_start>
	mov	r2, #512	
 17c:	e3a02c02 	mov	r2, #512	; 0x200

00000180 <go_next>:
go_next:
	ldr	r3, [r0], #4
 180:	e4903004 	ldr	r3, [r0], #4
	ldr	r4, [r1], #4
 184:	e4914004 	ldr	r4, [r1], #4
	cmp	r3, r4
 188:	e1530004 	cmp	r3, r4
	bne	notmatch
 18c:	1a000002 	bne	19c <notmatch>
	cmp     r0, r2
 190:	e1500002 	cmp	r0, r2
	beq	out
 194:	0a000008 	beq	1bc <out>
	b	go_next
 198:	eafffff8 	b	180 <go_next>

0000019c <notmatch>:
	

notmatch:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
 19c:	e59f0108 	ldr	r0, [pc, #264]	; 2ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00000400        
 1a0:	e3a01b01 	mov	r1, #1024	; 0x400
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
 1a4:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
 1a8:	e59f0100 	ldr	r0, [pc, #256]	; 2b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
 1ac:	e3a01000 	mov	r1, #0
                                        @ 可让LED1熄灭
         str     r1,[r0]             @ GPB5输出0，LED1点亮
 1b0:	e5801000 	str	r1, [r0]

         b       .
 1b4:	eafffffe 	b	1b4 <notmatch+0x18>

	 b	notmatch
 1b8:	eafffff7 	b	19c <notmatch>

000001bc <out>:

out:
        ldmfd sp!,{lr} 
 1bc:	e8bd4000 	ldmfd	sp!, {lr}

000001c0 <InitStacks>:
@***************************************************************
@                       堆栈初始化
@***************************************************************

InitStacks:
	mov r2,lr
 1c0:	e1a0200e 	mov	r2, lr
	mrs	r0,cpsr
 1c4:	e10f0000 	mrs	r0, CPSR
	bic	r0,r0,#MODE_MASK
 1c8:	e3c0001f 	bic	r0, r0, #31
	orr	r1,r0,#UND_MODE|NOINT
 1cc:	e38010db 	orr	r1, r0, #219	; 0xdb
	msr	cpsr_cxsf,r1		@UndefMode
 1d0:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_5C00
 1d4:	e59fd0d8 	ldr	sp, [pc, #216]	; 2b4 <mem_cfg_val+0x54>

	orr	r1,r0,#ABT_MODE|NOINT
 1d8:	e38010d7 	orr	r1, r0, #215	; 0xd7
	msr	cpsr_cxsf,r1		@AbortMode
 1dc:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_6000
 1e0:	e59fd0d0 	ldr	sp, [pc, #208]	; 2b8 <mem_cfg_val+0x58>

	orr	r1,r0,#IRQ_MODE|NOINT
 1e4:	e38010d2 	orr	r1, r0, #210	; 0xd2
	msr	cpsr_cxsf,r1		@IRQMode
 1e8:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
 1ec:	e59fd0c8 	ldr	sp, [pc, #200]	; 2bc <mem_cfg_val+0x5c>

	orr	r1,r0,#FIQ_MODE|NOINT
 1f0:	e38010d1 	orr	r1, r0, #209	; 0xd1
	msr	cpsr_cxsf,r1		@FIQMode
 1f4:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
 1f8:	e59fd0c0 	ldr	sp, [pc, #192]	; 2c0 <mem_cfg_val+0x60>

	bic	r0,r0,#MODE_MASK|NOINT
 1fc:	e3c000df 	bic	r0, r0, #223	; 0xdf
	orr	r1,r0,#SVC_MODE
 200:	e3801013 	orr	r1, r0, #19
	msr	cpsr_cxsf,r1		@SVCMode
 204:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
 208:	e59fd0b4 	ldr	sp, [pc, #180]	; 2c4 <mem_cfg_val+0x64>

	mrs     r0,cpsr
 20c:	e10f0000 	mrs	r0, CPSR
       	bic     r0,r0,#MODE_MASK
 210:	e3c0001f 	bic	r0, r0, #31
	orr     r1,r0,#SYS_MODE|NOINT
 214:	e38010df 	orr	r1, r0, #223	; 0xdf
	msr     cpsr_cxsf,r1    	@ userMode
 218:	e12ff001 	msr	CPSR_fsxc, r1
	ldr     sp,=SYS_stack
 21c:	e59fd0a4 	ldr	sp, [pc, #164]	; 2c8 <mem_cfg_val+0x68>

	mov	pc,r2
 220:	e1a0f002 	mov	pc, r2

00000224 <memsetup>:
@***************************************************************
@ initialise the static memory
@ set memory control registers
@***************************************************************
memsetup:
	mov	r1, #MEM_CTL_BASE
 224:	e3a01312 	mov	r1, #1207959552	; 0x48000000
	adrl	r2, mem_cfg_val
 228:	e28f2030 	add	r2, pc, #48	; 0x30
 22c:	e1a00000 	nop			; (mov r0, r0)
	add	r3, r1, #52
 230:	e2813034 	add	r3, r1, #52	; 0x34
1:	ldr	r4, [r2], #4
 234:	e4924004 	ldr	r4, [r2], #4
	str	r4, [r1], #4
 238:	e4814004 	str	r4, [r1], #4
	cmp	r1, r3
 23c:	e1510003 	cmp	r1, r3
	bne	1b
 240:	1afffffb 	bne	234 <memsetup+0x10>
	mov	pc, lr
 244:	e1a0f00e 	mov	pc, lr

00000248 <mem_clear>:
@ r0: start address
@ r1: length
@***************************************************************

mem_clear:
	mov r2,#0
 248:	e3a02000 	mov	r2, #0
1:	str r2,[r0],#4
 24c:	e4802004 	str	r2, [r0], #4
	cmp r0,r1
 250:	e1500001 	cmp	r0, r1
	blt 1b
 254:	bafffffc 	blt	24c <mem_clear+0x4>
	mov pc,lr
 258:	e1a0f00e 	mov	pc, lr
 25c:	e1a00000 	nop			; (mov r0, r0)

00000260 <mem_cfg_val>:
 260:	22111110 	.word	0x22111110
 264:	00000700 	.word	0x00000700
 268:	00000700 	.word	0x00000700
 26c:	00000700 	.word	0x00000700
 270:	00000700 	.word	0x00000700
 274:	00000700 	.word	0x00000700
 278:	00000700 	.word	0x00000700
 27c:	00018009 	.word	0x00018009
 280:	00018009 	.word	0x00018009
 284:	008e04eb 	.word	0x008e04eb
 288:	000000b2 	.word	0x000000b2
 28c:	00000030 	.word	0x00000030
 290:	00000030 	.word	0x00000030
	ldr pc,=acoral_start
 294:	000002cc 	.word	0x000002cc
	ldr pc,=HAL_INTR_ENTRY
 298:	000003dc 	.word	0x000003dc
	ldr pc,=EXP_HANDLER
 29c:	00000418 	.word	0x00000418
	ldr	r2, =0x7ff
 2a0:	000007ff 	.word	0x000007ff
	ldr 	r2, =vMPLLCON	        @ clock user set
 2a4:	0007f021 	.word	0x0007f021
        ldr	r0, =(2440)
 2a8:	00000988 	.word	0x00000988
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
 2ac:	56000010 	.word	0x56000010
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
 2b0:	56000014 	.word	0x56000014
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_5C00
 2b4:	33fffc00 	.word	0x33fffc00
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_6000
 2b8:	33fffd00 	.word	0x33fffd00
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
 2bc:	33ffff00 	.word	0x33ffff00
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
 2c0:	33ffff00 	.word	0x33ffff00
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
 2c4:	33fffb00 	.word	0x33fffb00
	ldr     sp,=SYS_stack
 2c8:	33fff900 	.word	0x33fff900

000002cc <acoral_start>:
#include "ch1.h"

int acoral_start(){
 2cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
 2d0:	e28db000 	add	fp, sp, #0
	rCLKDIVN = 0X5;	
 2d4:	e59f30d0 	ldr	r3, [pc, #208]	; 3ac <acoral_start+0xe0>
 2d8:	e3a02005 	mov	r2, #5
 2dc:	e5832000 	str	r2, [r3]
	rMPLLCON = (0X7f<<12) | (0X2<<4) | (0X1);
 2e0:	e59f30c8 	ldr	r3, [pc, #200]	; 3b0 <acoral_start+0xe4>
 2e4:	e59f20c8 	ldr	r2, [pc, #200]	; 3b4 <acoral_start+0xe8>
 2e8:	e5832000 	str	r2, [r3]
	rGPGCON = 0;			//检测按键状态
 2ec:	e59f30c4 	ldr	r3, [pc, #196]	; 3b8 <acoral_start+0xec>
 2f0:	e3a02000 	mov	r2, #0
 2f4:	e5832000 	str	r2, [r3]
	while(1){
		if((rGPGDAT & 0x1)==0)
 2f8:	e59f30bc 	ldr	r3, [pc, #188]	; 3bc <acoral_start+0xf0>
 2fc:	e5933000 	ldr	r3, [r3]
 300:	e2033001 	and	r3, r3, #1
 304:	e3530000 	cmp	r3, #0
 308:	0a000000 	beq	310 <acoral_start+0x44>
 30c:	eafffff9 	b	2f8 <acoral_start+0x2c>
        	break;
 310:	e1a00000 	nop			; (mov r0, r0)
		}
	rTCFG0 |= 0xF9;			/* prescaler等于249*/
 314:	e3a03451 	mov	r3, #1358954496	; 0x51000000
 318:	e5933000 	ldr	r3, [r3]
 31c:	e3a02451 	mov	r2, #1358954496	; 0x51000000
 320:	e38330f9 	orr	r3, r3, #249	; 0xf9
 324:	e5823000 	str	r3, [r2]
 	rTCFG1 |= 0x3;			/*divider等于16*/
 328:	e59f3090 	ldr	r3, [pc, #144]	; 3c0 <acoral_start+0xf4>
 32c:	e5933000 	ldr	r3, [r3]
 330:	e59f2088 	ldr	r2, [pc, #136]	; 3c0 <acoral_start+0xf4>
 334:	e3833003 	orr	r3, r3, #3
 338:	e5823000 	str	r3, [r2]
   	rTCNTB0 = 0X61A9;          		/*计数值25001*/
 33c:	e59f3080 	ldr	r3, [pc, #128]	; 3c4 <acoral_start+0xf8>
 340:	e59f2080 	ldr	r2, [pc, #128]	; 3c8 <acoral_start+0xfc>
 344:	e5832000 	str	r2, [r3]
   	rTCON = rTCON & (~0xf) |0x02;           	/* 更新TCNT0*/
 348:	e59f307c 	ldr	r3, [pc, #124]	; 3cc <acoral_start+0x100>
 34c:	e5933000 	ldr	r3, [r3]
 350:	e3c3300f 	bic	r3, r3, #15
 354:	e59f2070 	ldr	r2, [pc, #112]	; 3cc <acoral_start+0x100>
 358:	e3833002 	orr	r3, r3, #2
 35c:	e5823000 	str	r3, [r2]
	rTCON = rTCON & (~0xf) |0x01; 	/* start定时器0*/
 360:	e59f3064 	ldr	r3, [pc, #100]	; 3cc <acoral_start+0x100>
 364:	e5933000 	ldr	r3, [r3]
 368:	e3c3300f 	bic	r3, r3, #15
 36c:	e59f2058 	ldr	r2, [pc, #88]	; 3cc <acoral_start+0x100>
 370:	e3833001 	orr	r3, r3, #1
 374:	e5823000 	str	r3, [r2]
	while(1){
		if(rTCNTO0 == 1)		/*倒计时到1，两秒*/
 378:	e59f3050 	ldr	r3, [pc, #80]	; 3d0 <acoral_start+0x104>
 37c:	e5933000 	ldr	r3, [r3]
 380:	e3530001 	cmp	r3, #1
 384:	0a000000 	beq	38c <acoral_start+0xc0>
 388:	eafffffa 	b	378 <acoral_start+0xac>
        	break;
 38c:	e1a00000 	nop			; (mov r0, r0)
		}
	rGPBCON = 0x400;			
 390:	e59f303c 	ldr	r3, [pc, #60]	; 3d4 <acoral_start+0x108>
 394:	e3a02b01 	mov	r2, #1024	; 0x400
 398:	e5832000 	str	r2, [r3]
	rGPBDAT = 0x1C0; 			//点亮LED
 39c:	e59f3034 	ldr	r3, [pc, #52]	; 3d8 <acoral_start+0x10c>
 3a0:	e3a02d07 	mov	r2, #448	; 0x1c0
 3a4:	e5832000 	str	r2, [r3]
	while(1);
 3a8:	eafffffe 	b	3a8 <acoral_start+0xdc>
 3ac:	4c000014 	.word	0x4c000014
 3b0:	4c000004 	.word	0x4c000004
 3b4:	0007f021 	.word	0x0007f021
 3b8:	56000060 	.word	0x56000060
 3bc:	56000064 	.word	0x56000064
 3c0:	51000004 	.word	0x51000004
 3c4:	5100000c 	.word	0x5100000c
 3c8:	000061a9 	.word	0x000061a9
 3cc:	51000008 	.word	0x51000008
 3d0:	51000014 	.word	0x51000014
 3d4:	56000010 	.word	0x56000010
 3d8:	56000014 	.word	0x56000014

000003dc <HAL_INTR_ENTRY>:
   .global     HAL_INTR_DISABLE_SAVE
   .global     HAL_INTR_RESTORE
   .extern     IRQ_stack

HAL_INTR_ENTRY:
    stmfd   sp!,    {r0-r12,lr}           @保护通用寄存器及PC 
 3dc:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    mrs     r1,     spsr
 3e0:	e14f1000 	mrs	r1, SPSR
    stmfd   sp!,    {r1}                  @保护spsr,以支持中断嵌套
 3e4:	e92d0002 	stmfd	sp!, {r1}

    msr     cpsr_c, #SVC_MODE|NOIRQ        @进入SVC_MODE,以便允许中断嵌套
 3e8:	e321f093 	msr	CPSR_c, #147	; 0x93
    stmfd   sp!,    {lr}                  @保存SVc模式的专用寄存器lr
 3ec:	e92d4000 	stmfd	sp!, {lr}

    ldr     r0,     =INTOFFSET 		  @读取中断向量号
 3f0:	e59f008c 	ldr	r0, [pc, #140]	; 484 <HAL_INTR_DISABLE_SAVE+0x20>
    ldr     r0,     [r0]
 3f4:	e5900000 	ldr	r0, [r0]
    mov     lr,    pc                     @求得lr的值
 3f8:	e1a0e00f 	mov	lr, pc
    bl .    @//TODO ldr     pc,    =hal_all_entry 
 3fc:	ebfffffe 	bl	3fc <HAL_INTR_ENTRY+0x20>

    ldmfd   sp!,    {lr}                    @恢复svc模式下的lr,
 400:	e8bd4000 	ldmfd	sp!, {lr}
    msr     cpsr_c,#IRQ_MODE|NOINT       @更新cpsr,进入IRQ模式并禁止中断
 404:	e321f0d2 	msr	CPSR_c, #210	; 0xd2
    ldmfd   sp!,{r0}                    @spsr->r0
 408:	e8bd0001 	ldmfd	sp!, {r0}
    msr     spsr_cxsf,r0                @恢复spsr
 40c:	e16ff000 	msr	SPSR_fsxc, r0
    ldmfd   sp!,{r0-r12,lr}
 410:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    subs    pc,lr,#4                    @此后，中断被重新打开
 414:	e25ef004 	subs	pc, lr, #4

00000418 <EXP_HANDLER>:

EXP_HANDLER:
	stmfd   sp!,{lr}                @保护寄存器,以及返回地址
 418:	e92d4000 	stmfd	sp!, {lr}
	mov     r0,sp  
 41c:	e1a0000d 	mov	r0, sp
	stmfd   r0!,{sp}^               @出错线程的SP_sys压入exp中断栈中
 420:	e9602000 	stmdb	r0!, {sp}^
	ldmfd   r0!,{r1}                @从exp中断栈中读取 SP_sys->R1
 424:	e8b00002 	ldm	r0!, {r1}
	mov     r0,lr
 428:	e1a0000e 	mov	r0, lr
	bl .    @//TODO  bl acoral_fault_entry
 42c:	ebfffffe 	bl	42c <EXP_HANDLER+0x14>
	ldmfd   sp!,{lr}                  @从exp中断栈中读取 SP_sys->R1
 430:	e8bd4000 	ldmfd	sp!, {lr}
	subs pc,lr,#0
 434:	e25ef000 	subs	pc, lr, #0

00000438 <HAL_INTR_ENABLE>:

HAL_INTR_ENABLE:
    mrs r0,cpsr
 438:	e10f0000 	mrs	r0, CPSR
    bic r0,r0,#NOINT
 43c:	e3c000c0 	bic	r0, r0, #192	; 0xc0
    msr cpsr_cxsf,r0
 440:	e12ff000 	msr	CPSR_fsxc, r0
    mov pc,lr
 444:	e1a0f00e 	mov	pc, lr

00000448 <HAL_INTR_DISABLE>:

HAL_INTR_DISABLE:
    mrs r0,cpsr
 448:	e10f0000 	mrs	r0, CPSR
    mov r1,r0
 44c:	e1a01000 	mov	r1, r0
    orr r1,r1,#NOINT
 450:	e38110c0 	orr	r1, r1, #192	; 0xc0
    msr cpsr_cxsf,r1
 454:	e12ff001 	msr	CPSR_fsxc, r1
    mov pc ,lr
 458:	e1a0f00e 	mov	pc, lr

0000045c <HAL_INTR_RESTORE>:

HAL_INTR_RESTORE:
	MSR     CPSR_c, R0
 45c:	e121f000 	msr	CPSR_c, r0
	MOV     PC, LR
 460:	e1a0f00e 	mov	pc, lr

00000464 <HAL_INTR_DISABLE_SAVE>:

HAL_INTR_DISABLE_SAVE:
	MRS     R0, CPSR				@ Set IRQ and FIable all interrupts
 464:	e10f0000 	mrs	r0, CPSR
	ORR     R1, R0, #0xC0
 468:	e38010c0 	orr	r1, r0, #192	; 0xc0
	MSR     CPSR_c, R1
 46c:	e121f001 	msr	CPSR_c, r1
	MRS     R1, CPSR				@ Confirm that Cpt disable flags
 470:	e10f1000 	mrs	r1, CPSR
	AND     R1, R1, #0xC0
 474:	e20110c0 	and	r1, r1, #192	; 0xc0
	CMP     R1, #0xC0
 478:	e35100c0 	cmp	r1, #192	; 0xc0
	BNE     HAL_INTR_DISABLE_SAVE			@ Not properly dsabled (try again)
 47c:	1afffff8 	bne	464 <HAL_INTR_DISABLE_SAVE>
	MOV     PC, LR					@ Disabled, return thcontents in R0
 480:	e1a0f00e 	mov	pc, lr
    ldr     r0,     =INTOFFSET 		  @读取中断向量号
 484:	4a000014 	.word	0x4a000014

00000488 <nand_wait>:

void nand_init(void);
int nand_read(unsigned char *buf, unsigned long start_addr, int size);

static void nand_wait(void)
{
 488:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
 48c:	e28db000 	add	fp, sp, #0
 490:	e24dd00c 	sub	sp, sp, #12
  int i;
  while (!(NFSTAT & NFSTAT_BUSY))
 494:	ea000008 	b	4bc <nand_wait+0x34>
   for (i=0; i<10; i++);
 498:	e3a03000 	mov	r3, #0
 49c:	e50b3008 	str	r3, [fp, #-8]
 4a0:	ea000002 	b	4b0 <nand_wait+0x28>
 4a4:	e51b3008 	ldr	r3, [fp, #-8]
 4a8:	e2833001 	add	r3, r3, #1
 4ac:	e50b3008 	str	r3, [fp, #-8]
 4b0:	e51b3008 	ldr	r3, [fp, #-8]
 4b4:	e3530009 	cmp	r3, #9
 4b8:	dafffff9 	ble	4a4 <nand_wait+0x1c>
  while (!(NFSTAT & NFSTAT_BUSY))
 4bc:	e59f3020 	ldr	r3, [pc, #32]	; 4e4 <nand_wait+0x5c>
 4c0:	e5d33000 	ldrb	r3, [r3]
 4c4:	e20330ff 	and	r3, r3, #255	; 0xff
 4c8:	e2033004 	and	r3, r3, #4
 4cc:	e3530000 	cmp	r3, #0
 4d0:	0afffff0 	beq	498 <nand_wait+0x10>
}
 4d4:	e1a00000 	nop			; (mov r0, r0)
 4d8:	e28bd000 	add	sp, fp, #0
 4dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
 4e0:	e12fff1e 	bx	lr
 4e4:	4e000020 	.word	0x4e000020

000004e8 <nand_reset>:


static void nand_reset(){
 4e8:	e92d4800 	push	{fp, lr}
 4ec:	e28db004 	add	fp, sp, #4
 4f0:	e24dd008 	sub	sp, sp, #8
   int i;

   nand_select();
 4f4:	e59f3064 	ldr	r3, [pc, #100]	; 560 <nand_reset+0x78>
 4f8:	e5933000 	ldr	r3, [r3]
 4fc:	e59f205c 	ldr	r2, [pc, #92]	; 560 <nand_reset+0x78>
 500:	e3c33002 	bic	r3, r3, #2
 504:	e5823000 	str	r3, [r2]
   NFCMD=NAND_CMD_RESET;
 508:	e59f3054 	ldr	r3, [pc, #84]	; 564 <nand_reset+0x7c>
 50c:	e3e02000 	mvn	r2, #0
 510:	e5c32000 	strb	r2, [r3]
   for(i=0;i<10;i++);  
 514:	e3a03000 	mov	r3, #0
 518:	e50b3008 	str	r3, [fp, #-8]
 51c:	ea000002 	b	52c <nand_reset+0x44>
 520:	e51b3008 	ldr	r3, [fp, #-8]
 524:	e2833001 	add	r3, r3, #1
 528:	e50b3008 	str	r3, [fp, #-8]
 52c:	e51b3008 	ldr	r3, [fp, #-8]
 530:	e3530009 	cmp	r3, #9
 534:	dafffff9 	ble	520 <nand_reset+0x38>
   nand_wait();  
 538:	ebffffd2 	bl	488 <nand_wait>
   nand_deselect();
 53c:	e59f301c 	ldr	r3, [pc, #28]	; 560 <nand_reset+0x78>
 540:	e5933000 	ldr	r3, [r3]
 544:	e59f2014 	ldr	r2, [pc, #20]	; 560 <nand_reset+0x78>
 548:	e3833002 	orr	r3, r3, #2
 54c:	e5823000 	str	r3, [r2]
}
 550:	e1a00000 	nop			; (mov r0, r0)
 554:	e24bd004 	sub	sp, fp, #4
 558:	e8bd4800 	pop	{fp, lr}
 55c:	e12fff1e 	bx	lr
 560:	4e000004 	.word	0x4e000004
 564:	4e000008 	.word	0x4e000008

00000568 <nand_init>:


void nand_init(void){
 568:	e92d4800 	push	{fp, lr}
 56c:	e28db004 	add	fp, sp, #4
   

    NFCONF=(7<<12)|(7<<8)|(7<<4)|(0<<0);
 570:	e3a0344e 	mov	r3, #1308622848	; 0x4e000000
 574:	e59f2020 	ldr	r2, [pc, #32]	; 59c <nand_init+0x34>
 578:	e5832000 	str	r2, [r3]
    NFCONT=(1<<4)|(0<<1)|(1<<0);
 57c:	e59f301c 	ldr	r3, [pc, #28]	; 5a0 <nand_init+0x38>
 580:	e3a02011 	mov	r2, #17
 584:	e5832000 	str	r2, [r3]
    
    nand_reset();
 588:	ebffffd6 	bl	4e8 <nand_reset>
}
 58c:	e1a00000 	nop			; (mov r0, r0)
 590:	e24bd004 	sub	sp, fp, #4
 594:	e8bd4800 	pop	{fp, lr}
 598:	e12fff1e 	bx	lr
 59c:	00007770 	.word	0x00007770
 5a0:	4e000004 	.word	0x4e000004

000005a4 <is_bad_block>:
    int bad_block_offset;
};


static int is_bad_block(struct boot_nand_t * nand, unsigned long i)
{
 5a4:	e92d4800 	push	{fp, lr}
 5a8:	e28db004 	add	fp, sp, #4
 5ac:	e24dd010 	sub	sp, sp, #16
 5b0:	e50b0010 	str	r0, [fp, #-16]
 5b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
	unsigned char data;
	unsigned long page_num;

	nand_clear_RnB();
 5b8:	e59f3168 	ldr	r3, [pc, #360]	; 728 <is_bad_block+0x184>
 5bc:	e5d33000 	ldrb	r3, [r3]
 5c0:	e20330ff 	and	r3, r3, #255	; 0xff
 5c4:	e59f215c 	ldr	r2, [pc, #348]	; 728 <is_bad_block+0x184>
 5c8:	e3833004 	orr	r3, r3, #4
 5cc:	e20330ff 	and	r3, r3, #255	; 0xff
 5d0:	e5c23000 	strb	r3, [r2]
	if (nand->page_size == 512) {
 5d4:	e51b3010 	ldr	r3, [fp, #-16]
 5d8:	e5933000 	ldr	r3, [r3]
 5dc:	e3530c02 	cmp	r3, #512	; 0x200
 5e0:	1a000019 	bne	64c <is_bad_block+0xa8>
		NFCMD = NAND_CMD_READOOB; /* 0x50 */
 5e4:	e59f3140 	ldr	r3, [pc, #320]	; 72c <is_bad_block+0x188>
 5e8:	e3a02050 	mov	r2, #80	; 0x50
 5ec:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xf;
 5f0:	e51b3010 	ldr	r3, [fp, #-16]
 5f4:	e5933008 	ldr	r3, [r3, #8]
 5f8:	e20330ff 	and	r3, r3, #255	; 0xff
 5fc:	e59f212c 	ldr	r2, [pc, #300]	; 730 <is_bad_block+0x18c>
 600:	e203300f 	and	r3, r3, #15
 604:	e20330ff 	and	r3, r3, #255	; 0xff
 608:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 9) & 0xff;
 60c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 610:	e1a034a3 	lsr	r3, r3, #9
 614:	e59f2114 	ldr	r2, [pc, #276]	; 730 <is_bad_block+0x18c>
 618:	e20330ff 	and	r3, r3, #255	; 0xff
 61c:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 17) & 0xff;
 620:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 624:	e1a038a3 	lsr	r3, r3, #17
 628:	e59f2100 	ldr	r2, [pc, #256]	; 730 <is_bad_block+0x18c>
 62c:	e20330ff 	and	r3, r3, #255	; 0xff
 630:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 25) & 0xff;
 634:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 638:	e1a03ca3 	lsr	r3, r3, #25
 63c:	e59f20ec 	ldr	r2, [pc, #236]	; 730 <is_bad_block+0x18c>
 640:	e20330ff 	and	r3, r3, #255	; 0xff
 644:	e5c23000 	strb	r3, [r2]
 648:	ea000028 	b	6f0 <is_bad_block+0x14c>
	} else if (nand->page_size == 2048) {
 64c:	e51b3010 	ldr	r3, [fp, #-16]
 650:	e5933000 	ldr	r3, [r3]
 654:	e3530b02 	cmp	r3, #2048	; 0x800
 658:	1a000022 	bne	6e8 <is_bad_block+0x144>
		page_num = i >> 11; /* addr / 2048 */
 65c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 660:	e1a035a3 	lsr	r3, r3, #11
 664:	e50b3008 	str	r3, [fp, #-8]
		NFCMD = NAND_CMD_READ0;
 668:	e59f30bc 	ldr	r3, [pc, #188]	; 72c <is_bad_block+0x188>
 66c:	e3a02000 	mov	r2, #0
 670:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xff;
 674:	e51b3010 	ldr	r3, [fp, #-16]
 678:	e5933008 	ldr	r3, [r3, #8]
 67c:	e59f20ac 	ldr	r2, [pc, #172]	; 730 <is_bad_block+0x18c>
 680:	e20330ff 	and	r3, r3, #255	; 0xff
 684:	e5c23000 	strb	r3, [r2]
		NFADDR = (nand->bad_block_offset >> 8) & 0xff;
 688:	e51b3010 	ldr	r3, [fp, #-16]
 68c:	e5933008 	ldr	r3, [r3, #8]
 690:	e1a03443 	asr	r3, r3, #8
 694:	e59f2094 	ldr	r2, [pc, #148]	; 730 <is_bad_block+0x18c>
 698:	e20330ff 	and	r3, r3, #255	; 0xff
 69c:	e5c23000 	strb	r3, [r2]
		NFADDR = page_num & 0xff;
 6a0:	e59f2088 	ldr	r2, [pc, #136]	; 730 <is_bad_block+0x18c>
 6a4:	e51b3008 	ldr	r3, [fp, #-8]
 6a8:	e20330ff 	and	r3, r3, #255	; 0xff
 6ac:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
 6b0:	e51b3008 	ldr	r3, [fp, #-8]
 6b4:	e1a03423 	lsr	r3, r3, #8
 6b8:	e59f2070 	ldr	r2, [pc, #112]	; 730 <is_bad_block+0x18c>
 6bc:	e20330ff 	and	r3, r3, #255	; 0xff
 6c0:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
 6c4:	e51b3008 	ldr	r3, [fp, #-8]
 6c8:	e1a03823 	lsr	r3, r3, #16
 6cc:	e59f205c 	ldr	r2, [pc, #92]	; 730 <is_bad_block+0x18c>
 6d0:	e20330ff 	and	r3, r3, #255	; 0xff
 6d4:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
 6d8:	e59f304c 	ldr	r3, [pc, #76]	; 72c <is_bad_block+0x188>
 6dc:	e3a02030 	mov	r2, #48	; 0x30
 6e0:	e5c32000 	strb	r2, [r3]
 6e4:	ea000001 	b	6f0 <is_bad_block+0x14c>
	} else {
		return -1;
 6e8:	e3e03000 	mvn	r3, #0
 6ec:	ea000009 	b	718 <is_bad_block+0x174>
	}
	nand_wait();
 6f0:	ebffff64 	bl	488 <nand_wait>
	data = (NFDATA & 0xff);
 6f4:	e59f3038 	ldr	r3, [pc, #56]	; 734 <is_bad_block+0x190>
 6f8:	e5d33000 	ldrb	r3, [r3]
 6fc:	e54b3009 	strb	r3, [fp, #-9]
	if (data != 0xff)
 700:	e55b3009 	ldrb	r3, [fp, #-9]
 704:	e35300ff 	cmp	r3, #255	; 0xff
 708:	0a000001 	beq	714 <is_bad_block+0x170>
		return 1;
 70c:	e3a03001 	mov	r3, #1
 710:	ea000000 	b	718 <is_bad_block+0x174>

	return 0;
 714:	e3a03000 	mov	r3, #0
}
 718:	e1a00003 	mov	r0, r3
 71c:	e24bd004 	sub	sp, fp, #4
 720:	e8bd4800 	pop	{fp, lr}
 724:	e12fff1e 	bx	lr
 728:	4e000020 	.word	0x4e000020
 72c:	4e000008 	.word	0x4e000008
 730:	4e00000c 	.word	0x4e00000c
 734:	4e000010 	.word	0x4e000010

00000738 <nand_read_page>:

static int nand_read_page(struct boot_nand_t * nand, unsigned char *buf, unsigned long addr)
{
 738:	e92d4800 	push	{fp, lr}
 73c:	e28db004 	add	fp, sp, #4
 740:	e24dd020 	sub	sp, sp, #32
 744:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
 748:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
 74c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
	unsigned short *ptr16 = (unsigned short *)buf;
 750:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 754:	e50b3008 	str	r3, [fp, #-8]
	unsigned int i, page_num;

	nand_clear_RnB();
 758:	e59f3178 	ldr	r3, [pc, #376]	; 8d8 <nand_read_page+0x1a0>
 75c:	e5d33000 	ldrb	r3, [r3]
 760:	e20330ff 	and	r3, r3, #255	; 0xff
 764:	e59f216c 	ldr	r2, [pc, #364]	; 8d8 <nand_read_page+0x1a0>
 768:	e3833004 	orr	r3, r3, #4
 76c:	e20330ff 	and	r3, r3, #255	; 0xff
 770:	e5c23000 	strb	r3, [r2]

	NFCMD = NAND_CMD_READ0;
 774:	e59f3160 	ldr	r3, [pc, #352]	; 8dc <nand_read_page+0x1a4>
 778:	e3a02000 	mov	r2, #0
 77c:	e5c32000 	strb	r2, [r3]

	if (nand->page_size == 512) {
 780:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 784:	e5933000 	ldr	r3, [r3]
 788:	e3530c02 	cmp	r3, #512	; 0x200
 78c:	1a000013 	bne	7e0 <nand_read_page+0xa8>
		/* Write Address */
		NFADDR = addr & 0xff;
 790:	e59f2148 	ldr	r2, [pc, #328]	; 8e0 <nand_read_page+0x1a8>
 794:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 798:	e20330ff 	and	r3, r3, #255	; 0xff
 79c:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 9) & 0xff;
 7a0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 7a4:	e1a034a3 	lsr	r3, r3, #9
 7a8:	e59f2130 	ldr	r2, [pc, #304]	; 8e0 <nand_read_page+0x1a8>
 7ac:	e20330ff 	and	r3, r3, #255	; 0xff
 7b0:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 17) & 0xff;
 7b4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 7b8:	e1a038a3 	lsr	r3, r3, #17
 7bc:	e59f211c 	ldr	r2, [pc, #284]	; 8e0 <nand_read_page+0x1a8>
 7c0:	e20330ff 	and	r3, r3, #255	; 0xff
 7c4:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 25) & 0xff;
 7c8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 7cc:	e1a03ca3 	lsr	r3, r3, #25
 7d0:	e59f2108 	ldr	r2, [pc, #264]	; 8e0 <nand_read_page+0x1a8>
 7d4:	e20330ff 	and	r3, r3, #255	; 0xff
 7d8:	e5c23000 	strb	r3, [r2]
 7dc:	ea000020 	b	864 <nand_read_page+0x12c>
	} else if (nand->page_size == 2048) {
 7e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 7e4:	e5933000 	ldr	r3, [r3]
 7e8:	e3530b02 	cmp	r3, #2048	; 0x800
 7ec:	1a00001a 	bne	85c <nand_read_page+0x124>
		page_num = addr >> 11; /* addr / 2048 */
 7f0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 7f4:	e1a035a3 	lsr	r3, r3, #11
 7f8:	e50b3010 	str	r3, [fp, #-16]
		/* Write Address */
		NFADDR = 0;
 7fc:	e59f30dc 	ldr	r3, [pc, #220]	; 8e0 <nand_read_page+0x1a8>
 800:	e3a02000 	mov	r2, #0
 804:	e5c32000 	strb	r2, [r3]
		NFADDR = 0;
 808:	e59f30d0 	ldr	r3, [pc, #208]	; 8e0 <nand_read_page+0x1a8>
 80c:	e3a02000 	mov	r2, #0
 810:	e5c32000 	strb	r2, [r3]
		NFADDR = page_num & 0xff;
 814:	e59f20c4 	ldr	r2, [pc, #196]	; 8e0 <nand_read_page+0x1a8>
 818:	e51b3010 	ldr	r3, [fp, #-16]
 81c:	e20330ff 	and	r3, r3, #255	; 0xff
 820:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
 824:	e51b3010 	ldr	r3, [fp, #-16]
 828:	e1a03423 	lsr	r3, r3, #8
 82c:	e59f20ac 	ldr	r2, [pc, #172]	; 8e0 <nand_read_page+0x1a8>
 830:	e20330ff 	and	r3, r3, #255	; 0xff
 834:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
 838:	e51b3010 	ldr	r3, [fp, #-16]
 83c:	e1a03823 	lsr	r3, r3, #16
 840:	e59f2098 	ldr	r2, [pc, #152]	; 8e0 <nand_read_page+0x1a8>
 844:	e20330ff 	and	r3, r3, #255	; 0xff
 848:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
 84c:	e59f3088 	ldr	r3, [pc, #136]	; 8dc <nand_read_page+0x1a4>
 850:	e3a02030 	mov	r2, #48	; 0x30
 854:	e5c32000 	strb	r2, [r3]
 858:	ea000001 	b	864 <nand_read_page+0x12c>
	} else {
		return -1;
 85c:	e3e03000 	mvn	r3, #0
 860:	ea000018 	b	8c8 <nand_read_page+0x190>
	}
	nand_wait();
 864:	ebffff07 	bl	488 <nand_wait>
	for (i = 0; i < (nand->page_size>>1); i++) {
 868:	e3a03000 	mov	r3, #0
 86c:	e50b300c 	str	r3, [fp, #-12]
 870:	ea00000b 	b	8a4 <nand_read_page+0x16c>
		*ptr16 = NFDATA16;
 874:	e59f3068 	ldr	r3, [pc, #104]	; 8e4 <nand_read_page+0x1ac>
 878:	e1d330b0 	ldrh	r3, [r3]
 87c:	e1a03803 	lsl	r3, r3, #16
 880:	e1a02823 	lsr	r2, r3, #16
 884:	e51b3008 	ldr	r3, [fp, #-8]
 888:	e1c320b0 	strh	r2, [r3]
		ptr16++;
 88c:	e51b3008 	ldr	r3, [fp, #-8]
 890:	e2833002 	add	r3, r3, #2
 894:	e50b3008 	str	r3, [fp, #-8]
	for (i = 0; i < (nand->page_size>>1); i++) {
 898:	e51b300c 	ldr	r3, [fp, #-12]
 89c:	e2833001 	add	r3, r3, #1
 8a0:	e50b300c 	str	r3, [fp, #-12]
 8a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 8a8:	e5933000 	ldr	r3, [r3]
 8ac:	e1a030c3 	asr	r3, r3, #1
 8b0:	e1a02003 	mov	r2, r3
 8b4:	e51b300c 	ldr	r3, [fp, #-12]
 8b8:	e1530002 	cmp	r3, r2
 8bc:	3affffec 	bcc	874 <nand_read_page+0x13c>
	}

	return nand->page_size;
 8c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 8c4:	e5933000 	ldr	r3, [r3]
}
 8c8:	e1a00003 	mov	r0, r3
 8cc:	e24bd004 	sub	sp, fp, #4
 8d0:	e8bd4800 	pop	{fp, lr}
 8d4:	e12fff1e 	bx	lr
 8d8:	4e000020 	.word	0x4e000020
 8dc:	4e000008 	.word	0x4e000008
 8e0:	4e00000c 	.word	0x4e00000c
 8e4:	4e000010 	.word	0x4e000010

000008e8 <nand_read_id>:


static unsigned short nand_read_id()
{
 8e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
 8ec:	e28db000 	add	fp, sp, #0
 8f0:	e24dd00c 	sub	sp, sp, #12
	unsigned short res = 0;
 8f4:	e3a03000 	mov	r3, #0
 8f8:	e14b30b6 	strh	r3, [fp, #-6]
	NFCMD = NAND_CMD_READID;
 8fc:	e59f3068 	ldr	r3, [pc, #104]	; 96c <nand_read_id+0x84>
 900:	e3e0206f 	mvn	r2, #111	; 0x6f
 904:	e5c32000 	strb	r2, [r3]
	NFADDR = 0;
 908:	e59f3060 	ldr	r3, [pc, #96]	; 970 <nand_read_id+0x88>
 90c:	e3a02000 	mov	r2, #0
 910:	e5c32000 	strb	r2, [r3]
	res = NFDATA;
 914:	e59f3058 	ldr	r3, [pc, #88]	; 974 <nand_read_id+0x8c>
 918:	e5d33000 	ldrb	r3, [r3]
 91c:	e20330ff 	and	r3, r3, #255	; 0xff
 920:	e14b30b6 	strh	r3, [fp, #-6]
	res = (res << 8) | NFDATA;
 924:	e15b30b6 	ldrh	r3, [fp, #-6]
 928:	e1a03403 	lsl	r3, r3, #8
 92c:	e1a03803 	lsl	r3, r3, #16
 930:	e1a02843 	asr	r2, r3, #16
 934:	e59f3038 	ldr	r3, [pc, #56]	; 974 <nand_read_id+0x8c>
 938:	e5d33000 	ldrb	r3, [r3]
 93c:	e20330ff 	and	r3, r3, #255	; 0xff
 940:	e1a03803 	lsl	r3, r3, #16
 944:	e1a03843 	asr	r3, r3, #16
 948:	e1823003 	orr	r3, r2, r3
 94c:	e1a03803 	lsl	r3, r3, #16
 950:	e1a03843 	asr	r3, r3, #16
 954:	e14b30b6 	strh	r3, [fp, #-6]
	return res;
 958:	e15b30b6 	ldrh	r3, [fp, #-6]
}
 95c:	e1a00003 	mov	r0, r3
 960:	e28bd000 	add	sp, fp, #0
 964:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
 968:	e12fff1e 	bx	lr
 96c:	4e000008 	.word	0x4e000008
 970:	4e00000c 	.word	0x4e00000c
 974:	4e000010 	.word	0x4e000010

00000978 <nand_read>:



int nand_read(unsigned char *buf, unsigned long start_addr, int size)
{
 978:	e92d4800 	push	{fp, lr}
 97c:	e28db004 	add	fp, sp, #4
 980:	e24dd028 	sub	sp, sp, #40	; 0x28
 984:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
 988:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
 98c:	e50b2028 	str	r2, [fp, #-40]	; 0xffffffd8
	int i, j;
	unsigned short nand_id;
	struct boot_nand_t nand;

	
	nand_select();
 990:	e59f3270 	ldr	r3, [pc, #624]	; c08 <nand_read+0x290>
 994:	e5933000 	ldr	r3, [r3]
 998:	e59f2268 	ldr	r2, [pc, #616]	; c08 <nand_read+0x290>
 99c:	e3c33002 	bic	r3, r3, #2
 9a0:	e5823000 	str	r3, [r2]
	nand_clear_RnB();
 9a4:	e59f3260 	ldr	r3, [pc, #608]	; c0c <nand_read+0x294>
 9a8:	e5d33000 	ldrb	r3, [r3]
 9ac:	e20330ff 	and	r3, r3, #255	; 0xff
 9b0:	e59f2254 	ldr	r2, [pc, #596]	; c0c <nand_read+0x294>
 9b4:	e3833004 	orr	r3, r3, #4
 9b8:	e20330ff 	and	r3, r3, #255	; 0xff
 9bc:	e5c23000 	strb	r3, [r2]
	
	for (i = 0; i < 10; i++);
 9c0:	e3a03000 	mov	r3, #0
 9c4:	e50b3008 	str	r3, [fp, #-8]
 9c8:	ea000002 	b	9d8 <nand_read+0x60>
 9cc:	e51b3008 	ldr	r3, [fp, #-8]
 9d0:	e2833001 	add	r3, r3, #1
 9d4:	e50b3008 	str	r3, [fp, #-8]
 9d8:	e51b3008 	ldr	r3, [fp, #-8]
 9dc:	e3530009 	cmp	r3, #9
 9e0:	dafffff9 	ble	9cc <nand_read+0x54>

	nand_id = nand_read_id();	
 9e4:	ebffffbf 	bl	8e8 <nand_read_id>
 9e8:	e1a03000 	mov	r3, r0
 9ec:	e14b30ba 	strh	r3, [fp, #-10]

       if (nand_id == 0xec76 ||		/* Samsung K91208 */
 9f0:	e15b30ba 	ldrh	r3, [fp, #-10]
 9f4:	e59f2214 	ldr	r2, [pc, #532]	; c10 <nand_read+0x298>
 9f8:	e1530002 	cmp	r3, r2
 9fc:	0a000003 	beq	a10 <nand_read+0x98>
 a00:	e15b30ba 	ldrh	r3, [fp, #-10]
 a04:	e59f2208 	ldr	r2, [pc, #520]	; c14 <nand_read+0x29c>
 a08:	e1530002 	cmp	r3, r2
 a0c:	1a000006 	bne	a2c <nand_read+0xb4>
           nand_id == 0xad76 ) {	/*Hynix HY27US08121A*/
		nand.page_size = 512;
 a10:	e3a03c02 	mov	r3, #512	; 0x200
 a14:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 16 * 1024;
 a18:	e3a03901 	mov	r3, #16384	; 0x4000
 a1c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = 5;
 a20:	e3a03005 	mov	r3, #5
 a24:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
 a28:	ea000014 	b	a80 <nand_read+0x108>
	} 
        else if (nand_id == 0xecf1 ||	/* Samsung K9F1G08U0B */
 a2c:	e15b30ba 	ldrh	r3, [fp, #-10]
 a30:	e59f21e0 	ldr	r2, [pc, #480]	; c18 <nand_read+0x2a0>
 a34:	e1530002 	cmp	r3, r2
 a38:	0a000007 	beq	a5c <nand_read+0xe4>
 a3c:	e15b30ba 	ldrh	r3, [fp, #-10]
 a40:	e59f21d4 	ldr	r2, [pc, #468]	; c1c <nand_read+0x2a4>
 a44:	e1530002 	cmp	r3, r2
 a48:	0a000003 	beq	a5c <nand_read+0xe4>
		   nand_id == 0xecda ||	/* Samsung K9F2G08U0B */
 a4c:	e15b30ba 	ldrh	r3, [fp, #-10]
 a50:	e59f21c8 	ldr	r2, [pc, #456]	; c20 <nand_read+0x2a8>
 a54:	e1530002 	cmp	r3, r2
 a58:	1a000006 	bne	a78 <nand_read+0x100>
		   nand_id == 0xecd3 )	{ /* Samsung K9K8G08 */
		nand.page_size = 2048;
 a5c:	e3a03b02 	mov	r3, #2048	; 0x800
 a60:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 128 * 1024;
 a64:	e3a03802 	mov	r3, #131072	; 0x20000
 a68:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = nand.page_size;
 a6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 a70:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
 a74:	ea000001 	b	a80 <nand_read+0x108>
	} 
        else {
		return -1; 
 a78:	e3e03000 	mvn	r3, #0
 a7c:	ea00005d 	b	bf8 <nand_read+0x280>
	}

         if ((start_addr & (nand.block_size-1)))
 a80:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 a84:	e2433001 	sub	r3, r3, #1
 a88:	e1a02003 	mov	r2, r3
 a8c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 a90:	e0033002 	and	r3, r3, r2
 a94:	e3530000 	cmp	r3, #0
 a98:	0a000001 	beq	aa4 <nand_read+0x12c>
		return -1;	
 a9c:	e3e03000 	mvn	r3, #0
 aa0:	ea000054 	b	bf8 <nand_read+0x280>
        
        if(size & (nand.page_size-1)){
 aa4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 aa8:	e2432001 	sub	r2, r3, #1
 aac:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 ab0:	e0033002 	and	r3, r3, r2
 ab4:	e3530000 	cmp	r3, #0
 ab8:	0a000007 	beq	adc <nand_read+0x164>
             size=(size+nand.page_size-1) & (~(nand.page_size-1));
 abc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
 ac0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 ac4:	e0823003 	add	r3, r2, r3
 ac8:	e2432001 	sub	r2, r3, #1
 acc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 ad0:	e2633000 	rsb	r3, r3, #0
 ad4:	e0033002 	and	r3, r3, r2
 ad8:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
        }

        if ((size & (nand.page_size-1)))
 adc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 ae0:	e2432001 	sub	r2, r3, #1
 ae4:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 ae8:	e0033002 	and	r3, r3, r2
 aec:	e3530000 	cmp	r3, #0
 af0:	0a000001 	beq	afc <nand_read+0x184>
		return -1;
 af4:	e3e03000 	mvn	r3, #0
 af8:	ea00003e 	b	bf8 <nand_read+0x280>

	for (i=start_addr; i < (start_addr + size);) {
 afc:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 b00:	e50b3008 	str	r3, [fp, #-8]
 b04:	ea00002f 	b	bc8 <nand_read+0x250>

		if ((i & (nand.block_size-1))== 0) {
 b08:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 b0c:	e2432001 	sub	r2, r3, #1
 b10:	e51b3008 	ldr	r3, [fp, #-8]
 b14:	e0033002 	and	r3, r3, r2
 b18:	e3530000 	cmp	r3, #0
 b1c:	1a00001b 	bne	b90 <nand_read+0x218>
			if (is_bad_block(&nand, i) || is_bad_block(&nand, i + nand.page_size)) {
 b20:	e51b2008 	ldr	r2, [fp, #-8]
 b24:	e24b301c 	sub	r3, fp, #28
 b28:	e1a01002 	mov	r1, r2
 b2c:	e1a00003 	mov	r0, r3
 b30:	ebfffe9b 	bl	5a4 <is_bad_block>
 b34:	e1a03000 	mov	r3, r0
 b38:	e3530000 	cmp	r3, #0
 b3c:	1a00000a 	bne	b6c <nand_read+0x1f4>
 b40:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
 b44:	e51b3008 	ldr	r3, [fp, #-8]
 b48:	e0823003 	add	r3, r2, r3
 b4c:	e1a02003 	mov	r2, r3
 b50:	e24b301c 	sub	r3, fp, #28
 b54:	e1a01002 	mov	r1, r2
 b58:	e1a00003 	mov	r0, r3
 b5c:	ebfffe90 	bl	5a4 <is_bad_block>
 b60:	e1a03000 	mov	r3, r0
 b64:	e3530000 	cmp	r3, #0
 b68:	0a000008 	beq	b90 <nand_read+0x218>
				i += nand.block_size;
 b6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 b70:	e51b2008 	ldr	r2, [fp, #-8]
 b74:	e0823003 	add	r3, r2, r3
 b78:	e50b3008 	str	r3, [fp, #-8]
				size += nand.block_size;
 b7c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 b80:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
 b84:	e0823003 	add	r3, r2, r3
 b88:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
				continue;
 b8c:	ea00000d 	b	bc8 <nand_read+0x250>
			}
		}

		j = nand_read_page(&nand, buf, i);
 b90:	e51b2008 	ldr	r2, [fp, #-8]
 b94:	e24b301c 	sub	r3, fp, #28
 b98:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
 b9c:	e1a00003 	mov	r0, r3
 ba0:	ebfffee4 	bl	738 <nand_read_page>
 ba4:	e50b0010 	str	r0, [fp, #-16]
		i += j;
 ba8:	e51b2008 	ldr	r2, [fp, #-8]
 bac:	e51b3010 	ldr	r3, [fp, #-16]
 bb0:	e0823003 	add	r3, r2, r3
 bb4:	e50b3008 	str	r3, [fp, #-8]
		buf += j;
 bb8:	e51b3010 	ldr	r3, [fp, #-16]
 bbc:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
 bc0:	e0823003 	add	r3, r2, r3
 bc4:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
	for (i=start_addr; i < (start_addr + size);) {
 bc8:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
 bcc:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 bd0:	e0822003 	add	r2, r2, r3
 bd4:	e51b3008 	ldr	r3, [fp, #-8]
 bd8:	e1520003 	cmp	r2, r3
 bdc:	8affffc9 	bhi	b08 <nand_read+0x190>
	}


	nand_deselect();
 be0:	e59f3020 	ldr	r3, [pc, #32]	; c08 <nand_read+0x290>
 be4:	e5933000 	ldr	r3, [r3]
 be8:	e59f2018 	ldr	r2, [pc, #24]	; c08 <nand_read+0x290>
 bec:	e3833002 	orr	r3, r3, #2
 bf0:	e5823000 	str	r3, [r2]

	return 0;
 bf4:	e3a03000 	mov	r3, #0
}
 bf8:	e1a00003 	mov	r0, r3
 bfc:	e24bd004 	sub	sp, fp, #4
 c00:	e8bd4800 	pop	{fp, lr}
 c04:	e12fff1e 	bx	lr
 c08:	4e000004 	.word	0x4e000004
 c0c:	4e000020 	.word	0x4e000020
 c10:	0000ec76 	.word	0x0000ec76
 c14:	0000ad76 	.word	0x0000ad76
 c18:	0000ecf1 	.word	0x0000ecf1
 c1c:	0000ecda 	.word	0x0000ecda
 c20:	0000ecd3 	.word	0x0000ecd3
