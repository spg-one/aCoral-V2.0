SHELL=cmd
TOPDIR=$(shell echo %cd%)

ACORAL_INCLUDE_DIR= -Ihal/include


LD              = arm-none-eabi-ld
GCC             = arm-none-eabi-gcc
OBJCOPY         = arm-none-eabi-objcopy
OBJDUMP         = arm-none-eabi-objdump

#LINKFLAGS =-Bstatic -Ttext 0x1
LINKFLAGS =-Bstatic -Tacoral.lds

CORE_FILES=hal/src/start.o acoral.o

export TOPDIR

O_TARGET:=hal/src/start.o hal/src/ch1.o hal/src/hal_int_s.o hal/src/hal_nand.o

acoral:acoral.bin

acoral.bin:$(O_TARGET)
	$(LD) $(LINKFLAGS)  -g $^ -o acoral.elf
	$(OBJCOPY) -O binary -S acoral.elf acoral.bin
	$(OBJDUMP) -S acoral.elf > acoral.d 
	$(OBJDUMP) -t acoral.elf > acoral.t 
	$(OBJDUMP) -x acoral.elf > acoral.x 

%.o:%.c
	$(GCC) $(ACORAL_INCLUDE_DIR) -g -c -o $@ $<

%.o:%.S
	$(GCC) $(ACORAL_INCLUDE_DIR) -g -c -o $@ $<	

clean:
	del acoral.bin acoral.elf *.o /F/Q/S 
#del hal/src/start.o /F/Q 

.PHONY: test

test:
	@echo $(O_TARGET)

