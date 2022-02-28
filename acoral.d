
acoral.elf:     file format elf32-littlearm


Disassembly of section .text:

30000000 <__ENTRY>:
	.extern acoral_start

	.global __ENTRY
	.global HandleIRQ
__ENTRY:
	b	ResetHandler
30000000:	ea000017 	b	30000064 <ResetHandler>
	b	HandleUndef		@handler for Undefined mode
30000004:	ea00000d 	b	30000040 <HandleUndef>
	b	HandleSWI       @handler for SWI interrupt
30000008:	ea00000d 	b	30000044 <HandleSWI>
	b	HandlePabort	@handler for PAbort
3000000c:	ea00000e 	b	3000004c <HandlePabort>
	b	HandleDabort	@handler for DAbort
30000010:	ea00000c 	b	30000048 <HandleDabort>
	b   .				@reserved
30000014:	eafffffe 	b	30000014 <__ENTRY+0x14>
	b   HandleIRQ 		@handler for IRQ interrupt
30000018:	ea000007 	b	3000003c <HandleIRQ>
	b	HandleFIQ		@handler for FIQ interrupt
3000001c:	ea000005 	b	30000038 <HandleFIQ>
	...
30000028:	30000000 	.word	0x30000000
3000002c:	00000988 	.word	0x00000988
30000030:	00000000 	.word	0x00000000
@ 0x2C: this contains the platform, cpu and machine id
	.long   2440
@ 0x30:  capabilities
	.long   0
@ 0x34:
	b   	.
30000034:	eafffffe 	b	30000034 <__ENTRY+0x34>

30000038 <HandleFIQ>:
@****************************************************************
@ intvector setup
@****************************************************************

HandleFIQ:
	ldr pc,=acoral_start
