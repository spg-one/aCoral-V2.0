
LD              = arm-none-eabi-ld
GCC              = arm-none-eabi-gcc
OBJCOPY         = arm-none-eabi-objcopy
OBJDUMP         = arm-none-eabi-objdump

LINKFLAGS =-Bstatic -Ttext 0




acoral:acoral.bin

acoral.bin:start.s ch1.c
	$(GCC) -g -c start.s
	$(GCC) -g -c ch1.c
	$(LD) $(LINKFLAGS) -g start.o ch1.o -o acoral.elf
	$(OBJCOPY) -O binary -S acoral.elf acoral.bin
	$(OBJDUMP) -S acoral.elf > acoral.d 
	$(OBJDUMP) -t acoral.elf > acoral.t 
	$(OBJDUMP) -x acoral.elf > acoral.x 
clean:
	del acoral.bin acoral.elf *.o /F/Q 

