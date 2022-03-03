
acoral.elf:     file format elf32-littlearm


Disassembly of section .init:

00000000 <__ENTRY>:

	.global __ENTRY
	.global HandleIRQ

__ENTRY:
	b	ResetHandler
   0:	ea000017 	b	64 <ResetHandler>
	b	HandleUndef		@handler for Undefined mode
   4:	ea00000d 	b	40 <HandleUndef>
	b	HandleSWI       @handler for SWI interrupt
   8:	ea00000d 	b	44 <HandleSWI>
	b	HandlePabort	@handler for PAbort
   c:	ea00000e 	b	4c <HandlePabort>
	b	HandleDabort	@handler for DAbort
  10:	ea00000c 	b	48 <HandleDabort>
	b   .				@reserved
  14:	eafffffe 	b	14 <__ENTRY+0x14>
	b   HandleIRQ 		@handler for IRQ interrupt
  18:	ea000007 	b	3c <HandleIRQ>
	b	HandleFIQ		@handler for FIQ interrupt
  1c:	ea000005 	b	38 <HandleFIQ>
	...
  2c:	00000988 	.word	0x00000988
  30:	00000000 	.word	0x00000000
@ 0x2C: this contains the platform, cpu and machine id
	.long   2440
@ 0x30:  capabilities
	.long   0
@ 0x34:
	b   	.
  34:	eafffffe 	b	34 <FIQ_stack_size+0x34>

00000038 <HandleFIQ>:
@****************************************************************
@ intvector setup
@****************************************************************

