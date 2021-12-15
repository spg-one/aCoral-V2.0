
acoral.elf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <_start>:
.text
.global _start
_start:      
      	@ disable watch dog timer
	mov	r1, #0x53000000
   0:	e3a01453 	mov	r1, #1392508928	; 0x53000000
	mov	r2, #0x0
   4:	e3a02000 	mov	r2, #0
	str	r2, [r1]
   8:	e5812000 	str	r2, [r1]
	ldr    pc,=main
   c:	e51ff004 	ldr	pc, [pc, #-4]	; 10 <_start+0x10>
  10:	00000014 	.word	0x00000014

00000014 <main>:
#include"ch1.h"

int main(){
  14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
  18:	e28db000 	add	fp, sp, #0
	rCLKDIVN = 0X5;	
  1c:	e59f30e0 	ldr	r3, [pc, #224]	; 104 <main+0xf0>
  20:	e3a02005 	mov	r2, #5
  24:	e5832000 	str	r2, [r3]
	rMPLLCON = (0X7f<<12) | (0X2<<4) | (0X1);
  28:	e59f30d8 	ldr	r3, [pc, #216]	; 108 <main+0xf4>
  2c:	e59f20d8 	ldr	r2, [pc, #216]	; 10c <main+0xf8>
  30:	e5832000 	str	r2, [r3]
	rGPGCON = 0;			//检测按键状态
  34:	e59f30d4 	ldr	r3, [pc, #212]	; 110 <main+0xfc>
  38:	e3a02000 	mov	r2, #0
  3c:	e5832000 	str	r2, [r3]
	while(1){
		if((rGPGDAT & 0x1)==0)
  40:	e59f30cc 	ldr	r3, [pc, #204]	; 114 <main+0x100>
  44:	e5933000 	ldr	r3, [r3]
  48:	e2033001 	and	r3, r3, #1
  4c:	e3530000 	cmp	r3, #0
  50:	0a000000 	beq	58 <main+0x44>
  54:	eafffff9 	b	40 <main+0x2c>
        	break;
  58:	e1a00000 	nop			; (mov r0, r0)
		}
	rTCFG0 |= 0xF9;			/* prescaler等于249*/
  5c:	e3a03451 	mov	r3, #1358954496	; 0x51000000
  60:	e5933000 	ldr	r3, [r3]
  64:	e3a02451 	mov	r2, #1358954496	; 0x51000000
  68:	e38330f9 	orr	r3, r3, #249	; 0xf9
  6c:	e5823000 	str	r3, [r2]
 	rTCFG1 |= 0x3;			/*divider等于16*/
  70:	e59f30a0 	ldr	r3, [pc, #160]	; 118 <main+0x104>
  74:	e5933000 	ldr	r3, [r3]
  78:	e59f2098 	ldr	r2, [pc, #152]	; 118 <main+0x104>
  7c:	e3833003 	orr	r3, r3, #3
  80:	e5823000 	str	r3, [r2]
   	rTCNTB0 = 0X61A9;          		/*计数值25001*/
  84:	e59f3090 	ldr	r3, [pc, #144]	; 11c <main+0x108>
  88:	e59f2090 	ldr	r2, [pc, #144]	; 120 <main+0x10c>
  8c:	e5832000 	str	r2, [r3]
   	rTCON = rTCON & (~0xf) |0x02;           	/* 更新TCNT0*/
  90:	e59f308c 	ldr	r3, [pc, #140]	; 124 <main+0x110>
  94:	e5933000 	ldr	r3, [r3]
  98:	e3c3300f 	bic	r3, r3, #15
  9c:	e59f2080 	ldr	r2, [pc, #128]	; 124 <main+0x110>
  a0:	e3833002 	orr	r3, r3, #2
  a4:	e5823000 	str	r3, [r2]
	rTCON = rTCON & (~0xf) |0x01; 	/* start定时器0*/
  a8:	e59f3074 	ldr	r3, [pc, #116]	; 124 <main+0x110>
  ac:	e5933000 	ldr	r3, [r3]
  b0:	e3c3300f 	bic	r3, r3, #15
  b4:	e59f2068 	ldr	r2, [pc, #104]	; 124 <main+0x110>
  b8:	e3833001 	orr	r3, r3, #1
  bc:	e5823000 	str	r3, [r2]
	while(1){
		if(rTCNTO0 == 1)		/*倒计时到1，两秒*/
  c0:	e59f3060 	ldr	r3, [pc, #96]	; 128 <main+0x114>
  c4:	e5933000 	ldr	r3, [r3]
  c8:	e3530001 	cmp	r3, #1
  cc:	0a000000 	beq	d4 <main+0xc0>
  d0:	eafffffa 	b	c0 <main+0xac>
        	break;
  d4:	e1a00000 	nop			; (mov r0, r0)
		}
	rGPBCON = 0x400;			
  d8:	e59f304c 	ldr	r3, [pc, #76]	; 12c <main+0x118>
  dc:	e3a02b01 	mov	r2, #1024	; 0x400
  e0:	e5832000 	str	r2, [r3]
	rGPBDAT = 0x1C0; 			//点亮LED
  e4:	e59f3044 	ldr	r3, [pc, #68]	; 130 <main+0x11c>
  e8:	e3a02d07 	mov	r2, #448	; 0x1c0
  ec:	e5832000 	str	r2, [r3]
  f0:	e3a03000 	mov	r3, #0
}
  f4:	e1a00003 	mov	r0, r3
  f8:	e28bd000 	add	sp, fp, #0
  fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
 100:	e12fff1e 	bx	lr
 104:	4c000014 	.word	0x4c000014
 108:	4c000004 	.word	0x4c000004
 10c:	0007f021 	.word	0x0007f021
 110:	56000060 	.word	0x56000060
 114:	56000064 	.word	0x56000064
 118:	51000004 	.word	0x51000004
 11c:	5100000c 	.word	0x5100000c
 120:	000061a9 	.word	0x000061a9
 124:	51000008 	.word	0x51000008
 128:	51000014 	.word	0x51000014
 12c:	56000010 	.word	0x56000010
 130:	56000014 	.word	0x56000014