30000038:	e59ff254 	ldr	pc, [pc, #596]	; 30000294 <mem_cfg_val+0x34>

3000003c <HandleIRQ>:
HandleIRQ:
	ldr pc,=HAL_INTR_ENTRY
3000003c:	e59ff254 	ldr	pc, [pc, #596]	; 30000298 <mem_cfg_val+0x38>

30000040 <HandleUndef>:
HandleUndef:
	ldr pc,=EXP_HANDLER
30000040:	e59ff254 	ldr	pc, [pc, #596]	; 3000029c <mem_cfg_val+0x3c>

30000044 <HandleSWI>:
HandleSWI:
	ldr pc,=EXP_HANDLER
30000044:	e59ff250 	ldr	pc, [pc, #592]	; 3000029c <mem_cfg_val+0x3c>

30000048 <HandleDabort>:
HandleDabort:
	ldr pc,=EXP_HANDLER
30000048:	e59ff24c 	ldr	pc, [pc, #588]	; 3000029c <mem_cfg_val+0x3c>

3000004c <HandlePabort>:
HandlePabort:
	ldr pc,=EXP_HANDLER
3000004c:	e59ff248 	ldr	pc, [pc, #584]	; 3000029c <mem_cfg_val+0x3c>

30000050 <_text_load_addr>:
30000050:	00000000 	.word	0x00000000

30000054 <_text_start>:
30000054:	30000000 	.word	0x30000000

30000058 <_bss_load_addr>:
30000058:	00000c24 	.word	0x00000c24

3000005c <_bss_start>:
3000005c:	30000c24 	.word	0x30000c24

30000060 <_bss_end>:
30000060:	30000c24 	.word	0x30000c24

30000064 <ResetHandler>:
@****************************************************************
@             ResetHandler fuction
@****************************************************************
ResetHandler:
	@ disable watch dog timer
	mov	r1, #0x53000000
30000064:	e3a01453 	mov	r1, #1392508928	; 0x53000000
	mov	r2, #0x0
30000068:	e3a02000 	mov	r2, #0
	str	r2, [r1]
3000006c:	e5812000 	str	r2, [r1]

	@ disable all interrupts
	mov	r1, #INT_CTL_BASE
30000070:	e3a0144a 	mov	r1, #1241513984	; 0x4a000000
	mov	r2, #0xffffffff
30000074:	e3e02000 	mvn	r2, #0
	str	r2, [r1, #oINTMSK]
30000078:	e5812008 	str	r2, [r1, #8]
	ldr	r2, =0x7ff
3000007c:	e59f221c 	ldr	r2, [pc, #540]	; 300002a0 <mem_cfg_val+0x40>
	str	r2, [r1, #oINTSUBMSK]
30000080:	e581201c 	str	r2, [r1, #28]

	@ initialise system clocks
	mov	r1, #CLK_CTL_BASE
30000084:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mvn	r2, #0xff000000
30000088:	e3e024ff 	mvn	r2, #-16777216	; 0xff000000
	str	r2, [r1, #oLOCKTIME]
3000008c:	e5812000 	str	r2, [r1]

	mov	r1, #CLK_CTL_BASE
30000090:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mov	r2, #M_DIVN
30000094:	e3a02005 	mov	r2, #5
	str	r2, [r1, #oCLKDIVN]
30000098:	e5812014 	str	r2, [r1, #20]

	mrc	p15, 0, r1, c1, c0, 0	@ read ctrl register
3000009c:	ee111f10 	mrc	15, 0, r1, cr1, cr0, {0}
	orr	r1, r1, #0xc0000000	@ Asynchronous
300000a0:	e3811103 	orr	r1, r1, #-1073741824	; 0xc0000000
	mcr	p15, 0, r1, c1, c0, 0	@ write ctrl register
300000a4:	ee011f10 	mcr	15, 0, r1, cr1, cr0, {0}

	mov	r1, #CLK_CTL_BASE
300000a8:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	ldr 	r2, =vMPLLCON	        @ clock user set
300000ac:	e59f21f0 	ldr	r2, [pc, #496]	; 300002a4 <mem_cfg_val+0x44>
	str	r2, [r1, #oMPLLCON]
300000b0:	e5812004 	str	r2, [r1, #4]

	bl	memsetup
300000b4:	eb000059 	bl	30000220 <memsetup>
	ldr r0, [r1]  
	tst r0, #PMST_SMR  
	bne WakeupStart 
#endif
		
	bl      InitStacks
300000b8:	eb00003f 	bl	300001bc <InitStacks>

	adr  r0,__ENTRY
300000bc:	e24f00c4 	sub	r0, pc, #196	; 0xc4
	ldr  r1,_text_load_addr
300000c0:	e51f1078 	ldr	r1, [pc, #-120]	; 30000050 <_text_load_addr>
	cmp  r0,r1
300000c4:	e1500001 	cmp	r0, r1
	blne copy_self  
300000c8:	1b000004 	blne	300000e0 <copy_self>

	ldr  r0,_bss_start
300000cc:	e51f0078 	ldr	r0, [pc, #-120]	; 3000005c <_bss_start>
	ldr  r1,_bss_end
300000d0:	e51f1078 	ldr	r1, [pc, #-120]	; 30000060 <_bss_end>
	bl    mem_clear
300000d4:	eb00005a 	bl	30000244 <mem_clear>
	ldr    pc,=acoral_start	
300000d8:	e59ff1b4 	ldr	pc, [pc, #436]	; 30000294 <mem_cfg_val+0x34>
	b 	.
300000dc:	eafffffe 	b	300000dc <ResetHandler+0x78>

300000e0 <copy_self>:

#endif
 
copy_self:

        ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )		/* address of Internal SRAM  0x4000002C*/
300000e0:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	mov	r0, #0		
300000e4:	e3a00000 	mov	r0, #0
	str	r0, [r1]
300000e8:	e5810000 	str	r0, [r1]


	mov	r1, #0x2c		               /* address of men  0x0000002C*/
300000ec:	e3a0102c 	mov	r1, #44	; 0x2c
	ldr	r0, [r1]
300000f0:	e5910000 	ldr	r0, [r1]
	cmp	r0, #0
300000f4:	e3500000 	cmp	r0, #0
	bne	copy_from_rom
300000f8:	1a000003 	bne	3000010c <copy_from_rom>
        
        ldr	r0, =(2440)
300000fc:	e59f01a4 	ldr	r0, [pc, #420]	; 300002a8 <mem_cfg_val+0x48>
	ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )
30000100:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	str	r0, [r1]
30000104:	e5810000 	str	r0, [r1]
	b       copy_from_nand 
30000108:	ea000007 	b	3000012c <copy_from_nand>

3000010c <copy_from_rom>:



copy_from_rom:
	mov   r0,   #0
3000010c:	e3a00000 	mov	r0, #0
	ldr   r1,   _text_start
30000110:	e51f10c4 	ldr	r1, [pc, #-196]	; 30000054 <_text_start>
	ldr   r3,   _bss_start
30000114:	e51f30c0 	ldr	r3, [pc, #-192]	; 3000005c <_bss_start>
	ldr   r2,   [r0],#4
30000118:	e4902004 	ldr	r2, [r0], #4
	str   r2,   [r1],#4
3000011c:	e4812004 	str	r2, [r1], #4
	cmp   r1,   r3
30000120:	e1510003 	cmp	r1, r3
	blt   copy_from_rom	
30000124:	bafffff8 	blt	3000010c <copy_from_rom>
	mov   pc,  lr
30000128:	e1a0f00e 	mov	pc, lr

3000012c <copy_from_nand>:

copy_from_nand:
	stmfd   sp!, {lr}
3000012c:	e92d4000 	stmfd	sp!, {lr}
	bl      nand_init
30000130:	eb00010c 	bl	30000568 <nand_init>
	ldr     r0,  _text_start
30000134:	e51f00e8 	ldr	r0, [pc, #-232]	; 30000054 <_text_start>
	mov     r1,  #0
30000138:	e3a01000 	mov	r1, #0
	ldr     r3,  _bss_start
3000013c:	e51f30e8 	ldr	r3, [pc, #-232]	; 3000005c <_bss_start>
        sub     r2,  r3, r0
30000140:	e0432000 	sub	r2, r3, r0

        bl      nand_read
30000144:	eb00020b 	bl	30000978 <nand_read>
        cmp	r0,  #0x0
30000148:	e3500000 	cmp	r0, #0
	beq     ok_nand_read
3000014c:	0a000007 	beq	30000170 <ok_nand_read>

30000150 <bad_nand_read>:


bad_nand_read:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
30000150:	e59f0154 	ldr	r0, [pc, #340]	; 300002ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00001000        
30000154:	e3a01a01 	mov	r1, #4096	; 0x1000
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
30000158:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
3000015c:	e59f014c 	ldr	r0, [pc, #332]	; 300002b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
30000160:	e3a01000 	mov	r1, #0
                                        @ 可让LED2熄灭
         str     r1,[r0]             @ GPB5输出0，LED2点亮
30000164:	e5801000 	str	r1, [r0]

         b       .
30000168:	eafffffe 	b	30000168 <bad_nand_read+0x18>

	 b	bad_nand_read	@ infinite loop
3000016c:	eafffff7 	b	30000150 <bad_nand_read>

30000170 <ok_nand_read>:


ok_nand_read:    	

	mov	r0, #0
30000170:	e3a00000 	mov	r0, #0
	ldr	r1, _text_start
30000174:	e51f1128 	ldr	r1, [pc, #-296]	; 30000054 <_text_start>
	mov	r2, #512	
30000178:	e3a02c02 	mov	r2, #512	; 0x200

3000017c <go_next>:
go_next:
	ldr	r3, [r0], #4
3000017c:	e4903004 	ldr	r3, [r0], #4
	ldr	r4, [r1], #4
30000180:	e4914004 	ldr	r4, [r1], #4
	cmp	r3, r4
30000184:	e1530004 	cmp	r3, r4
	bne	notmatch
30000188:	1a000002 	bne	30000198 <notmatch>
	cmp     r0, r2
3000018c:	e1500002 	cmp	r0, r2
	beq	out
30000190:	0a000008 	beq	300001b8 <out>
	b	go_next
30000194:	eafffff8 	b	3000017c <go_next>

30000198 <notmatch>:
	

notmatch:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
30000198:	e59f010c 	ldr	r0, [pc, #268]	; 300002ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00000400        
3000019c:	e3a01b01 	mov	r1, #1024	; 0x400
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
300001a0:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
300001a4:	e59f0104 	ldr	r0, [pc, #260]	; 300002b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
300001a8:	e3a01000 	mov	r1, #0
                                        @ 可让LED1熄灭
         str     r1,[r0]             @ GPB5输出0，LED1点亮
300001ac:	e5801000 	str	r1, [r0]

         b       .
300001b0:	eafffffe 	b	300001b0 <notmatch+0x18>

	 b	notmatch
300001b4:	eafffff7 	b	30000198 <notmatch>

300001b8 <out>:

out:
        ldmfd sp!,{lr} 
300001b8:	e8bd4000 	ldmfd	sp!, {lr}

300001bc <InitStacks>:
@***************************************************************
@                       堆栈初始化
@***************************************************************

InitStacks:
	mov r2,lr
300001bc:	e1a0200e 	mov	r2, lr
	mrs	r0,cpsr
300001c0:	e10f0000 	mrs	r0, CPSR
	bic	r0,r0,#MODE_MASK
300001c4:	e3c0001f 	bic	r0, r0, #31
	orr	r1,r0,#UND_MODE|NOINT
300001c8:	e38010db 	orr	r1, r0, #219	; 0xdb
	msr	cpsr_cxsf,r1		@UndefMode
300001cc:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_FC00
300001d0:	e59fd0dc 	ldr	sp, [pc, #220]	; 300002b4 <mem_cfg_val+0x54>

	orr	r1,r0,#ABT_MODE|NOINT
300001d4:	e38010d7 	orr	r1, r0, #215	; 0xd7
	msr	cpsr_cxsf,r1		@AbortMode
300001d8:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_FD00
300001dc:	e59fd0d4 	ldr	sp, [pc, #212]	; 300002b8 <mem_cfg_val+0x58>

	orr	r1,r0,#IRQ_MODE|NOINT
300001e0:	e38010d2 	orr	r1, r0, #210	; 0xd2
	msr	cpsr_cxsf,r1		@IRQMode
300001e4:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
300001e8:	e59fd0cc 	ldr	sp, [pc, #204]	; 300002bc <mem_cfg_val+0x5c>

	orr	r1,r0,#FIQ_MODE|NOINT
300001ec:	e38010d1 	orr	r1, r0, #209	; 0xd1
	msr	cpsr_cxsf,r1		@FIQMode
300001f0:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
300001f4:	e59fd0c4 	ldr	sp, [pc, #196]	; 300002c0 <mem_cfg_val+0x60>

	bic	r0,r0,#MODE_MASK|NOINT
300001f8:	e3c000df 	bic	r0, r0, #223	; 0xdf
	orr	r1,r0,#SVC_MODE
300001fc:	e3801013 	orr	r1, r0, #19
	msr	cpsr_cxsf,r1		@SVCMode
30000200:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
30000204:	e59fd0b8 	ldr	sp, [pc, #184]	; 300002c4 <mem_cfg_val+0x64>

	mrs     r0,cpsr
30000208:	e10f0000 	mrs	r0, CPSR
       	bic     r0,r0,#MODE_MASK
3000020c:	e3c0001f 	bic	r0, r0, #31
	orr     r1,r0,#SYS_MODE|NOINT
30000210:	e38010df 	orr	r1, r0, #223	; 0xdf
	msr     cpsr_cxsf,r1    	@ userMode
30000214:	e12ff001 	msr	CPSR_fsxc, r1
	ldr     sp,=SYS_stack
30000218:	e59fd0a8 	ldr	sp, [pc, #168]	; 300002c8 <mem_cfg_val+0x68>

	mov	pc,r2
3000021c:	e1a0f002 	mov	pc, r2

30000220 <memsetup>:
@***************************************************************
@ initialise the static memory
@ set memory control registers
@***************************************************************
memsetup:
	mov	r1, #MEM_CTL_BASE
30000220:	e3a01312 	mov	r1, #1207959552	; 0x48000000
	adrl	r2, mem_cfg_val
30000224:	e28f2034 	add	r2, pc, #52	; 0x34
30000228:	e1a00000 	nop			; (mov r0, r0)
	add	r3, r1, #52
3000022c:	e2813034 	add	r3, r1, #52	; 0x34
1:	ldr	r4, [r2], #4
30000230:	e4924004 	ldr	r4, [r2], #4
	str	r4, [r1], #4
30000234:	e4814004 	str	r4, [r1], #4
	cmp	r1, r3
30000238:	e1510003 	cmp	r1, r3
	bne	1b
3000023c:	1afffffb 	bne	30000230 <memsetup+0x10>
	mov	pc, lr
30000240:	e1a0f00e 	mov	pc, lr

30000244 <mem_clear>:
@ r0: start address
@ r1: length
@***************************************************************

mem_clear:
	mov r2,#0
30000244:	e3a02000 	mov	r2, #0
1:	str r2,[r0],#4
30000248:	e4802004 	str	r2, [r0], #4
	cmp r0,r1
3000024c:	e1500001 	cmp	r0, r1
	blt 1b
30000250:	bafffffc 	blt	30000248 <mem_clear+0x4>
	mov pc,lr
30000254:	e1a0f00e 	mov	pc, lr
30000258:	e1a00000 	nop			; (mov r0, r0)
3000025c:	e1a00000 	nop			; (mov r0, r0)

30000260 <mem_cfg_val>:
30000260:	22111110 	.word	0x22111110
30000264:	00000700 	.word	0x00000700
30000268:	00000700 	.word	0x00000700
3000026c:	00000700 	.word	0x00000700
30000270:	00000700 	.word	0x00000700
30000274:	00000700 	.word	0x00000700
30000278:	00000700 	.word	0x00000700
3000027c:	00018009 	.word	0x00018009
30000280:	00018009 	.word	0x00018009
30000284:	008e04eb 	.word	0x008e04eb
30000288:	000000b2 	.word	0x000000b2
3000028c:	00000030 	.word	0x00000030
30000290:	00000030 	.word	0x00000030
	ldr pc,=acoral_start
30000294:	300002cc 	.word	0x300002cc
	ldr pc,=HAL_INTR_ENTRY
30000298:	300003dc 	.word	0x300003dc
	ldr pc,=EXP_HANDLER
3000029c:	30000418 	.word	0x30000418
	ldr	r2, =0x7ff
300002a0:	000007ff 	.word	0x000007ff
	ldr 	r2, =vMPLLCON	        @ clock user set
300002a4:	0007f021 	.word	0x0007f021
        ldr	r0, =(2440)
300002a8:	00000988 	.word	0x00000988
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
300002ac:	56000010 	.word	0x56000010
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
300002b0:	56000014 	.word	0x56000014
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_FC00
300002b4:	33fffc00 	.word	0x33fffc00
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_FD00
300002b8:	33fffd00 	.word	0x33fffd00
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
300002bc:	33ffff00 	.word	0x33ffff00
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
300002c0:	33ffff00 	.word	0x33ffff00
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
300002c4:	33fffb00 	.word	0x33fffb00
	ldr     sp,=SYS_stack
300002c8:	33fff900 	.word	0x33fff900

300002cc <acoral_start>:
#include "ch1.h"

int acoral_start(){
300002cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
300002d0:	e28db000 	add	fp, sp, #0
	rCLKDIVN = 0X5;	
300002d4:	e59f30d0 	ldr	r3, [pc, #208]	; 300003ac <acoral_start+0xe0>
300002d8:	e3a02005 	mov	r2, #5
300002dc:	e5832000 	str	r2, [r3]
	rMPLLCON = (0X7f<<12) | (0X2<<4) | (0X1);
300002e0:	e59f30c8 	ldr	r3, [pc, #200]	; 300003b0 <acoral_start+0xe4>
300002e4:	e59f20c8 	ldr	r2, [pc, #200]	; 300003b4 <acoral_start+0xe8>
300002e8:	e5832000 	str	r2, [r3]
	rGPGCON = 0;			//检测按键状态
300002ec:	e59f30c4 	ldr	r3, [pc, #196]	; 300003b8 <acoral_start+0xec>
300002f0:	e3a02000 	mov	r2, #0
300002f4:	e5832000 	str	r2, [r3]
	while(1){
		if((rGPGDAT & 0x1)==0)
300002f8:	e59f30bc 	ldr	r3, [pc, #188]	; 300003bc <acoral_start+0xf0>
300002fc:	e5933000 	ldr	r3, [r3]
30000300:	e2033001 	and	r3, r3, #1
30000304:	e3530000 	cmp	r3, #0
30000308:	0a000000 	beq	30000310 <acoral_start+0x44>
3000030c:	eafffff9 	b	300002f8 <acoral_start+0x2c>
        	break;
30000310:	e1a00000 	nop			; (mov r0, r0)
		}
	rTCFG0 |= 0xF9;			/* prescaler等于249*/
30000314:	e3a03451 	mov	r3, #1358954496	; 0x51000000
30000318:	e5933000 	ldr	r3, [r3]
3000031c:	e3a02451 	mov	r2, #1358954496	; 0x51000000
30000320:	e38330f9 	orr	r3, r3, #249	; 0xf9
30000324:	e5823000 	str	r3, [r2]
 	rTCFG1 |= 0x3;			/*divider等于16*/
30000328:	e59f3090 	ldr	r3, [pc, #144]	; 300003c0 <acoral_start+0xf4>
3000032c:	e5933000 	ldr	r3, [r3]
30000330:	e59f2088 	ldr	r2, [pc, #136]	; 300003c0 <acoral_start+0xf4>
30000334:	e3833003 	orr	r3, r3, #3
30000338:	e5823000 	str	r3, [r2]
   	rTCNTB0 = 0X61A9;          		/*计数值25001*/
3000033c:	e59f3080 	ldr	r3, [pc, #128]	; 300003c4 <acoral_start+0xf8>
30000340:	e59f2080 	ldr	r2, [pc, #128]	; 300003c8 <acoral_start+0xfc>
30000344:	e5832000 	str	r2, [r3]
   	rTCON = rTCON & (~0xf) |0x02;           	/* 更新TCNT0*/
30000348:	e59f307c 	ldr	r3, [pc, #124]	; 300003cc <acoral_start+0x100>
3000034c:	e5933000 	ldr	r3, [r3]
30000350:	e3c3300f 	bic	r3, r3, #15
30000354:	e59f2070 	ldr	r2, [pc, #112]	; 300003cc <acoral_start+0x100>
30000358:	e3833002 	orr	r3, r3, #2
3000035c:	e5823000 	str	r3, [r2]
	rTCON = rTCON & (~0xf) |0x01; 	/* start定时器0*/
30000360:	e59f3064 	ldr	r3, [pc, #100]	; 300003cc <acoral_start+0x100>
30000364:	e5933000 	ldr	r3, [r3]
30000368:	e3c3300f 	bic	r3, r3, #15
3000036c:	e59f2058 	ldr	r2, [pc, #88]	; 300003cc <acoral_start+0x100>
30000370:	e3833001 	orr	r3, r3, #1
30000374:	e5823000 	str	r3, [r2]
	while(1){
		if(rTCNTO0 == 1)		/*倒计时到1，两秒*/
30000378:	e59f3050 	ldr	r3, [pc, #80]	; 300003d0 <acoral_start+0x104>
3000037c:	e5933000 	ldr	r3, [r3]
30000380:	e3530001 	cmp	r3, #1
30000384:	0a000000 	beq	3000038c <acoral_start+0xc0>
30000388:	eafffffa 	b	30000378 <acoral_start+0xac>
        	break;
3000038c:	e1a00000 	nop			; (mov r0, r0)
		}
	rGPBCON = 0x400;			
30000390:	e59f303c 	ldr	r3, [pc, #60]	; 300003d4 <acoral_start+0x108>
30000394:	e3a02b01 	mov	r2, #1024	; 0x400
30000398:	e5832000 	str	r2, [r3]
	rGPBDAT = 0x1C0; 			//点亮LED
3000039c:	e59f3034 	ldr	r3, [pc, #52]	; 300003d8 <acoral_start+0x10c>
300003a0:	e3a02d07 	mov	r2, #448	; 0x1c0
300003a4:	e5832000 	str	r2, [r3]
	while(1);
300003a8:	eafffffe 	b	300003a8 <acoral_start+0xdc>
300003ac:	4c000014 	.word	0x4c000014
300003b0:	4c000004 	.word	0x4c000004
300003b4:	0007f021 	.word	0x0007f021
300003b8:	56000060 	.word	0x56000060
300003bc:	56000064 	.word	0x56000064
300003c0:	51000004 	.word	0x51000004
300003c4:	5100000c 	.word	0x5100000c
300003c8:	000061a9 	.word	0x000061a9
300003cc:	51000008 	.word	0x51000008
300003d0:	51000014 	.word	0x51000014
300003d4:	56000010 	.word	0x56000010
300003d8:	56000014 	.word	0x56000014

300003dc <HAL_INTR_ENTRY>:
   .global     HAL_INTR_DISABLE_SAVE
   .global     HAL_INTR_RESTORE
   .extern     IRQ_stack

HAL_INTR_ENTRY:
    stmfd   sp!,    {r0-r12,lr}           @保护通用寄存器及PC 
300003dc:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    mrs     r1,     spsr
300003e0:	e14f1000 	mrs	r1, SPSR
    stmfd   sp!,    {r1}                  @保护spsr,以支持中断嵌套
300003e4:	e92d0002 	stmfd	sp!, {r1}

    msr     cpsr_c, #SVC_MODE|NOIRQ        @进入SVC_MODE,以便允许中断嵌套
300003e8:	e321f093 	msr	CPSR_c, #147	; 0x93
    stmfd   sp!,    {lr}                  @保存SVc模式的专用寄存器lr
300003ec:	e92d4000 	stmfd	sp!, {lr}

    ldr     r0,     =INTOFFSET 		  @读取中断向量号
300003f0:	e59f008c 	ldr	r0, [pc, #140]	; 30000484 <HAL_INTR_DISABLE_SAVE+0x20>
    ldr     r0,     [r0]
300003f4:	e5900000 	ldr	r0, [r0]
    mov     lr,    pc                     @求得lr的值
300003f8:	e1a0e00f 	mov	lr, pc
    bl .    @//TODO ldr     pc,    =hal_all_entry 
300003fc:	ebfffffe 	bl	300003fc <HAL_INTR_ENTRY+0x20>

    ldmfd   sp!,    {lr}                    @恢复svc模式下的lr,
30000400:	e8bd4000 	ldmfd	sp!, {lr}
    msr     cpsr_c,#IRQ_MODE|NOINT       @更新cpsr,进入IRQ模式并禁止中断
30000404:	e321f0d2 	msr	CPSR_c, #210	; 0xd2
    ldmfd   sp!,{r0}                    @spsr->r0
30000408:	e8bd0001 	ldmfd	sp!, {r0}
    msr     spsr_cxsf,r0                @恢复spsr
3000040c:	e16ff000 	msr	SPSR_fsxc, r0
    ldmfd   sp!,{r0-r12,lr}
30000410:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    subs    pc,lr,#4                    @此后，中断被重新打开
30000414:	e25ef004 	subs	pc, lr, #4

30000418 <EXP_HANDLER>:

EXP_HANDLER:
	stmfd   sp!,{lr}                @保护寄存器,以及返回地址
30000418:	e92d4000 	stmfd	sp!, {lr}
	mov     r0,sp  
3000041c:	e1a0000d 	mov	r0, sp
	stmfd   r0!,{sp}^               @出错线程的SP_sys压入exp中断栈中
30000420:	e9602000 	stmdb	r0!, {sp}^
	ldmfd   r0!,{r1}                @从exp中断栈中读取 SP_sys->R1
30000424:	e8b00002 	ldm	r0!, {r1}
	mov     r0,lr
30000428:	e1a0000e 	mov	r0, lr
	bl .    @//TODO  bl acoral_fault_entry
3000042c:	ebfffffe 	bl	3000042c <EXP_HANDLER+0x14>
	ldmfd   sp!,{lr}                  @从exp中断栈中读取 SP_sys->R1
30000430:	e8bd4000 	ldmfd	sp!, {lr}
	subs pc,lr,#0
30000434:	e25ef000 	subs	pc, lr, #0

30000438 <HAL_INTR_ENABLE>:

HAL_INTR_ENABLE:
    mrs r0,cpsr
30000438:	e10f0000 	mrs	r0, CPSR
    bic r0,r0,#NOINT
3000043c:	e3c000c0 	bic	r0, r0, #192	; 0xc0
    msr cpsr_cxsf,r0
30000440:	e12ff000 	msr	CPSR_fsxc, r0
    mov pc,lr
30000444:	e1a0f00e 	mov	pc, lr

30000448 <HAL_INTR_DISABLE>:

HAL_INTR_DISABLE:
    mrs r0,cpsr
30000448:	e10f0000 	mrs	r0, CPSR
    mov r1,r0
3000044c:	e1a01000 	mov	r1, r0
    orr r1,r1,#NOINT
30000450:	e38110c0 	orr	r1, r1, #192	; 0xc0
    msr cpsr_cxsf,r1
30000454:	e12ff001 	msr	CPSR_fsxc, r1
    mov pc ,lr
30000458:	e1a0f00e 	mov	pc, lr

3000045c <HAL_INTR_RESTORE>:

HAL_INTR_RESTORE:
	MSR     CPSR_c, R0
3000045c:	e121f000 	msr	CPSR_c, r0
	MOV     PC, LR
30000460:	e1a0f00e 	mov	pc, lr

30000464 <HAL_INTR_DISABLE_SAVE>:

HAL_INTR_DISABLE_SAVE:
	MRS     R0, CPSR				@ Set IRQ and FIable all interrupts
30000464:	e10f0000 	mrs	r0, CPSR
	ORR     R1, R0, #0xC0
30000468:	e38010c0 	orr	r1, r0, #192	; 0xc0
	MSR     CPSR_c, R1
3000046c:	e121f001 	msr	CPSR_c, r1
	MRS     R1, CPSR				@ Confirm that Cpt disable flags
30000470:	e10f1000 	mrs	r1, CPSR
	AND     R1, R1, #0xC0
30000474:	e20110c0 	and	r1, r1, #192	; 0xc0
	CMP     R1, #0xC0
30000478:	e35100c0 	cmp	r1, #192	; 0xc0
	BNE     HAL_INTR_DISABLE_SAVE			@ Not properly dsabled (try again)
3000047c:	1afffff8 	bne	30000464 <HAL_INTR_DISABLE_SAVE>
	MOV     PC, LR					@ Disabled, return thcontents in R0
30000480:	e1a0f00e 	mov	pc, lr
    ldr     r0,     =INTOFFSET 		  @读取中断向量号
30000484:	4a000014 	.word	0x4a000014

30000488 <nand_wait>:

void nand_init(void);
int nand_read(unsigned char *buf, unsigned long start_addr, int size);

static void nand_wait(void)
{
30000488:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
3000048c:	e28db000 	add	fp, sp, #0
30000490:	e24dd00c 	sub	sp, sp, #12
  int i;
  while (!(NFSTAT & NFSTAT_BUSY))
30000494:	ea000008 	b	300004bc <nand_wait+0x34>
   for (i=0; i<10; i++);
30000498:	e3a03000 	mov	r3, #0
3000049c:	e50b3008 	str	r3, [fp, #-8]
300004a0:	ea000002 	b	300004b0 <nand_wait+0x28>
300004a4:	e51b3008 	ldr	r3, [fp, #-8]
300004a8:	e2833001 	add	r3, r3, #1
300004ac:	e50b3008 	str	r3, [fp, #-8]
300004b0:	e51b3008 	ldr	r3, [fp, #-8]
300004b4:	e3530009 	cmp	r3, #9
300004b8:	dafffff9 	ble	300004a4 <nand_wait+0x1c>
  while (!(NFSTAT & NFSTAT_BUSY))
300004bc:	e59f3020 	ldr	r3, [pc, #32]	; 300004e4 <nand_wait+0x5c>
300004c0:	e5d33000 	ldrb	r3, [r3]
300004c4:	e20330ff 	and	r3, r3, #255	; 0xff
300004c8:	e2033004 	and	r3, r3, #4
300004cc:	e3530000 	cmp	r3, #0
300004d0:	0afffff0 	beq	30000498 <nand_wait+0x10>
}
300004d4:	e1a00000 	nop			; (mov r0, r0)
300004d8:	e28bd000 	add	sp, fp, #0
300004dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
300004e0:	e12fff1e 	bx	lr
300004e4:	4e000020 	.word	0x4e000020

300004e8 <nand_reset>:


static void nand_reset(){
300004e8:	e92d4800 	push	{fp, lr}
300004ec:	e28db004 	add	fp, sp, #4
300004f0:	e24dd008 	sub	sp, sp, #8
   int i;

   nand_select();
300004f4:	e59f3064 	ldr	r3, [pc, #100]	; 30000560 <nand_reset+0x78>
300004f8:	e5933000 	ldr	r3, [r3]
300004fc:	e59f205c 	ldr	r2, [pc, #92]	; 30000560 <nand_reset+0x78>
30000500:	e3c33002 	bic	r3, r3, #2
30000504:	e5823000 	str	r3, [r2]
   NFCMD=NAND_CMD_RESET;
30000508:	e59f3054 	ldr	r3, [pc, #84]	; 30000564 <nand_reset+0x7c>
3000050c:	e3e02000 	mvn	r2, #0
30000510:	e5c32000 	strb	r2, [r3]
   for(i=0;i<10;i++);  
30000514:	e3a03000 	mov	r3, #0
30000518:	e50b3008 	str	r3, [fp, #-8]
3000051c:	ea000002 	b	3000052c <nand_reset+0x44>
30000520:	e51b3008 	ldr	r3, [fp, #-8]
30000524:	e2833001 	add	r3, r3, #1
30000528:	e50b3008 	str	r3, [fp, #-8]
3000052c:	e51b3008 	ldr	r3, [fp, #-8]
30000530:	e3530009 	cmp	r3, #9
30000534:	dafffff9 	ble	30000520 <nand_reset+0x38>
   nand_wait();  
30000538:	ebffffd2 	bl	30000488 <nand_wait>
   nand_deselect();
3000053c:	e59f301c 	ldr	r3, [pc, #28]	; 30000560 <nand_reset+0x78>
30000540:	e5933000 	ldr	r3, [r3]
30000544:	e59f2014 	ldr	r2, [pc, #20]	; 30000560 <nand_reset+0x78>
30000548:	e3833002 	orr	r3, r3, #2
3000054c:	e5823000 	str	r3, [r2]
}
30000550:	e1a00000 	nop			; (mov r0, r0)
30000554:	e24bd004 	sub	sp, fp, #4
30000558:	e8bd4800 	pop	{fp, lr}
3000055c:	e12fff1e 	bx	lr
30000560:	4e000004 	.word	0x4e000004
30000564:	4e000008 	.word	0x4e000008

30000568 <nand_init>:


void nand_init(void){
30000568:	e92d4800 	push	{fp, lr}
3000056c:	e28db004 	add	fp, sp, #4
   

    NFCONF=(7<<12)|(7<<8)|(7<<4)|(0<<0);
30000570:	e3a0344e 	mov	r3, #1308622848	; 0x4e000000
30000574:	e59f2020 	ldr	r2, [pc, #32]	; 3000059c <nand_init+0x34>
30000578:	e5832000 	str	r2, [r3]
    NFCONT=(1<<4)|(0<<1)|(1<<0);
3000057c:	e59f301c 	ldr	r3, [pc, #28]	; 300005a0 <nand_init+0x38>
30000580:	e3a02011 	mov	r2, #17
30000584:	e5832000 	str	r2, [r3]
    
    nand_reset();
30000588:	ebffffd6 	bl	300004e8 <nand_reset>
}
3000058c:	e1a00000 	nop			; (mov r0, r0)
30000590:	e24bd004 	sub	sp, fp, #4
30000594:	e8bd4800 	pop	{fp, lr}
30000598:	e12fff1e 	bx	lr
3000059c:	00007770 	.word	0x00007770
300005a0:	4e000004 	.word	0x4e000004

300005a4 <is_bad_block>:
    int bad_block_offset;
};


static int is_bad_block(struct boot_nand_t * nand, unsigned long i)
{
300005a4:	e92d4800 	push	{fp, lr}
300005a8:	e28db004 	add	fp, sp, #4
300005ac:	e24dd010 	sub	sp, sp, #16
300005b0:	e50b0010 	str	r0, [fp, #-16]
300005b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
	unsigned char data;
	unsigned long page_num;

	nand_clear_RnB();
300005b8:	e59f3168 	ldr	r3, [pc, #360]	; 30000728 <is_bad_block+0x184>
300005bc:	e5d33000 	ldrb	r3, [r3]
300005c0:	e20330ff 	and	r3, r3, #255	; 0xff
300005c4:	e59f215c 	ldr	r2, [pc, #348]	; 30000728 <is_bad_block+0x184>
300005c8:	e3833004 	orr	r3, r3, #4
300005cc:	e20330ff 	and	r3, r3, #255	; 0xff
300005d0:	e5c23000 	strb	r3, [r2]
	if (nand->page_size == 512) {
300005d4:	e51b3010 	ldr	r3, [fp, #-16]
300005d8:	e5933000 	ldr	r3, [r3]
300005dc:	e3530c02 	cmp	r3, #512	; 0x200
300005e0:	1a000019 	bne	3000064c <is_bad_block+0xa8>
		NFCMD = NAND_CMD_READOOB; /* 0x50 */
300005e4:	e59f3140 	ldr	r3, [pc, #320]	; 3000072c <is_bad_block+0x188>
300005e8:	e3a02050 	mov	r2, #80	; 0x50
300005ec:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xf;
300005f0:	e51b3010 	ldr	r3, [fp, #-16]
300005f4:	e5933008 	ldr	r3, [r3, #8]
300005f8:	e20330ff 	and	r3, r3, #255	; 0xff
300005fc:	e59f212c 	ldr	r2, [pc, #300]	; 30000730 <is_bad_block+0x18c>
30000600:	e203300f 	and	r3, r3, #15
30000604:	e20330ff 	and	r3, r3, #255	; 0xff
30000608:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 9) & 0xff;
3000060c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
30000610:	e1a034a3 	lsr	r3, r3, #9
30000614:	e59f2114 	ldr	r2, [pc, #276]	; 30000730 <is_bad_block+0x18c>
30000618:	e20330ff 	and	r3, r3, #255	; 0xff
3000061c:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 17) & 0xff;
30000620:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
30000624:	e1a038a3 	lsr	r3, r3, #17
30000628:	e59f2100 	ldr	r2, [pc, #256]	; 30000730 <is_bad_block+0x18c>
3000062c:	e20330ff 	and	r3, r3, #255	; 0xff
30000630:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 25) & 0xff;
30000634:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
30000638:	e1a03ca3 	lsr	r3, r3, #25
3000063c:	e59f20ec 	ldr	r2, [pc, #236]	; 30000730 <is_bad_block+0x18c>
30000640:	e20330ff 	and	r3, r3, #255	; 0xff
30000644:	e5c23000 	strb	r3, [r2]
30000648:	ea000028 	b	300006f0 <is_bad_block+0x14c>
	} else if (nand->page_size == 2048) {
3000064c:	e51b3010 	ldr	r3, [fp, #-16]
30000650:	e5933000 	ldr	r3, [r3]
30000654:	e3530b02 	cmp	r3, #2048	; 0x800
30000658:	1a000022 	bne	300006e8 <is_bad_block+0x144>
		page_num = i >> 11; /* addr / 2048 */
3000065c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
30000660:	e1a035a3 	lsr	r3, r3, #11
30000664:	e50b3008 	str	r3, [fp, #-8]
		NFCMD = NAND_CMD_READ0;
30000668:	e59f30bc 	ldr	r3, [pc, #188]	; 3000072c <is_bad_block+0x188>
3000066c:	e3a02000 	mov	r2, #0
30000670:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xff;
30000674:	e51b3010 	ldr	r3, [fp, #-16]
30000678:	e5933008 	ldr	r3, [r3, #8]
3000067c:	e59f20ac 	ldr	r2, [pc, #172]	; 30000730 <is_bad_block+0x18c>
30000680:	e20330ff 	and	r3, r3, #255	; 0xff
30000684:	e5c23000 	strb	r3, [r2]
		NFADDR = (nand->bad_block_offset >> 8) & 0xff;
30000688:	e51b3010 	ldr	r3, [fp, #-16]
3000068c:	e5933008 	ldr	r3, [r3, #8]
30000690:	e1a03443 	asr	r3, r3, #8
30000694:	e59f2094 	ldr	r2, [pc, #148]	; 30000730 <is_bad_block+0x18c>
30000698:	e20330ff 	and	r3, r3, #255	; 0xff
3000069c:	e5c23000 	strb	r3, [r2]
		NFADDR = page_num & 0xff;
300006a0:	e59f2088 	ldr	r2, [pc, #136]	; 30000730 <is_bad_block+0x18c>
300006a4:	e51b3008 	ldr	r3, [fp, #-8]
300006a8:	e20330ff 	and	r3, r3, #255	; 0xff
300006ac:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
300006b0:	e51b3008 	ldr	r3, [fp, #-8]
300006b4:	e1a03423 	lsr	r3, r3, #8
300006b8:	e59f2070 	ldr	r2, [pc, #112]	; 30000730 <is_bad_block+0x18c>
300006bc:	e20330ff 	and	r3, r3, #255	; 0xff
300006c0:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
300006c4:	e51b3008 	ldr	r3, [fp, #-8]
300006c8:	e1a03823 	lsr	r3, r3, #16
300006cc:	e59f205c 	ldr	r2, [pc, #92]	; 30000730 <is_bad_block+0x18c>
300006d0:	e20330ff 	and	r3, r3, #255	; 0xff
300006d4:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
300006d8:	e59f304c 	ldr	r3, [pc, #76]	; 3000072c <is_bad_block+0x188>
300006dc:	e3a02030 	mov	r2, #48	; 0x30
300006e0:	e5c32000 	strb	r2, [r3]
300006e4:	ea000001 	b	300006f0 <is_bad_block+0x14c>
	} else {
		return -1;
300006e8:	e3e03000 	mvn	r3, #0
300006ec:	ea000009 	b	30000718 <is_bad_block+0x174>
	}
	nand_wait();
300006f0:	ebffff64 	bl	30000488 <nand_wait>
	data = (NFDATA & 0xff);
300006f4:	e59f3038 	ldr	r3, [pc, #56]	; 30000734 <is_bad_block+0x190>
300006f8:	e5d33000 	ldrb	r3, [r3]
300006fc:	e54b3009 	strb	r3, [fp, #-9]
	if (data != 0xff)
30000700:	e55b3009 	ldrb	r3, [fp, #-9]
30000704:	e35300ff 	cmp	r3, #255	; 0xff
30000708:	0a000001 	beq	30000714 <is_bad_block+0x170>
		return 1;
3000070c:	e3a03001 	mov	r3, #1
30000710:	ea000000 	b	30000718 <is_bad_block+0x174>

	return 0;
30000714:	e3a03000 	mov	r3, #0
}
30000718:	e1a00003 	mov	r0, r3
3000071c:	e24bd004 	sub	sp, fp, #4
30000720:	e8bd4800 	pop	{fp, lr}
30000724:	e12fff1e 	bx	lr
30000728:	4e000020 	.word	0x4e000020
3000072c:	4e000008 	.word	0x4e000008
30000730:	4e00000c 	.word	0x4e00000c
30000734:	4e000010 	.word	0x4e000010

30000738 <nand_read_page>:

static int nand_read_page(struct boot_nand_t * nand, unsigned char *buf, unsigned long addr)
{
30000738:	e92d4800 	push	{fp, lr}
3000073c:	e28db004 	add	fp, sp, #4
30000740:	e24dd020 	sub	sp, sp, #32
30000744:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
30000748:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
3000074c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
	unsigned short *ptr16 = (unsigned short *)buf;
30000750:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
30000754:	e50b3008 	str	r3, [fp, #-8]
	unsigned int i, page_num;

	nand_clear_RnB();
30000758:	e59f3178 	ldr	r3, [pc, #376]	; 300008d8 <nand_read_page+0x1a0>
3000075c:	e5d33000 	ldrb	r3, [r3]
30000760:	e20330ff 	and	r3, r3, #255	; 0xff
30000764:	e59f216c 	ldr	r2, [pc, #364]	; 300008d8 <nand_read_page+0x1a0>
30000768:	e3833004 	orr	r3, r3, #4
3000076c:	e20330ff 	and	r3, r3, #255	; 0xff
30000770:	e5c23000 	strb	r3, [r2]

	NFCMD = NAND_CMD_READ0;
30000774:	e59f3160 	ldr	r3, [pc, #352]	; 300008dc <nand_read_page+0x1a4>
30000778:	e3a02000 	mov	r2, #0
3000077c:	e5c32000 	strb	r2, [r3]

	if (nand->page_size == 512) {
30000780:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
30000784:	e5933000 	ldr	r3, [r3]
30000788:	e3530c02 	cmp	r3, #512	; 0x200
3000078c:	1a000013 	bne	300007e0 <nand_read_page+0xa8>
		/* Write Address */
		NFADDR = addr & 0xff;
30000790:	e59f2148 	ldr	r2, [pc, #328]	; 300008e0 <nand_read_page+0x1a8>
30000794:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
30000798:	e20330ff 	and	r3, r3, #255	; 0xff
3000079c:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 9) & 0xff;
300007a0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
300007a4:	e1a034a3 	lsr	r3, r3, #9
300007a8:	e59f2130 	ldr	r2, [pc, #304]	; 300008e0 <nand_read_page+0x1a8>
300007ac:	e20330ff 	and	r3, r3, #255	; 0xff
300007b0:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 17) & 0xff;
300007b4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
300007b8:	e1a038a3 	lsr	r3, r3, #17
300007bc:	e59f211c 	ldr	r2, [pc, #284]	; 300008e0 <nand_read_page+0x1a8>
300007c0:	e20330ff 	and	r3, r3, #255	; 0xff
300007c4:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 25) & 0xff;
300007c8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
300007cc:	e1a03ca3 	lsr	r3, r3, #25
300007d0:	e59f2108 	ldr	r2, [pc, #264]	; 300008e0 <nand_read_page+0x1a8>
300007d4:	e20330ff 	and	r3, r3, #255	; 0xff
300007d8:	e5c23000 	strb	r3, [r2]
300007dc:	ea000020 	b	30000864 <nand_read_page+0x12c>
	} else if (nand->page_size == 2048) {
300007e0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
300007e4:	e5933000 	ldr	r3, [r3]
300007e8:	e3530b02 	cmp	r3, #2048	; 0x800
300007ec:	1a00001a 	bne	3000085c <nand_read_page+0x124>
		page_num = addr >> 11; /* addr / 2048 */
300007f0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
300007f4:	e1a035a3 	lsr	r3, r3, #11
300007f8:	e50b3010 	str	r3, [fp, #-16]
		/* Write Address */
		NFADDR = 0;
300007fc:	e59f30dc 	ldr	r3, [pc, #220]	; 300008e0 <nand_read_page+0x1a8>
30000800:	e3a02000 	mov	r2, #0
30000804:	e5c32000 	strb	r2, [r3]
		NFADDR = 0;
30000808:	e59f30d0 	ldr	r3, [pc, #208]	; 300008e0 <nand_read_page+0x1a8>
3000080c:	e3a02000 	mov	r2, #0
30000810:	e5c32000 	strb	r2, [r3]
		NFADDR = page_num & 0xff;
30000814:	e59f20c4 	ldr	r2, [pc, #196]	; 300008e0 <nand_read_page+0x1a8>
30000818:	e51b3010 	ldr	r3, [fp, #-16]
3000081c:	e20330ff 	and	r3, r3, #255	; 0xff
30000820:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
30000824:	e51b3010 	ldr	r3, [fp, #-16]
30000828:	e1a03423 	lsr	r3, r3, #8
3000082c:	e59f20ac 	ldr	r2, [pc, #172]	; 300008e0 <nand_read_page+0x1a8>
30000830:	e20330ff 	and	r3, r3, #255	; 0xff
30000834:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
30000838:	e51b3010 	ldr	r3, [fp, #-16]
3000083c:	e1a03823 	lsr	r3, r3, #16
30000840:	e59f2098 	ldr	r2, [pc, #152]	; 300008e0 <nand_read_page+0x1a8>
30000844:	e20330ff 	and	r3, r3, #255	; 0xff
30000848:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
3000084c:	e59f3088 	ldr	r3, [pc, #136]	; 300008dc <nand_read_page+0x1a4>
30000850:	e3a02030 	mov	r2, #48	; 0x30
30000854:	e5c32000 	strb	r2, [r3]
30000858:	ea000001 	b	30000864 <nand_read_page+0x12c>
	} else {
		return -1;
3000085c:	e3e03000 	mvn	r3, #0
30000860:	ea000018 	b	300008c8 <nand_read_page+0x190>
	}
	nand_wait();
30000864:	ebffff07 	bl	30000488 <nand_wait>
	for (i = 0; i < (nand->page_size>>1); i++) {
30000868:	e3a03000 	mov	r3, #0
3000086c:	e50b300c 	str	r3, [fp, #-12]
30000870:	ea00000b 	b	300008a4 <nand_read_page+0x16c>
		*ptr16 = NFDATA16;
30000874:	e59f3068 	ldr	r3, [pc, #104]	; 300008e4 <nand_read_page+0x1ac>
30000878:	e1d330b0 	ldrh	r3, [r3]
3000087c:	e1a03803 	lsl	r3, r3, #16
30000880:	e1a02823 	lsr	r2, r3, #16
30000884:	e51b3008 	ldr	r3, [fp, #-8]
30000888:	e1c320b0 	strh	r2, [r3]
		ptr16++;
3000088c:	e51b3008 	ldr	r3, [fp, #-8]
30000890:	e2833002 	add	r3, r3, #2
30000894:	e50b3008 	str	r3, [fp, #-8]
	for (i = 0; i < (nand->page_size>>1); i++) {
30000898:	e51b300c 	ldr	r3, [fp, #-12]
3000089c:	e2833001 	add	r3, r3, #1
300008a0:	e50b300c 	str	r3, [fp, #-12]
300008a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
300008a8:	e5933000 	ldr	r3, [r3]
300008ac:	e1a030c3 	asr	r3, r3, #1
300008b0:	e1a02003 	mov	r2, r3
300008b4:	e51b300c 	ldr	r3, [fp, #-12]
300008b8:	e1530002 	cmp	r3, r2
300008bc:	3affffec 	bcc	30000874 <nand_read_page+0x13c>
	}

	return nand->page_size;
300008c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
300008c4:	e5933000 	ldr	r3, [r3]
}
300008c8:	e1a00003 	mov	r0, r3
300008cc:	e24bd004 	sub	sp, fp, #4
300008d0:	e8bd4800 	pop	{fp, lr}
300008d4:	e12fff1e 	bx	lr
300008d8:	4e000020 	.word	0x4e000020
300008dc:	4e000008 	.word	0x4e000008
300008e0:	4e00000c 	.word	0x4e00000c
300008e4:	4e000010 	.word	0x4e000010

300008e8 <nand_read_id>:


static unsigned short nand_read_id()
{
300008e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
300008ec:	e28db000 	add	fp, sp, #0
300008f0:	e24dd00c 	sub	sp, sp, #12
	unsigned short res = 0;
300008f4:	e3a03000 	mov	r3, #0
300008f8:	e14b30b6 	strh	r3, [fp, #-6]
	NFCMD = NAND_CMD_READID;
300008fc:	e59f3068 	ldr	r3, [pc, #104]	; 3000096c <nand_read_id+0x84>
30000900:	e3e0206f 	mvn	r2, #111	; 0x6f
30000904:	e5c32000 	strb	r2, [r3]
	NFADDR = 0;
30000908:	e59f3060 	ldr	r3, [pc, #96]	; 30000970 <nand_read_id+0x88>
3000090c:	e3a02000 	mov	r2, #0
30000910:	e5c32000 	strb	r2, [r3]
	res = NFDATA;
30000914:	e59f3058 	ldr	r3, [pc, #88]	; 30000974 <nand_read_id+0x8c>
30000918:	e5d33000 	ldrb	r3, [r3]
3000091c:	e20330ff 	and	r3, r3, #255	; 0xff
30000920:	e14b30b6 	strh	r3, [fp, #-6]
	res = (res << 8) | NFDATA;
30000924:	e15b30b6 	ldrh	r3, [fp, #-6]
30000928:	e1a03403 	lsl	r3, r3, #8
3000092c:	e1a03803 	lsl	r3, r3, #16
30000930:	e1a02843 	asr	r2, r3, #16
30000934:	e59f3038 	ldr	r3, [pc, #56]	; 30000974 <nand_read_id+0x8c>
30000938:	e5d33000 	ldrb	r3, [r3]
3000093c:	e20330ff 	and	r3, r3, #255	; 0xff
30000940:	e1a03803 	lsl	r3, r3, #16
30000944:	e1a03843 	asr	r3, r3, #16
30000948:	e1823003 	orr	r3, r2, r3
3000094c:	e1a03803 	lsl	r3, r3, #16
30000950:	e1a03843 	asr	r3, r3, #16
30000954:	e14b30b6 	strh	r3, [fp, #-6]
	return res;
30000958:	e15b30b6 	ldrh	r3, [fp, #-6]
}
3000095c:	e1a00003 	mov	r0, r3
30000960:	e28bd000 	add	sp, fp, #0
30000964:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
30000968:	e12fff1e 	bx	lr
3000096c:	4e000008 	.word	0x4e000008
30000970:	4e00000c 	.word	0x4e00000c
30000974:	4e000010 	.word	0x4e000010

30000978 <nand_read>:



int nand_read(unsigned char *buf, unsigned long start_addr, int size)
{
30000978:	e92d4800 	push	{fp, lr}
3000097c:	e28db004 	add	fp, sp, #4
30000980:	e24dd028 	sub	sp, sp, #40	; 0x28
30000984:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
30000988:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
3000098c:	e50b2028 	str	r2, [fp, #-40]	; 0xffffffd8
	int i, j;
	unsigned short nand_id;
	struct boot_nand_t nand;

	
	nand_select();
30000990:	e59f3270 	ldr	r3, [pc, #624]	; 30000c08 <nand_read+0x290>
30000994:	e5933000 	ldr	r3, [r3]
30000998:	e59f2268 	ldr	r2, [pc, #616]	; 30000c08 <nand_read+0x290>
3000099c:	e3c33002 	bic	r3, r3, #2
300009a0:	e5823000 	str	r3, [r2]
	nand_clear_RnB();
300009a4:	e59f3260 	ldr	r3, [pc, #608]	; 30000c0c <nand_read+0x294>
300009a8:	e5d33000 	ldrb	r3, [r3]
300009ac:	e20330ff 	and	r3, r3, #255	; 0xff
300009b0:	e59f2254 	ldr	r2, [pc, #596]	; 30000c0c <nand_read+0x294>
300009b4:	e3833004 	orr	r3, r3, #4
300009b8:	e20330ff 	and	r3, r3, #255	; 0xff
300009bc:	e5c23000 	strb	r3, [r2]
	
	for (i = 0; i < 10; i++);
300009c0:	e3a03000 	mov	r3, #0
300009c4:	e50b3008 	str	r3, [fp, #-8]
300009c8:	ea000002 	b	300009d8 <nand_read+0x60>
300009cc:	e51b3008 	ldr	r3, [fp, #-8]
300009d0:	e2833001 	add	r3, r3, #1
300009d4:	e50b3008 	str	r3, [fp, #-8]
300009d8:	e51b3008 	ldr	r3, [fp, #-8]
300009dc:	e3530009 	cmp	r3, #9
300009e0:	dafffff9 	ble	300009cc <nand_read+0x54>

	nand_id = nand_read_id();	
300009e4:	ebffffbf 	bl	300008e8 <nand_read_id>
300009e8:	e1a03000 	mov	r3, r0
300009ec:	e14b30ba 	strh	r3, [fp, #-10]

       if (nand_id == 0xec76 ||		/* Samsung K91208 */
300009f0:	e15b30ba 	ldrh	r3, [fp, #-10]
300009f4:	e59f2214 	ldr	r2, [pc, #532]	; 30000c10 <nand_read+0x298>
300009f8:	e1530002 	cmp	r3, r2
300009fc:	0a000003 	beq	30000a10 <nand_read+0x98>
30000a00:	e15b30ba 	ldrh	r3, [fp, #-10]
30000a04:	e59f2208 	ldr	r2, [pc, #520]	; 30000c14 <nand_read+0x29c>
30000a08:	e1530002 	cmp	r3, r2
30000a0c:	1a000006 	bne	30000a2c <nand_read+0xb4>
           nand_id == 0xad76 ) {	/*Hynix HY27US08121A*/
		nand.page_size = 512;
30000a10:	e3a03c02 	mov	r3, #512	; 0x200
30000a14:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 16 * 1024;
30000a18:	e3a03901 	mov	r3, #16384	; 0x4000
30000a1c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = 5;
30000a20:	e3a03005 	mov	r3, #5
30000a24:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
30000a28:	ea000014 	b	30000a80 <nand_read+0x108>
	} 
        else if (nand_id == 0xecf1 ||	/* Samsung K9F1G08U0B */
30000a2c:	e15b30ba 	ldrh	r3, [fp, #-10]
30000a30:	e59f21e0 	ldr	r2, [pc, #480]	; 30000c18 <nand_read+0x2a0>
30000a34:	e1530002 	cmp	r3, r2
30000a38:	0a000007 	beq	30000a5c <nand_read+0xe4>
30000a3c:	e15b30ba 	ldrh	r3, [fp, #-10]
30000a40:	e59f21d4 	ldr	r2, [pc, #468]	; 30000c1c <nand_read+0x2a4>
30000a44:	e1530002 	cmp	r3, r2
30000a48:	0a000003 	beq	30000a5c <nand_read+0xe4>
		   nand_id == 0xecda ||	/* Samsung K9F2G08U0B */
30000a4c:	e15b30ba 	ldrh	r3, [fp, #-10]
30000a50:	e59f21c8 	ldr	r2, [pc, #456]	; 30000c20 <nand_read+0x2a8>
30000a54:	e1530002 	cmp	r3, r2
30000a58:	1a000006 	bne	30000a78 <nand_read+0x100>
		   nand_id == 0xecd3 )	{ /* Samsung K9K8G08 */
		nand.page_size = 2048;
30000a5c:	e3a03b02 	mov	r3, #2048	; 0x800
30000a60:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 128 * 1024;
30000a64:	e3a03802 	mov	r3, #131072	; 0x20000
30000a68:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = nand.page_size;
30000a6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
30000a70:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
30000a74:	ea000001 	b	30000a80 <nand_read+0x108>
	} 
        else {
		return -1; 
30000a78:	e3e03000 	mvn	r3, #0
30000a7c:	ea00005d 	b	30000bf8 <nand_read+0x280>
	}

         if ((start_addr & (nand.block_size-1)))
30000a80:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
30000a84:	e2433001 	sub	r3, r3, #1
30000a88:	e1a02003 	mov	r2, r3
30000a8c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
30000a90:	e0033002 	and	r3, r3, r2
30000a94:	e3530000 	cmp	r3, #0
30000a98:	0a000001 	beq	30000aa4 <nand_read+0x12c>
		return -1;	
30000a9c:	e3e03000 	mvn	r3, #0
30000aa0:	ea000054 	b	30000bf8 <nand_read+0x280>
        
        if(size & (nand.page_size-1)){
30000aa4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
30000aa8:	e2432001 	sub	r2, r3, #1
30000aac:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
30000ab0:	e0033002 	and	r3, r3, r2
30000ab4:	e3530000 	cmp	r3, #0
30000ab8:	0a000007 	beq	30000adc <nand_read+0x164>
             size=(size+nand.page_size-1) & (~(nand.page_size-1));
30000abc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
30000ac0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
30000ac4:	e0823003 	add	r3, r2, r3
30000ac8:	e2432001 	sub	r2, r3, #1
30000acc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
30000ad0:	e2633000 	rsb	r3, r3, #0
30000ad4:	e0033002 	and	r3, r3, r2
30000ad8:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
        }

        if ((size & (nand.page_size-1)))
30000adc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
30000ae0:	e2432001 	sub	r2, r3, #1
30000ae4:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
30000ae8:	e0033002 	and	r3, r3, r2
30000aec:	e3530000 	cmp	r3, #0
30000af0:	0a000001 	beq	30000afc <nand_read+0x184>
		return -1;
30000af4:	e3e03000 	mvn	r3, #0
30000af8:	ea00003e 	b	30000bf8 <nand_read+0x280>

	for (i=start_addr; i < (start_addr + size);) {
30000afc:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
30000b00:	e50b3008 	str	r3, [fp, #-8]
30000b04:	ea00002f 	b	30000bc8 <nand_read+0x250>

		if ((i & (nand.block_size-1))== 0) {
30000b08:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
30000b0c:	e2432001 	sub	r2, r3, #1
30000b10:	e51b3008 	ldr	r3, [fp, #-8]
30000b14:	e0033002 	and	r3, r3, r2
30000b18:	e3530000 	cmp	r3, #0
30000b1c:	1a00001b 	bne	30000b90 <nand_read+0x218>
			if (is_bad_block(&nand, i) || is_bad_block(&nand, i + nand.page_size)) {
30000b20:	e51b2008 	ldr	r2, [fp, #-8]
30000b24:	e24b301c 	sub	r3, fp, #28
30000b28:	e1a01002 	mov	r1, r2
30000b2c:	e1a00003 	mov	r0, r3
30000b30:	ebfffe9b 	bl	300005a4 <is_bad_block>
30000b34:	e1a03000 	mov	r3, r0
30000b38:	e3530000 	cmp	r3, #0
30000b3c:	1a00000a 	bne	30000b6c <nand_read+0x1f4>
30000b40:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
30000b44:	e51b3008 	ldr	r3, [fp, #-8]
30000b48:	e0823003 	add	r3, r2, r3
30000b4c:	e1a02003 	mov	r2, r3
30000b50:	e24b301c 	sub	r3, fp, #28
30000b54:	e1a01002 	mov	r1, r2
30000b58:	e1a00003 	mov	r0, r3
30000b5c:	ebfffe90 	bl	300005a4 <is_bad_block>
30000b60:	e1a03000 	mov	r3, r0
30000b64:	e3530000 	cmp	r3, #0
30000b68:	0a000008 	beq	30000b90 <nand_read+0x218>
				i += nand.block_size;
30000b6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
30000b70:	e51b2008 	ldr	r2, [fp, #-8]
30000b74:	e0823003 	add	r3, r2, r3
30000b78:	e50b3008 	str	r3, [fp, #-8]
				size += nand.block_size;
30000b7c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
30000b80:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
30000b84:	e0823003 	add	r3, r2, r3
30000b88:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
				continue;
30000b8c:	ea00000d 	b	30000bc8 <nand_read+0x250>
			}
		}

		j = nand_read_page(&nand, buf, i);
30000b90:	e51b2008 	ldr	r2, [fp, #-8]
30000b94:	e24b301c 	sub	r3, fp, #28
30000b98:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
30000b9c:	e1a00003 	mov	r0, r3
30000ba0:	ebfffee4 	bl	30000738 <nand_read_page>
30000ba4:	e50b0010 	str	r0, [fp, #-16]
		i += j;
30000ba8:	e51b2008 	ldr	r2, [fp, #-8]
30000bac:	e51b3010 	ldr	r3, [fp, #-16]
30000bb0:	e0823003 	add	r3, r2, r3
30000bb4:	e50b3008 	str	r3, [fp, #-8]
		buf += j;
30000bb8:	e51b3010 	ldr	r3, [fp, #-16]
30000bbc:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
30000bc0:	e0823003 	add	r3, r2, r3
30000bc4:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
	for (i=start_addr; i < (start_addr + size);) {
30000bc8:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
30000bcc:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
30000bd0:	e0822003 	add	r2, r2, r3
30000bd4:	e51b3008 	ldr	r3, [fp, #-8]
30000bd8:	e1520003 	cmp	r2, r3
30000bdc:	8affffc9 	bhi	30000b08 <nand_read+0x190>
	}


	nand_deselect();
30000be0:	e59f3020 	ldr	r3, [pc, #32]	; 30000c08 <nand_read+0x290>
30000be4:	e5933000 	ldr	r3, [r3]
30000be8:	e59f2018 	ldr	r2, [pc, #24]	; 30000c08 <nand_read+0x290>
30000bec:	e3833002 	orr	r3, r3, #2
30000bf0:	e5823000 	str	r3, [r2]

	return 0;
30000bf4:	e3a03000 	mov	r3, #0
}
30000bf8:	e1a00003 	mov	r0, r3
30000bfc:	e24bd004 	sub	sp, fp, #4
30000c00:	e8bd4800 	pop	{fp, lr}
30000c04:	e12fff1e 	bx	lr
30000c08:	4e000004 	.word	0x4e000004
30000c0c:	4e000020 	.word	0x4e000020
30000c10:	0000ec76 	.word	0x0000ec76
30000c14:	0000ad76 	.word	0x0000ad76
30000c18:	0000ecf1 	.word	0x0000ecf1
30000c1c:	0000ecda 	.word	0x0000ecda
30000c20:	0000ecd3 	.word	0x0000ecd3
