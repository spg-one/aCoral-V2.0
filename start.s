.text
.global _start
_start:      
      	@ disable watch dog timer
	mov	r1, #0x53000000
	mov	r2, #0x0
	str	r2, [r1]
	ldr    pc,=main