HandleFIQ:
	ldr pc,=acoral_start
  38:	e59ff254 	ldr	pc, [pc, #596]	; 294 <mem_cfg_val+0x34>

0000003c <HandleIRQ>:
HandleIRQ:
	ldr pc,=HAL_INTR_ENTRY
  3c:	e59ff254 	ldr	pc, [pc, #596]	; 298 <mem_cfg_val+0x38>

00000040 <HandleUndef>:
HandleUndef:
	ldr pc,=EXP_HANDLER
  40:	e59ff254 	ldr	pc, [pc, #596]	; 29c <mem_cfg_val+0x3c>

00000044 <HandleSWI>:
HandleSWI:
	ldr pc,=EXP_HANDLER
  44:	e59ff250 	ldr	pc, [pc, #592]	; 29c <mem_cfg_val+0x3c>

00000048 <HandleDabort>:
HandleDabort:
	ldr pc,=EXP_HANDLER
  48:	e59ff24c 	ldr	pc, [pc, #588]	; 29c <mem_cfg_val+0x3c>

0000004c <HandlePabort>:
HandlePabort:
	ldr pc,=EXP_HANDLER
  4c:	e59ff248 	ldr	pc, [pc, #584]	; 29c <mem_cfg_val+0x3c>

00000050 <_text_load_addr>:
  50:	00000a68 	.word	0x00000a68

00000054 <_text_start>:
  54:	30000a68 	.word	0x30000a68

00000058 <_bss_load_addr>:
  58:	00000c24 	.word	0x00000c24

0000005c <_bss_start>:
  5c:	30000c24 	.word	0x30000c24

00000060 <_bss_end>:
  60:	30000c24 	.word	0x30000c24

00000064 <ResetHandler>:
@****************************************************************
@             ResetHandler fuction
@****************************************************************
ResetHandler:
	@ disable watch dog timer
	mov	r1, #0x53000000
  64:	e3a01453 	mov	r1, #1392508928	; 0x53000000
	mov	r2, #0x0
  68:	e3a02000 	mov	r2, #0
	str	r2, [r1]
  6c:	e5812000 	str	r2, [r1]

	@ disable all interrupts
	mov	r1, #INT_CTL_BASE
  70:	e3a0144a 	mov	r1, #1241513984	; 0x4a000000
	mov	r2, #0xffffffff
  74:	e3e02000 	mvn	r2, #0
	str	r2, [r1, #oINTMSK]
  78:	e5812008 	str	r2, [r1, #8]
	ldr	r2, =0x7ff
  7c:	e59f221c 	ldr	r2, [pc, #540]	; 2a0 <mem_cfg_val+0x40>
	str	r2, [r1, #oINTSUBMSK]
  80:	e581201c 	str	r2, [r1, #28]

	@ initialise system clocks
	mov	r1, #CLK_CTL_BASE
  84:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mvn	r2, #0xff000000
  88:	e3e024ff 	mvn	r2, #-16777216	; 0xff000000
	str	r2, [r1, #oLOCKTIME]
  8c:	e5812000 	str	r2, [r1]

	mov	r1, #CLK_CTL_BASE
  90:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	mov	r2, #M_DIVN
  94:	e3a02005 	mov	r2, #5
	str	r2, [r1, #oCLKDIVN]
  98:	e5812014 	str	r2, [r1, #20]

	mrc	p15, 0, r1, c1, c0, 0	@ read ctrl register
  9c:	ee111f10 	mrc	15, 0, r1, cr1, cr0, {0}
	orr	r1, r1, #0xc0000000	@ Asynchronous
  a0:	e3811103 	orr	r1, r1, #-1073741824	; 0xc0000000
	mcr	p15, 0, r1, c1, c0, 0	@ write ctrl register
  a4:	ee011f10 	mcr	15, 0, r1, cr1, cr0, {0}

	mov	r1, #CLK_CTL_BASE
  a8:	e3a01313 	mov	r1, #1275068416	; 0x4c000000
	ldr 	r2, =vMPLLCON	        @ clock user set
  ac:	e59f21f0 	ldr	r2, [pc, #496]	; 2a4 <mem_cfg_val+0x44>
	str	r2, [r1, #oMPLLCON]
  b0:	e5812004 	str	r2, [r1, #4]

	bl	memsetup
  b4:	eb000059 	bl	220 <memsetup>
	ldr r0, [r1]  
	tst r0, #PMST_SMR  
	bne WakeupStart 
#endif
		
	bl      InitStacks
  b8:	eb00003f 	bl	1bc <InitStacks>

	adr  r0,__ENTRY
  bc:	e24f00c4 	sub	r0, pc, #196	; 0xc4
	ldr  r1,_text_load_addr
  c0:	e51f1078 	ldr	r1, [pc, #-120]	; 50 <_text_load_addr>
	cmp  r0,r1
  c4:	e1500001 	cmp	r0, r1
	blne copy_self  
  c8:	1b000004 	blne	e0 <copy_self>

	ldr  r0,_bss_start
  cc:	e51f0078 	ldr	r0, [pc, #-120]	; 5c <_bss_start>
	ldr  r1,_bss_end
  d0:	e51f1078 	ldr	r1, [pc, #-120]	; 60 <_bss_end>
	bl    mem_clear
  d4:	eb00005a 	bl	244 <mem_clear>
	ldr    pc,=acoral_start	
  d8:	e59ff1b4 	ldr	pc, [pc, #436]	; 294 <mem_cfg_val+0x34>
	b 	.
  dc:	eafffffe 	b	dc <ResetHandler+0x78>

000000e0 <copy_self>:

#endif
 
copy_self:

        ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )		/* address of Internal SRAM  0x4000002C*/
  e0:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	mov	r0, #0		
  e4:	e3a00000 	mov	r0, #0
	str	r0, [r1]
  e8:	e5810000 	str	r0, [r1]


	mov	r1, #0x2c		               /* address of men  0x0000002C*/
  ec:	e3a0102c 	mov	r1, #44	; 0x2c
	ldr	r0, [r1]
  f0:	e5910000 	ldr	r0, [r1]
	cmp	r0, #0
  f4:	e3500000 	cmp	r0, #0
	bne	copy_from_rom
  f8:	1a000003 	bne	10c <copy_from_rom>
        
        ldr	r0, =(2440)
  fc:	e59f01a4 	ldr	r0, [pc, #420]	; 2a8 <mem_cfg_val+0x48>
	ldr	r1, =( (4<<28)|(2<<4)|(3<<2) )
 100:	e3a011b1 	mov	r1, #1073741868	; 0x4000002c
	str	r0, [r1]
 104:	e5810000 	str	r0, [r1]
	b       copy_from_nand 
 108:	ea000007 	b	12c <copy_from_nand>

0000010c <copy_from_rom>:


	
copy_from_rom:
	mov   r0,   #0
 10c:	e3a00000 	mov	r0, #0
	ldr   r1,   =0x30000000
 110:	e3a01203 	mov	r1, #805306368	; 0x30000000
	ldr   r3,   _bss_start
 114:	e51f30c0 	ldr	r3, [pc, #-192]	; 5c <_bss_start>

00000118 <start_copy>:
start_copy:
	ldr   r2,   [r0],#4
 118:	e4902004 	ldr	r2, [r0], #4
	str   r2,   [r1],#4
 11c:	e4812004 	str	r2, [r1], #4
	cmp   r1,   r3
 120:	e1510003 	cmp	r1, r3
	blt   start_copy	
 124:	bafffffb 	blt	118 <start_copy>
	mov   pc,  lr
 128:	e1a0f00e 	mov	pc, lr

0000012c <copy_from_nand>:

copy_from_nand:
	stmfd   sp!, {lr}
 12c:	e92d4000 	stmfd	sp!, {lr}
	bl      nand_init
 130:	eb00009d 	bl	3ac <nand_init>
	ldr     r0,  _text_start
 134:	e51f00e8 	ldr	r0, [pc, #-232]	; 54 <_text_start>
	mov     r1,  #0
 138:	e3a01000 	mov	r1, #0
	ldr     r3,  _bss_start
 13c:	e51f30e8 	ldr	r3, [pc, #-232]	; 5c <_bss_start>
        sub     r2,  r3, r0
 140:	e0432000 	sub	r2, r3, r0

        bl      nand_read
 144:	eb00019c 	bl	7bc <nand_read>
        cmp	r0,  #0x0
 148:	e3500000 	cmp	r0, #0
	beq     ok_nand_read
 14c:	0a000007 	beq	170 <ok_nand_read>

00000150 <bad_nand_read>:


bad_nand_read:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
 150:	e59f0154 	ldr	r0, [pc, #340]	; 2ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00001000        
 154:	e3a01a01 	mov	r1, #4096	; 0x1000
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
 158:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
 15c:	e59f014c 	ldr	r0, [pc, #332]	; 2b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
 160:	e3a01000 	mov	r1, #0
                                        @ 可让LED2熄灭
         str     r1,[r0]             @ GPB5输出0，LED2点亮
 164:	e5801000 	str	r1, [r0]

         b       .
 168:	eafffffe 	b	168 <bad_nand_read+0x18>

	 b	bad_nand_read	@ infinite loop
 16c:	eafffff7 	b	150 <bad_nand_read>

00000170 <ok_nand_read>:


ok_nand_read:    	

	mov	r0, #0
 170:	e3a00000 	mov	r0, #0
	ldr	r1, _text_start
 174:	e51f1128 	ldr	r1, [pc, #-296]	; 54 <_text_start>
	mov	r2, #512	
 178:	e3a02c02 	mov	r2, #512	; 0x200

0000017c <go_next>:
go_next:
	ldr	r3, [r0], #4
 17c:	e4903004 	ldr	r3, [r0], #4
	ldr	r4, [r1], #4
 180:	e4914004 	ldr	r4, [r1], #4
	cmp	r3, r4
 184:	e1530004 	cmp	r3, r4
	bne	notmatch
 188:	1a000002 	bne	198 <notmatch>
	cmp     r0, r2
 18c:	e1500002 	cmp	r0, r2
	beq	out
 190:	0a000008 	beq	1b8 <out>
	b	go_next
 194:	eafffff8 	b	17c <go_next>

00000198 <notmatch>:
	

notmatch:
         ldr     r0,=0x56000010      @ R0设为GPBCON寄存器。此寄存器
 198:	e59f010c 	ldr	r0, [pc, #268]	; 2ac <mem_cfg_val+0x4c>
                                        @ 用于选择端口B各引脚的功能：
                                        @ 是输出、是输入、还是其他
         mov     r1,#0x00000400        
 19c:	e3a01b01 	mov	r1, #1024	; 0x400
         str     r1,[r0]             @ 设置GPB5为输出口, 位[10:9]=0b01
 1a0:	e5801000 	str	r1, [r0]
         ldr     r0,=0x56000014      @ R0设为GPBDAT寄存器。此寄存器
 1a4:	e59f0104 	ldr	r0, [pc, #260]	; 2b0 <mem_cfg_val+0x50>
                                        @ 用于读/写端口B各引脚的数据
         mov     r1,#0x00000000      @ 此值改为0x00000020,
 1a8:	e3a01000 	mov	r1, #0
                                        @ 可让LED1熄灭
         str     r1,[r0]             @ GPB5输出0，LED1点亮
 1ac:	e5801000 	str	r1, [r0]

         b       .
 1b0:	eafffffe 	b	1b0 <notmatch+0x18>

	 b	notmatch
 1b4:	eafffff7 	b	198 <notmatch>

000001b8 <out>:

out:
        ldmfd sp!,{lr} 
 1b8:	e8bd4000 	ldmfd	sp!, {lr}

000001bc <InitStacks>:
@***************************************************************
@                       堆栈初始化
@***************************************************************

InitStacks:
	mov r2,lr
 1bc:	e1a0200e 	mov	r2, lr
	mrs	r0,cpsr
 1c0:	e10f0000 	mrs	r0, CPSR
	bic	r0,r0,#MODE_MASK
 1c4:	e3c0001f 	bic	r0, r0, #31
	orr	r1,r0,#UND_MODE|NOINT
 1c8:	e38010db 	orr	r1, r0, #219	; 0xdb
	msr	cpsr_cxsf,r1		@UndefMode
 1cc:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_FC00
 1d0:	e59fd0dc 	ldr	sp, [pc, #220]	; 2b4 <mem_cfg_val+0x54>

	orr	r1,r0,#ABT_MODE|NOINT
 1d4:	e38010d7 	orr	r1, r0, #215	; 0xd7
	msr	cpsr_cxsf,r1		@AbortMode
 1d8:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_FD00
 1dc:	e59fd0d4 	ldr	sp, [pc, #212]	; 2b8 <mem_cfg_val+0x58>

	orr	r1,r0,#IRQ_MODE|NOINT
 1e0:	e38010d2 	orr	r1, r0, #210	; 0xd2
	msr	cpsr_cxsf,r1		@IRQMode
 1e4:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
 1e8:	e59fd0cc 	ldr	sp, [pc, #204]	; 2bc <mem_cfg_val+0x5c>

	orr	r1,r0,#FIQ_MODE|NOINT
 1ec:	e38010d1 	orr	r1, r0, #209	; 0xd1
	msr	cpsr_cxsf,r1		@FIQMode
 1f0:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
 1f4:	e59fd0c4 	ldr	sp, [pc, #196]	; 2c0 <mem_cfg_val+0x60>

	bic	r0,r0,#MODE_MASK|NOINT
 1f8:	e3c000df 	bic	r0, r0, #223	; 0xdf
	orr	r1,r0,#SVC_MODE
 1fc:	e3801013 	orr	r1, r0, #19
	msr	cpsr_cxsf,r1		@SVCMode
 200:	e12ff001 	msr	CPSR_fsxc, r1
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
 204:	e59fd0b8 	ldr	sp, [pc, #184]	; 2c4 <mem_cfg_val+0x64>

	mrs     r0,cpsr
 208:	e10f0000 	mrs	r0, CPSR
       	bic     r0,r0,#MODE_MASK
 20c:	e3c0001f 	bic	r0, r0, #31
	orr     r1,r0,#SYS_MODE|NOINT
 210:	e38010df 	orr	r1, r0, #223	; 0xdf
	msr     cpsr_cxsf,r1    	@ userMode
 214:	e12ff001 	msr	CPSR_fsxc, r1
	ldr     sp,=SYS_stack
 218:	e59fd0a8 	ldr	sp, [pc, #168]	; 2c8 <mem_cfg_val+0x68>

	mov	pc,r2
 21c:	e1a0f002 	mov	pc, r2

00000220 <memsetup>:
@***************************************************************
@ initialise the static memory
@ set memory control registers
@***************************************************************
memsetup:
	mov	r1, #MEM_CTL_BASE
 220:	e3a01312 	mov	r1, #1207959552	; 0x48000000
	adrl	r2, mem_cfg_val
 224:	e28f2034 	add	r2, pc, #52	; 0x34
 228:	e1a00000 	nop			; (mov r0, r0)
	add	r3, r1, #52
 22c:	e2813034 	add	r3, r1, #52	; 0x34
1:	ldr	r4, [r2], #4
 230:	e4924004 	ldr	r4, [r2], #4
	str	r4, [r1], #4
 234:	e4814004 	str	r4, [r1], #4
	cmp	r1, r3
 238:	e1510003 	cmp	r1, r3
	bne	1b
 23c:	1afffffb 	bne	230 <memsetup+0x10>
	mov	pc, lr
 240:	e1a0f00e 	mov	pc, lr

00000244 <mem_clear>:
@ r0: start address
@ r1: length
@***************************************************************

mem_clear:
	mov r2,#0
 244:	e3a02000 	mov	r2, #0
1:	str r2,[r0],#4
 248:	e4802004 	str	r2, [r0], #4
	cmp r0,r1
 24c:	e1500001 	cmp	r0, r1
	blt 1b
 250:	bafffffc 	blt	248 <mem_clear+0x4>
	mov pc,lr
 254:	e1a0f00e 	mov	pc, lr
 258:	e1a00000 	nop			; (mov r0, r0)
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
 294:	30000a68 	.word	0x30000a68
	ldr pc,=HAL_INTR_ENTRY
 298:	30000b78 	.word	0x30000b78
	ldr pc,=EXP_HANDLER
 29c:	30000bb4 	.word	0x30000bb4
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
	ldr	sp,=UDF_stack		@ UndefStack=0x33FF_FC00
 2b4:	33fffc00 	.word	0x33fffc00
	ldr	sp,=ABT_stack		@ AbortStack=0x33FF_FD00
 2b8:	33fffd00 	.word	0x33fffd00
	ldr	sp,=IRQ_stack		@ IRQStack=0x33FF_7000
 2bc:	33ffff00 	.word	0x33ffff00
	ldr	sp,=FIQ_stack		@ FIQStack=0x33FF_8000
 2c0:	33ffff00 	.word	0x33ffff00
	ldr	sp,=SVC_stack		@ SVCStack=0x33FF_5800
 2c4:	33fffb00 	.word	0x33fffb00
	ldr     sp,=SYS_stack
 2c8:	33fff900 	.word	0x33fff900

000002cc <nand_wait>:

void nand_init(void);
int nand_read(unsigned char *buf, unsigned long start_addr, int size);

static void nand_wait(void)
{
 2cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
 2d0:	e28db000 	add	fp, sp, #0
 2d4:	e24dd00c 	sub	sp, sp, #12
  int i;
  while (!(NFSTAT & NFSTAT_BUSY))
 2d8:	ea000008 	b	300 <nand_wait+0x34>
   for (i=0; i<10; i++);
 2dc:	e3a03000 	mov	r3, #0
 2e0:	e50b3008 	str	r3, [fp, #-8]
 2e4:	ea000002 	b	2f4 <nand_wait+0x28>
 2e8:	e51b3008 	ldr	r3, [fp, #-8]
 2ec:	e2833001 	add	r3, r3, #1
 2f0:	e50b3008 	str	r3, [fp, #-8]
 2f4:	e51b3008 	ldr	r3, [fp, #-8]
 2f8:	e3530009 	cmp	r3, #9
 2fc:	dafffff9 	ble	2e8 <nand_wait+0x1c>
  while (!(NFSTAT & NFSTAT_BUSY))
 300:	e59f3020 	ldr	r3, [pc, #32]	; 328 <nand_wait+0x5c>
 304:	e5d33000 	ldrb	r3, [r3]
 308:	e20330ff 	and	r3, r3, #255	; 0xff
 30c:	e2033004 	and	r3, r3, #4
 310:	e3530000 	cmp	r3, #0
 314:	0afffff0 	beq	2dc <nand_wait+0x10>
}
 318:	e1a00000 	nop			; (mov r0, r0)
 31c:	e28bd000 	add	sp, fp, #0
 320:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
 324:	e12fff1e 	bx	lr
 328:	4e000020 	.word	0x4e000020

0000032c <nand_reset>:


static void nand_reset(){
 32c:	e92d4800 	push	{fp, lr}
 330:	e28db004 	add	fp, sp, #4
 334:	e24dd008 	sub	sp, sp, #8
   int i;

   nand_select();
 338:	e59f3064 	ldr	r3, [pc, #100]	; 3a4 <nand_reset+0x78>
 33c:	e5933000 	ldr	r3, [r3]
 340:	e59f205c 	ldr	r2, [pc, #92]	; 3a4 <nand_reset+0x78>
 344:	e3c33002 	bic	r3, r3, #2
 348:	e5823000 	str	r3, [r2]
   NFCMD=NAND_CMD_RESET;
 34c:	e59f3054 	ldr	r3, [pc, #84]	; 3a8 <nand_reset+0x7c>
 350:	e3e02000 	mvn	r2, #0
 354:	e5c32000 	strb	r2, [r3]
   for(i=0;i<10;i++);  
 358:	e3a03000 	mov	r3, #0
 35c:	e50b3008 	str	r3, [fp, #-8]
 360:	ea000002 	b	370 <nand_reset+0x44>
 364:	e51b3008 	ldr	r3, [fp, #-8]
 368:	e2833001 	add	r3, r3, #1
 36c:	e50b3008 	str	r3, [fp, #-8]
 370:	e51b3008 	ldr	r3, [fp, #-8]
 374:	e3530009 	cmp	r3, #9
 378:	dafffff9 	ble	364 <nand_reset+0x38>
   nand_wait();  
 37c:	ebffffd2 	bl	2cc <nand_wait>
   nand_deselect();
 380:	e59f301c 	ldr	r3, [pc, #28]	; 3a4 <nand_reset+0x78>
 384:	e5933000 	ldr	r3, [r3]
 388:	e59f2014 	ldr	r2, [pc, #20]	; 3a4 <nand_reset+0x78>
 38c:	e3833002 	orr	r3, r3, #2
 390:	e5823000 	str	r3, [r2]
}
 394:	e1a00000 	nop			; (mov r0, r0)
 398:	e24bd004 	sub	sp, fp, #4
 39c:	e8bd4800 	pop	{fp, lr}
 3a0:	e12fff1e 	bx	lr
 3a4:	4e000004 	.word	0x4e000004
 3a8:	4e000008 	.word	0x4e000008

000003ac <nand_init>:


void nand_init(void){
 3ac:	e92d4800 	push	{fp, lr}
 3b0:	e28db004 	add	fp, sp, #4
   

    NFCONF=(7<<12)|(7<<8)|(7<<4)|(0<<0);
 3b4:	e3a0344e 	mov	r3, #1308622848	; 0x4e000000
 3b8:	e59f2020 	ldr	r2, [pc, #32]	; 3e0 <nand_init+0x34>
 3bc:	e5832000 	str	r2, [r3]
    NFCONT=(1<<4)|(0<<1)|(1<<0);
 3c0:	e59f301c 	ldr	r3, [pc, #28]	; 3e4 <nand_init+0x38>
 3c4:	e3a02011 	mov	r2, #17
 3c8:	e5832000 	str	r2, [r3]
    
    nand_reset();
 3cc:	ebffffd6 	bl	32c <nand_reset>
}
 3d0:	e1a00000 	nop			; (mov r0, r0)
 3d4:	e24bd004 	sub	sp, fp, #4
 3d8:	e8bd4800 	pop	{fp, lr}
 3dc:	e12fff1e 	bx	lr
 3e0:	00007770 	.word	0x00007770
 3e4:	4e000004 	.word	0x4e000004

000003e8 <is_bad_block>:
    int bad_block_offset;
};


static int is_bad_block(struct boot_nand_t * nand, unsigned long i)
{
 3e8:	e92d4800 	push	{fp, lr}
 3ec:	e28db004 	add	fp, sp, #4
 3f0:	e24dd010 	sub	sp, sp, #16
 3f4:	e50b0010 	str	r0, [fp, #-16]
 3f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
	unsigned char data;
	unsigned long page_num;

	nand_clear_RnB();
 3fc:	e59f3168 	ldr	r3, [pc, #360]	; 56c <is_bad_block+0x184>
 400:	e5d33000 	ldrb	r3, [r3]
 404:	e20330ff 	and	r3, r3, #255	; 0xff
 408:	e59f215c 	ldr	r2, [pc, #348]	; 56c <is_bad_block+0x184>
 40c:	e3833004 	orr	r3, r3, #4
 410:	e20330ff 	and	r3, r3, #255	; 0xff
 414:	e5c23000 	strb	r3, [r2]
	if (nand->page_size == 512) {
 418:	e51b3010 	ldr	r3, [fp, #-16]
 41c:	e5933000 	ldr	r3, [r3]
 420:	e3530c02 	cmp	r3, #512	; 0x200
 424:	1a000019 	bne	490 <is_bad_block+0xa8>
		NFCMD = NAND_CMD_READOOB; /* 0x50 */
 428:	e59f3140 	ldr	r3, [pc, #320]	; 570 <is_bad_block+0x188>
 42c:	e3a02050 	mov	r2, #80	; 0x50
 430:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xf;
 434:	e51b3010 	ldr	r3, [fp, #-16]
 438:	e5933008 	ldr	r3, [r3, #8]
 43c:	e20330ff 	and	r3, r3, #255	; 0xff
 440:	e59f212c 	ldr	r2, [pc, #300]	; 574 <is_bad_block+0x18c>
 444:	e203300f 	and	r3, r3, #15
 448:	e20330ff 	and	r3, r3, #255	; 0xff
 44c:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 9) & 0xff;
 450:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 454:	e1a034a3 	lsr	r3, r3, #9
 458:	e59f2114 	ldr	r2, [pc, #276]	; 574 <is_bad_block+0x18c>
 45c:	e20330ff 	and	r3, r3, #255	; 0xff
 460:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 17) & 0xff;
 464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 468:	e1a038a3 	lsr	r3, r3, #17
 46c:	e59f2100 	ldr	r2, [pc, #256]	; 574 <is_bad_block+0x18c>
 470:	e20330ff 	and	r3, r3, #255	; 0xff
 474:	e5c23000 	strb	r3, [r2]
		NFADDR = (i >> 25) & 0xff;
 478:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 47c:	e1a03ca3 	lsr	r3, r3, #25
 480:	e59f20ec 	ldr	r2, [pc, #236]	; 574 <is_bad_block+0x18c>
 484:	e20330ff 	and	r3, r3, #255	; 0xff
 488:	e5c23000 	strb	r3, [r2]
 48c:	ea000028 	b	534 <is_bad_block+0x14c>
	} else if (nand->page_size == 2048) {
 490:	e51b3010 	ldr	r3, [fp, #-16]
 494:	e5933000 	ldr	r3, [r3]
 498:	e3530b02 	cmp	r3, #2048	; 0x800
 49c:	1a000022 	bne	52c <is_bad_block+0x144>
		page_num = i >> 11; /* addr / 2048 */
 4a0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
 4a4:	e1a035a3 	lsr	r3, r3, #11
 4a8:	e50b3008 	str	r3, [fp, #-8]
		NFCMD = NAND_CMD_READ0;
 4ac:	e59f30bc 	ldr	r3, [pc, #188]	; 570 <is_bad_block+0x188>
 4b0:	e3a02000 	mov	r2, #0
 4b4:	e5c32000 	strb	r2, [r3]
		NFADDR = nand->bad_block_offset & 0xff;
 4b8:	e51b3010 	ldr	r3, [fp, #-16]
 4bc:	e5933008 	ldr	r3, [r3, #8]
 4c0:	e59f20ac 	ldr	r2, [pc, #172]	; 574 <is_bad_block+0x18c>
 4c4:	e20330ff 	and	r3, r3, #255	; 0xff
 4c8:	e5c23000 	strb	r3, [r2]
		NFADDR = (nand->bad_block_offset >> 8) & 0xff;
 4cc:	e51b3010 	ldr	r3, [fp, #-16]
 4d0:	e5933008 	ldr	r3, [r3, #8]
 4d4:	e1a03443 	asr	r3, r3, #8
 4d8:	e59f2094 	ldr	r2, [pc, #148]	; 574 <is_bad_block+0x18c>
 4dc:	e20330ff 	and	r3, r3, #255	; 0xff
 4e0:	e5c23000 	strb	r3, [r2]
		NFADDR = page_num & 0xff;
 4e4:	e59f2088 	ldr	r2, [pc, #136]	; 574 <is_bad_block+0x18c>
 4e8:	e51b3008 	ldr	r3, [fp, #-8]
 4ec:	e20330ff 	and	r3, r3, #255	; 0xff
 4f0:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
 4f4:	e51b3008 	ldr	r3, [fp, #-8]
 4f8:	e1a03423 	lsr	r3, r3, #8
 4fc:	e59f2070 	ldr	r2, [pc, #112]	; 574 <is_bad_block+0x18c>
 500:	e20330ff 	and	r3, r3, #255	; 0xff
 504:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
 508:	e51b3008 	ldr	r3, [fp, #-8]
 50c:	e1a03823 	lsr	r3, r3, #16
 510:	e59f205c 	ldr	r2, [pc, #92]	; 574 <is_bad_block+0x18c>
 514:	e20330ff 	and	r3, r3, #255	; 0xff
 518:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
 51c:	e59f304c 	ldr	r3, [pc, #76]	; 570 <is_bad_block+0x188>
 520:	e3a02030 	mov	r2, #48	; 0x30
 524:	e5c32000 	strb	r2, [r3]
 528:	ea000001 	b	534 <is_bad_block+0x14c>
	} else {
		return -1;
 52c:	e3e03000 	mvn	r3, #0
 530:	ea000009 	b	55c <is_bad_block+0x174>
	}
	nand_wait();
 534:	ebffff64 	bl	2cc <nand_wait>
	data = (NFDATA & 0xff);
 538:	e59f3038 	ldr	r3, [pc, #56]	; 578 <is_bad_block+0x190>
 53c:	e5d33000 	ldrb	r3, [r3]
 540:	e54b3009 	strb	r3, [fp, #-9]
	if (data != 0xff)
 544:	e55b3009 	ldrb	r3, [fp, #-9]
 548:	e35300ff 	cmp	r3, #255	; 0xff
 54c:	0a000001 	beq	558 <is_bad_block+0x170>
		return 1;
 550:	e3a03001 	mov	r3, #1
 554:	ea000000 	b	55c <is_bad_block+0x174>

	return 0;
 558:	e3a03000 	mov	r3, #0
}
 55c:	e1a00003 	mov	r0, r3
 560:	e24bd004 	sub	sp, fp, #4
 564:	e8bd4800 	pop	{fp, lr}
 568:	e12fff1e 	bx	lr
 56c:	4e000020 	.word	0x4e000020
 570:	4e000008 	.word	0x4e000008
 574:	4e00000c 	.word	0x4e00000c
 578:	4e000010 	.word	0x4e000010

0000057c <nand_read_page>:

static int nand_read_page(struct boot_nand_t * nand, unsigned char *buf, unsigned long addr)
{
 57c:	e92d4800 	push	{fp, lr}
 580:	e28db004 	add	fp, sp, #4
 584:	e24dd020 	sub	sp, sp, #32
 588:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
 58c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
 590:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
	unsigned short *ptr16 = (unsigned short *)buf;
 594:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 598:	e50b3008 	str	r3, [fp, #-8]
	unsigned int i, page_num;

	nand_clear_RnB();
 59c:	e59f3178 	ldr	r3, [pc, #376]	; 71c <nand_read_page+0x1a0>
 5a0:	e5d33000 	ldrb	r3, [r3]
 5a4:	e20330ff 	and	r3, r3, #255	; 0xff
 5a8:	e59f216c 	ldr	r2, [pc, #364]	; 71c <nand_read_page+0x1a0>
 5ac:	e3833004 	orr	r3, r3, #4
 5b0:	e20330ff 	and	r3, r3, #255	; 0xff
 5b4:	e5c23000 	strb	r3, [r2]

	NFCMD = NAND_CMD_READ0;
 5b8:	e59f3160 	ldr	r3, [pc, #352]	; 720 <nand_read_page+0x1a4>
 5bc:	e3a02000 	mov	r2, #0
 5c0:	e5c32000 	strb	r2, [r3]

	if (nand->page_size == 512) {
 5c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 5c8:	e5933000 	ldr	r3, [r3]
 5cc:	e3530c02 	cmp	r3, #512	; 0x200
 5d0:	1a000013 	bne	624 <nand_read_page+0xa8>
		/* Write Address */
		NFADDR = addr & 0xff;
 5d4:	e59f2148 	ldr	r2, [pc, #328]	; 724 <nand_read_page+0x1a8>
 5d8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 5dc:	e20330ff 	and	r3, r3, #255	; 0xff
 5e0:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 9) & 0xff;
 5e4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 5e8:	e1a034a3 	lsr	r3, r3, #9
 5ec:	e59f2130 	ldr	r2, [pc, #304]	; 724 <nand_read_page+0x1a8>
 5f0:	e20330ff 	and	r3, r3, #255	; 0xff
 5f4:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 17) & 0xff;
 5f8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 5fc:	e1a038a3 	lsr	r3, r3, #17
 600:	e59f211c 	ldr	r2, [pc, #284]	; 724 <nand_read_page+0x1a8>
 604:	e20330ff 	and	r3, r3, #255	; 0xff
 608:	e5c23000 	strb	r3, [r2]
		NFADDR = (addr >> 25) & 0xff;
 60c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 610:	e1a03ca3 	lsr	r3, r3, #25
 614:	e59f2108 	ldr	r2, [pc, #264]	; 724 <nand_read_page+0x1a8>
 618:	e20330ff 	and	r3, r3, #255	; 0xff
 61c:	e5c23000 	strb	r3, [r2]
 620:	ea000020 	b	6a8 <nand_read_page+0x12c>
	} else if (nand->page_size == 2048) {
 624:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 628:	e5933000 	ldr	r3, [r3]
 62c:	e3530b02 	cmp	r3, #2048	; 0x800
 630:	1a00001a 	bne	6a0 <nand_read_page+0x124>
		page_num = addr >> 11; /* addr / 2048 */
 634:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
 638:	e1a035a3 	lsr	r3, r3, #11
 63c:	e50b3010 	str	r3, [fp, #-16]
		/* Write Address */
		NFADDR = 0;
 640:	e59f30dc 	ldr	r3, [pc, #220]	; 724 <nand_read_page+0x1a8>
 644:	e3a02000 	mov	r2, #0
 648:	e5c32000 	strb	r2, [r3]
		NFADDR = 0;
 64c:	e59f30d0 	ldr	r3, [pc, #208]	; 724 <nand_read_page+0x1a8>
 650:	e3a02000 	mov	r2, #0
 654:	e5c32000 	strb	r2, [r3]
		NFADDR = page_num & 0xff;
 658:	e59f20c4 	ldr	r2, [pc, #196]	; 724 <nand_read_page+0x1a8>
 65c:	e51b3010 	ldr	r3, [fp, #-16]
 660:	e20330ff 	and	r3, r3, #255	; 0xff
 664:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 8) & 0xff;
 668:	e51b3010 	ldr	r3, [fp, #-16]
 66c:	e1a03423 	lsr	r3, r3, #8
 670:	e59f20ac 	ldr	r2, [pc, #172]	; 724 <nand_read_page+0x1a8>
 674:	e20330ff 	and	r3, r3, #255	; 0xff
 678:	e5c23000 	strb	r3, [r2]
		NFADDR = (page_num >> 16) & 0xff;
 67c:	e51b3010 	ldr	r3, [fp, #-16]
 680:	e1a03823 	lsr	r3, r3, #16
 684:	e59f2098 	ldr	r2, [pc, #152]	; 724 <nand_read_page+0x1a8>
 688:	e20330ff 	and	r3, r3, #255	; 0xff
 68c:	e5c23000 	strb	r3, [r2]
		NFCMD = NAND_CMD_READSTART;
 690:	e59f3088 	ldr	r3, [pc, #136]	; 720 <nand_read_page+0x1a4>
 694:	e3a02030 	mov	r2, #48	; 0x30
 698:	e5c32000 	strb	r2, [r3]
 69c:	ea000001 	b	6a8 <nand_read_page+0x12c>
	} else {
		return -1;
 6a0:	e3e03000 	mvn	r3, #0
 6a4:	ea000018 	b	70c <nand_read_page+0x190>
	}
	nand_wait();
 6a8:	ebffff07 	bl	2cc <nand_wait>
	for (i = 0; i < (nand->page_size>>1); i++) {
 6ac:	e3a03000 	mov	r3, #0
 6b0:	e50b300c 	str	r3, [fp, #-12]
 6b4:	ea00000b 	b	6e8 <nand_read_page+0x16c>
		*ptr16 = NFDATA16;
 6b8:	e59f3068 	ldr	r3, [pc, #104]	; 728 <nand_read_page+0x1ac>
 6bc:	e1d330b0 	ldrh	r3, [r3]
 6c0:	e1a03803 	lsl	r3, r3, #16
 6c4:	e1a02823 	lsr	r2, r3, #16
 6c8:	e51b3008 	ldr	r3, [fp, #-8]
 6cc:	e1c320b0 	strh	r2, [r3]
		ptr16++;
 6d0:	e51b3008 	ldr	r3, [fp, #-8]
 6d4:	e2833002 	add	r3, r3, #2
 6d8:	e50b3008 	str	r3, [fp, #-8]
	for (i = 0; i < (nand->page_size>>1); i++) {
 6dc:	e51b300c 	ldr	r3, [fp, #-12]
 6e0:	e2833001 	add	r3, r3, #1
 6e4:	e50b300c 	str	r3, [fp, #-12]
 6e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 6ec:	e5933000 	ldr	r3, [r3]
 6f0:	e1a030c3 	asr	r3, r3, #1
 6f4:	e1a02003 	mov	r2, r3
 6f8:	e51b300c 	ldr	r3, [fp, #-12]
 6fc:	e1530002 	cmp	r3, r2
 700:	3affffec 	bcc	6b8 <nand_read_page+0x13c>
	}

	return nand->page_size;
 704:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 708:	e5933000 	ldr	r3, [r3]
}
 70c:	e1a00003 	mov	r0, r3
 710:	e24bd004 	sub	sp, fp, #4
 714:	e8bd4800 	pop	{fp, lr}
 718:	e12fff1e 	bx	lr
 71c:	4e000020 	.word	0x4e000020
 720:	4e000008 	.word	0x4e000008
 724:	4e00000c 	.word	0x4e00000c
 728:	4e000010 	.word	0x4e000010

0000072c <nand_read_id>:


static unsigned short nand_read_id()
{
 72c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
 730:	e28db000 	add	fp, sp, #0
 734:	e24dd00c 	sub	sp, sp, #12
	unsigned short res = 0;
 738:	e3a03000 	mov	r3, #0
 73c:	e14b30b6 	strh	r3, [fp, #-6]
	NFCMD = NAND_CMD_READID;
 740:	e59f3068 	ldr	r3, [pc, #104]	; 7b0 <nand_read_id+0x84>
 744:	e3e0206f 	mvn	r2, #111	; 0x6f
 748:	e5c32000 	strb	r2, [r3]
	NFADDR = 0;
 74c:	e59f3060 	ldr	r3, [pc, #96]	; 7b4 <nand_read_id+0x88>
 750:	e3a02000 	mov	r2, #0
 754:	e5c32000 	strb	r2, [r3]
	res = NFDATA;
 758:	e59f3058 	ldr	r3, [pc, #88]	; 7b8 <nand_read_id+0x8c>
 75c:	e5d33000 	ldrb	r3, [r3]
 760:	e20330ff 	and	r3, r3, #255	; 0xff
 764:	e14b30b6 	strh	r3, [fp, #-6]
	res = (res << 8) | NFDATA;
 768:	e15b30b6 	ldrh	r3, [fp, #-6]
 76c:	e1a03403 	lsl	r3, r3, #8
 770:	e1a03803 	lsl	r3, r3, #16
 774:	e1a02843 	asr	r2, r3, #16
 778:	e59f3038 	ldr	r3, [pc, #56]	; 7b8 <nand_read_id+0x8c>
 77c:	e5d33000 	ldrb	r3, [r3]
 780:	e20330ff 	and	r3, r3, #255	; 0xff
 784:	e1a03803 	lsl	r3, r3, #16
 788:	e1a03843 	asr	r3, r3, #16
 78c:	e1823003 	orr	r3, r2, r3
 790:	e1a03803 	lsl	r3, r3, #16
 794:	e1a03843 	asr	r3, r3, #16
 798:	e14b30b6 	strh	r3, [fp, #-6]
	return res;
 79c:	e15b30b6 	ldrh	r3, [fp, #-6]
}
 7a0:	e1a00003 	mov	r0, r3
 7a4:	e28bd000 	add	sp, fp, #0
 7a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
 7ac:	e12fff1e 	bx	lr
 7b0:	4e000008 	.word	0x4e000008
 7b4:	4e00000c 	.word	0x4e00000c
 7b8:	4e000010 	.word	0x4e000010

000007bc <nand_read>:



int nand_read(unsigned char *buf, unsigned long start_addr, int size)
{
 7bc:	e92d4800 	push	{fp, lr}
 7c0:	e28db004 	add	fp, sp, #4
 7c4:	e24dd028 	sub	sp, sp, #40	; 0x28
 7c8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
 7cc:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
 7d0:	e50b2028 	str	r2, [fp, #-40]	; 0xffffffd8
	int i, j;
	unsigned short nand_id;
	struct boot_nand_t nand;

	
	nand_select();
 7d4:	e59f3270 	ldr	r3, [pc, #624]	; a4c <nand_read+0x290>
 7d8:	e5933000 	ldr	r3, [r3]
 7dc:	e59f2268 	ldr	r2, [pc, #616]	; a4c <nand_read+0x290>
 7e0:	e3c33002 	bic	r3, r3, #2
 7e4:	e5823000 	str	r3, [r2]
	nand_clear_RnB();
 7e8:	e59f3260 	ldr	r3, [pc, #608]	; a50 <nand_read+0x294>
 7ec:	e5d33000 	ldrb	r3, [r3]
 7f0:	e20330ff 	and	r3, r3, #255	; 0xff
 7f4:	e59f2254 	ldr	r2, [pc, #596]	; a50 <nand_read+0x294>
 7f8:	e3833004 	orr	r3, r3, #4
 7fc:	e20330ff 	and	r3, r3, #255	; 0xff
 800:	e5c23000 	strb	r3, [r2]
	
	for (i = 0; i < 10; i++);
 804:	e3a03000 	mov	r3, #0
 808:	e50b3008 	str	r3, [fp, #-8]
 80c:	ea000002 	b	81c <nand_read+0x60>
 810:	e51b3008 	ldr	r3, [fp, #-8]
 814:	e2833001 	add	r3, r3, #1
 818:	e50b3008 	str	r3, [fp, #-8]
 81c:	e51b3008 	ldr	r3, [fp, #-8]
 820:	e3530009 	cmp	r3, #9
 824:	dafffff9 	ble	810 <nand_read+0x54>

	nand_id = nand_read_id();	
 828:	ebffffbf 	bl	72c <nand_read_id>
 82c:	e1a03000 	mov	r3, r0
 830:	e14b30ba 	strh	r3, [fp, #-10]

       if (nand_id == 0xec76 ||		/* Samsung K91208 */
 834:	e15b30ba 	ldrh	r3, [fp, #-10]
 838:	e59f2214 	ldr	r2, [pc, #532]	; a54 <nand_read+0x298>
 83c:	e1530002 	cmp	r3, r2
 840:	0a000003 	beq	854 <nand_read+0x98>
 844:	e15b30ba 	ldrh	r3, [fp, #-10]
 848:	e59f2208 	ldr	r2, [pc, #520]	; a58 <nand_read+0x29c>
 84c:	e1530002 	cmp	r3, r2
 850:	1a000006 	bne	870 <nand_read+0xb4>
           nand_id == 0xad76 ) {	/*Hynix HY27US08121A*/
		nand.page_size = 512;
 854:	e3a03c02 	mov	r3, #512	; 0x200
 858:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 16 * 1024;
 85c:	e3a03901 	mov	r3, #16384	; 0x4000
 860:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = 5;
 864:	e3a03005 	mov	r3, #5
 868:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
 86c:	ea000014 	b	8c4 <nand_read+0x108>
	} 
        else if (nand_id == 0xecf1 ||	/* Samsung K9F1G08U0B */
 870:	e15b30ba 	ldrh	r3, [fp, #-10]
 874:	e59f21e0 	ldr	r2, [pc, #480]	; a5c <nand_read+0x2a0>
 878:	e1530002 	cmp	r3, r2
 87c:	0a000007 	beq	8a0 <nand_read+0xe4>
 880:	e15b30ba 	ldrh	r3, [fp, #-10]
 884:	e59f21d4 	ldr	r2, [pc, #468]	; a60 <nand_read+0x2a4>
 888:	e1530002 	cmp	r3, r2
 88c:	0a000003 	beq	8a0 <nand_read+0xe4>
		   nand_id == 0xecda ||	/* Samsung K9F2G08U0B */
 890:	e15b30ba 	ldrh	r3, [fp, #-10]
 894:	e59f21c8 	ldr	r2, [pc, #456]	; a64 <nand_read+0x2a8>
 898:	e1530002 	cmp	r3, r2
 89c:	1a000006 	bne	8bc <nand_read+0x100>
		   nand_id == 0xecd3 )	{ /* Samsung K9K8G08 */
		nand.page_size = 2048;
 8a0:	e3a03b02 	mov	r3, #2048	; 0x800
 8a4:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
		nand.block_size = 128 * 1024;
 8a8:	e3a03802 	mov	r3, #131072	; 0x20000
 8ac:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
		nand.bad_block_offset = nand.page_size;
 8b0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 8b4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
 8b8:	ea000001 	b	8c4 <nand_read+0x108>
	} 
        else {
		return -1; 
 8bc:	e3e03000 	mvn	r3, #0
 8c0:	ea00005d 	b	a3c <nand_read+0x280>
	}

         if ((start_addr & (nand.block_size-1)))
 8c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 8c8:	e2433001 	sub	r3, r3, #1
 8cc:	e1a02003 	mov	r2, r3
 8d0:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 8d4:	e0033002 	and	r3, r3, r2
 8d8:	e3530000 	cmp	r3, #0
 8dc:	0a000001 	beq	8e8 <nand_read+0x12c>
		return -1;	
 8e0:	e3e03000 	mvn	r3, #0
 8e4:	ea000054 	b	a3c <nand_read+0x280>
        
        if(size & (nand.page_size-1)){
 8e8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 8ec:	e2432001 	sub	r2, r3, #1
 8f0:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 8f4:	e0033002 	and	r3, r3, r2
 8f8:	e3530000 	cmp	r3, #0
 8fc:	0a000007 	beq	920 <nand_read+0x164>
             size=(size+nand.page_size-1) & (~(nand.page_size-1));
 900:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
 904:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 908:	e0823003 	add	r3, r2, r3
 90c:	e2432001 	sub	r2, r3, #1
 910:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 914:	e2633000 	rsb	r3, r3, #0
 918:	e0033002 	and	r3, r3, r2
 91c:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
        }

        if ((size & (nand.page_size-1)))
 920:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
 924:	e2432001 	sub	r2, r3, #1
 928:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
 92c:	e0033002 	and	r3, r3, r2
 930:	e3530000 	cmp	r3, #0
 934:	0a000001 	beq	940 <nand_read+0x184>
		return -1;
 938:	e3e03000 	mvn	r3, #0
 93c:	ea00003e 	b	a3c <nand_read+0x280>

	for (i=start_addr; i < (start_addr + size);) {
 940:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 944:	e50b3008 	str	r3, [fp, #-8]
 948:	ea00002f 	b	a0c <nand_read+0x250>

		if ((i & (nand.block_size-1))== 0) {
 94c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 950:	e2432001 	sub	r2, r3, #1
 954:	e51b3008 	ldr	r3, [fp, #-8]
 958:	e0033002 	and	r3, r3, r2
 95c:	e3530000 	cmp	r3, #0
 960:	1a00001b 	bne	9d4 <nand_read+0x218>
			if (is_bad_block(&nand, i) || is_bad_block(&nand, i + nand.page_size)) {
 964:	e51b2008 	ldr	r2, [fp, #-8]
 968:	e24b301c 	sub	r3, fp, #28
 96c:	e1a01002 	mov	r1, r2
 970:	e1a00003 	mov	r0, r3
 974:	ebfffe9b 	bl	3e8 <is_bad_block>
 978:	e1a03000 	mov	r3, r0
 97c:	e3530000 	cmp	r3, #0
 980:	1a00000a 	bne	9b0 <nand_read+0x1f4>
 984:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
 988:	e51b3008 	ldr	r3, [fp, #-8]
 98c:	e0823003 	add	r3, r2, r3
 990:	e1a02003 	mov	r2, r3
 994:	e24b301c 	sub	r3, fp, #28
 998:	e1a01002 	mov	r1, r2
 99c:	e1a00003 	mov	r0, r3
 9a0:	ebfffe90 	bl	3e8 <is_bad_block>
 9a4:	e1a03000 	mov	r3, r0
 9a8:	e3530000 	cmp	r3, #0
 9ac:	0a000008 	beq	9d4 <nand_read+0x218>
				i += nand.block_size;
 9b0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 9b4:	e51b2008 	ldr	r2, [fp, #-8]
 9b8:	e0823003 	add	r3, r2, r3
 9bc:	e50b3008 	str	r3, [fp, #-8]
				size += nand.block_size;
 9c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
 9c4:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
 9c8:	e0823003 	add	r3, r2, r3
 9cc:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
				continue;
 9d0:	ea00000d 	b	a0c <nand_read+0x250>
			}
		}

		j = nand_read_page(&nand, buf, i);
 9d4:	e51b2008 	ldr	r2, [fp, #-8]
 9d8:	e24b301c 	sub	r3, fp, #28
 9dc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
 9e0:	e1a00003 	mov	r0, r3
 9e4:	ebfffee4 	bl	57c <nand_read_page>
 9e8:	e50b0010 	str	r0, [fp, #-16]
		i += j;
 9ec:	e51b2008 	ldr	r2, [fp, #-8]
 9f0:	e51b3010 	ldr	r3, [fp, #-16]
 9f4:	e0823003 	add	r3, r2, r3
 9f8:	e50b3008 	str	r3, [fp, #-8]
		buf += j;
 9fc:	e51b3010 	ldr	r3, [fp, #-16]
 a00:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
 a04:	e0823003 	add	r3, r2, r3
 a08:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
	for (i=start_addr; i < (start_addr + size);) {
 a0c:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
 a10:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
 a14:	e0822003 	add	r2, r2, r3
 a18:	e51b3008 	ldr	r3, [fp, #-8]
 a1c:	e1520003 	cmp	r2, r3
 a20:	8affffc9 	bhi	94c <nand_read+0x190>
	}


	nand_deselect();
 a24:	e59f3020 	ldr	r3, [pc, #32]	; a4c <nand_read+0x290>
 a28:	e5933000 	ldr	r3, [r3]
 a2c:	e59f2018 	ldr	r2, [pc, #24]	; a4c <nand_read+0x290>
 a30:	e3833002 	orr	r3, r3, #2
 a34:	e5823000 	str	r3, [r2]

	return 0;
 a38:	e3a03000 	mov	r3, #0
}
 a3c:	e1a00003 	mov	r0, r3
 a40:	e24bd004 	sub	sp, fp, #4
 a44:	e8bd4800 	pop	{fp, lr}
 a48:	e12fff1e 	bx	lr
 a4c:	4e000004 	.word	0x4e000004
 a50:	4e000020 	.word	0x4e000020
 a54:	0000ec76 	.word	0x0000ec76
 a58:	0000ad76 	.word	0x0000ad76
 a5c:	0000ecf1 	.word	0x0000ecf1
 a60:	0000ecda 	.word	0x0000ecda
 a64:	0000ecd3 	.word	0x0000ecd3

Disassembly of section .text:

30000a68 <acoral_start>:
#include "ch1.h"

int acoral_start(){
30000a68:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
30000a6c:	e28db000 	add	fp, sp, #0
	rCLKDIVN = 0X5;	
30000a70:	e59f30d0 	ldr	r3, [pc, #208]	; 30000b48 <acoral_start+0xe0>
30000a74:	e3a02005 	mov	r2, #5
30000a78:	e5832000 	str	r2, [r3]
	rMPLLCON = (0X7f<<12) | (0X2<<4) | (0X1);
30000a7c:	e59f30c8 	ldr	r3, [pc, #200]	; 30000b4c <acoral_start+0xe4>
30000a80:	e59f20c8 	ldr	r2, [pc, #200]	; 30000b50 <acoral_start+0xe8>
30000a84:	e5832000 	str	r2, [r3]
	rGPGCON = 0;			//检测按键状态
30000a88:	e59f30c4 	ldr	r3, [pc, #196]	; 30000b54 <acoral_start+0xec>
30000a8c:	e3a02000 	mov	r2, #0
30000a90:	e5832000 	str	r2, [r3]
	while(1){
		if((rGPGDAT & 0x1)==0)
30000a94:	e59f30bc 	ldr	r3, [pc, #188]	; 30000b58 <acoral_start+0xf0>
30000a98:	e5933000 	ldr	r3, [r3]
30000a9c:	e2033001 	and	r3, r3, #1
30000aa0:	e3530000 	cmp	r3, #0
30000aa4:	0a000000 	beq	30000aac <acoral_start+0x44>
30000aa8:	eafffff9 	b	30000a94 <acoral_start+0x2c>
        	break;
30000aac:	e1a00000 	nop			; (mov r0, r0)
		}
	rTCFG0 |= 0xF9;			/* prescaler等于249*/
30000ab0:	e3a03451 	mov	r3, #1358954496	; 0x51000000
30000ab4:	e5933000 	ldr	r3, [r3]
30000ab8:	e3a02451 	mov	r2, #1358954496	; 0x51000000
30000abc:	e38330f9 	orr	r3, r3, #249	; 0xf9
30000ac0:	e5823000 	str	r3, [r2]
 	rTCFG1 |= 0x3;			/*divider等于16*/
30000ac4:	e59f3090 	ldr	r3, [pc, #144]	; 30000b5c <acoral_start+0xf4>
30000ac8:	e5933000 	ldr	r3, [r3]
30000acc:	e59f2088 	ldr	r2, [pc, #136]	; 30000b5c <acoral_start+0xf4>
30000ad0:	e3833003 	orr	r3, r3, #3
30000ad4:	e5823000 	str	r3, [r2]
   	rTCNTB0 = 0X61A9;          		/*计数值25001*/
30000ad8:	e59f3080 	ldr	r3, [pc, #128]	; 30000b60 <acoral_start+0xf8>
30000adc:	e59f2080 	ldr	r2, [pc, #128]	; 30000b64 <acoral_start+0xfc>
30000ae0:	e5832000 	str	r2, [r3]
   	rTCON = rTCON & (~0xf) |0x02;           	/* 更新TCNT0*/
30000ae4:	e59f307c 	ldr	r3, [pc, #124]	; 30000b68 <acoral_start+0x100>
30000ae8:	e5933000 	ldr	r3, [r3]
30000aec:	e3c3300f 	bic	r3, r3, #15
30000af0:	e59f2070 	ldr	r2, [pc, #112]	; 30000b68 <acoral_start+0x100>
30000af4:	e3833002 	orr	r3, r3, #2
30000af8:	e5823000 	str	r3, [r2]
	rTCON = rTCON & (~0xf) |0x01; 	/* start定时器0*/
30000afc:	e59f3064 	ldr	r3, [pc, #100]	; 30000b68 <acoral_start+0x100>
30000b00:	e5933000 	ldr	r3, [r3]
30000b04:	e3c3300f 	bic	r3, r3, #15
30000b08:	e59f2058 	ldr	r2, [pc, #88]	; 30000b68 <acoral_start+0x100>
30000b0c:	e3833001 	orr	r3, r3, #1
30000b10:	e5823000 	str	r3, [r2]
	while(1){
		if(rTCNTO0 == 1)		/*倒计时到1，两秒*/
30000b14:	e59f3050 	ldr	r3, [pc, #80]	; 30000b6c <acoral_start+0x104>
30000b18:	e5933000 	ldr	r3, [r3]
30000b1c:	e3530001 	cmp	r3, #1
30000b20:	0a000000 	beq	30000b28 <acoral_start+0xc0>
30000b24:	eafffffa 	b	30000b14 <acoral_start+0xac>
        	break;
30000b28:	e1a00000 	nop			; (mov r0, r0)
		}
	rGPBCON = 0x400;			
30000b2c:	e59f303c 	ldr	r3, [pc, #60]	; 30000b70 <acoral_start+0x108>
30000b30:	e3a02b01 	mov	r2, #1024	; 0x400
30000b34:	e5832000 	str	r2, [r3]
	rGPBDAT = 0x1C0; 			//点亮LED
30000b38:	e59f3034 	ldr	r3, [pc, #52]	; 30000b74 <acoral_start+0x10c>
30000b3c:	e3a02d07 	mov	r2, #448	; 0x1c0
30000b40:	e5832000 	str	r2, [r3]
	while(1);
30000b44:	eafffffe 	b	30000b44 <acoral_start+0xdc>
30000b48:	4c000014 	.word	0x4c000014
30000b4c:	4c000004 	.word	0x4c000004
30000b50:	0007f021 	.word	0x0007f021
30000b54:	56000060 	.word	0x56000060
30000b58:	56000064 	.word	0x56000064
30000b5c:	51000004 	.word	0x51000004
30000b60:	5100000c 	.word	0x5100000c
30000b64:	000061a9 	.word	0x000061a9
30000b68:	51000008 	.word	0x51000008
30000b6c:	51000014 	.word	0x51000014
30000b70:	56000010 	.word	0x56000010
30000b74:	56000014 	.word	0x56000014

30000b78 <HAL_INTR_ENTRY>:
   .global     HAL_INTR_DISABLE_SAVE
   .global     HAL_INTR_RESTORE
   .extern     IRQ_stack

HAL_INTR_ENTRY:
    stmfd   sp!,    {r0-r12,lr}           @保护通用寄存器及PC 
30000b78:	e92d5fff 	push	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    mrs     r1,     spsr
30000b7c:	e14f1000 	mrs	r1, SPSR
    stmfd   sp!,    {r1}                  @保护spsr,以支持中断嵌套
30000b80:	e92d0002 	stmfd	sp!, {r1}

    msr     cpsr_c, #SVC_MODE|NOIRQ        @进入SVC_MODE,以便允许中断嵌套
30000b84:	e321f093 	msr	CPSR_c, #147	; 0x93
    stmfd   sp!,    {lr}                  @保存SVc模式的专用寄存器lr
30000b88:	e92d4000 	stmfd	sp!, {lr}

    ldr     r0,     =INTOFFSET 		  @读取中断向量号
30000b8c:	e59f008c 	ldr	r0, [pc, #140]	; 30000c20 <HAL_INTR_DISABLE_SAVE+0x20>
    ldr     r0,     [r0]
30000b90:	e5900000 	ldr	r0, [r0]
    mov     lr,    pc                     @求得lr的值
30000b94:	e1a0e00f 	mov	lr, pc
    bl .    @//TODO ldr     pc,    =hal_all_entry 
30000b98:	ebfffffe 	bl	30000b98 <HAL_INTR_ENTRY+0x20>

    ldmfd   sp!,    {lr}                    @恢复svc模式下的lr,
30000b9c:	e8bd4000 	ldmfd	sp!, {lr}
    msr     cpsr_c,#IRQ_MODE|NOINT       @更新cpsr,进入IRQ模式并禁止中断
30000ba0:	e321f0d2 	msr	CPSR_c, #210	; 0xd2
    ldmfd   sp!,{r0}                    @spsr->r0
30000ba4:	e8bd0001 	ldmfd	sp!, {r0}
    msr     spsr_cxsf,r0                @恢复spsr
30000ba8:	e16ff000 	msr	SPSR_fsxc, r0
    ldmfd   sp!,{r0-r12,lr}
30000bac:	e8bd5fff 	pop	{r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
    subs    pc,lr,#4                    @此后，中断被重新打开
30000bb0:	e25ef004 	subs	pc, lr, #4

30000bb4 <EXP_HANDLER>:

EXP_HANDLER:
	stmfd   sp!,{lr}                @保护寄存器,以及返回地址
30000bb4:	e92d4000 	stmfd	sp!, {lr}
	mov     r0,sp  
30000bb8:	e1a0000d 	mov	r0, sp
	stmfd   r0!,{sp}^               @出错线程的SP_sys压入exp中断栈中
30000bbc:	e9602000 	stmdb	r0!, {sp}^
	ldmfd   r0!,{r1}                @从exp中断栈中读取 SP_sys->R1
30000bc0:	e8b00002 	ldm	r0!, {r1}
	mov     r0,lr
30000bc4:	e1a0000e 	mov	r0, lr
	bl .    @//TODO  bl acoral_fault_entry
30000bc8:	ebfffffe 	bl	30000bc8 <EXP_HANDLER+0x14>
	ldmfd   sp!,{lr}                  @从exp中断栈中读取 SP_sys->R1
30000bcc:	e8bd4000 	ldmfd	sp!, {lr}
	subs pc,lr,#0
30000bd0:	e25ef000 	subs	pc, lr, #0

30000bd4 <HAL_INTR_ENABLE>:

HAL_INTR_ENABLE:
    mrs r0,cpsr
30000bd4:	e10f0000 	mrs	r0, CPSR
    bic r0,r0,#NOINT
30000bd8:	e3c000c0 	bic	r0, r0, #192	; 0xc0
    msr cpsr_cxsf,r0
30000bdc:	e12ff000 	msr	CPSR_fsxc, r0
    mov pc,lr
30000be0:	e1a0f00e 	mov	pc, lr

30000be4 <HAL_INTR_DISABLE>:

HAL_INTR_DISABLE:
    mrs r0,cpsr
30000be4:	e10f0000 	mrs	r0, CPSR
    mov r1,r0
30000be8:	e1a01000 	mov	r1, r0
    orr r1,r1,#NOINT
30000bec:	e38110c0 	orr	r1, r1, #192	; 0xc0
    msr cpsr_cxsf,r1
30000bf0:	e12ff001 	msr	CPSR_fsxc, r1
    mov pc ,lr
30000bf4:	e1a0f00e 	mov	pc, lr

30000bf8 <HAL_INTR_RESTORE>:

HAL_INTR_RESTORE:
	MSR     CPSR_c, R0
30000bf8:	e121f000 	msr	CPSR_c, r0
	MOV     PC, LR
30000bfc:	e1a0f00e 	mov	pc, lr

30000c00 <HAL_INTR_DISABLE_SAVE>:

HAL_INTR_DISABLE_SAVE:
	MRS     R0, CPSR				@ Set IRQ and FIable all interrupts
30000c00:	e10f0000 	mrs	r0, CPSR
	ORR     R1, R0, #0xC0
30000c04:	e38010c0 	orr	r1, r0, #192	; 0xc0
	MSR     CPSR_c, R1
30000c08:	e121f001 	msr	CPSR_c, r1
	MRS     R1, CPSR				@ Confirm that Cpt disable flags
30000c0c:	e10f1000 	mrs	r1, CPSR
	AND     R1, R1, #0xC0
30000c10:	e20110c0 	and	r1, r1, #192	; 0xc0
	CMP     R1, #0xC0
30000c14:	e35100c0 	cmp	r1, #192	; 0xc0
	BNE     HAL_INTR_DISABLE_SAVE			@ Not properly dsabled (try again)
30000c18:	1afffff8 	bne	30000c00 <HAL_INTR_DISABLE_SAVE>
	MOV     PC, LR					@ Disabled, return thcontents in R0
30000c1c:	e1a0f00e 	mov	pc, lr
    ldr     r0,     =INTOFFSET 		  @读取中断向量号
30000c20:	4a000014 	.word	0x4a000014
