SHELL=cmd
TOPDIR=$(shell echo %cd%)

ACORAL_INCLUDE_DIR= -Iinclude


LD              = arm-none-eabi-ld
GCC             = arm-none-eabi-gcc
OBJCOPY         = arm-none-eabi-objcopy
OBJDUMP         = arm-none-eabi-objdump

#LINKFLAGS =-Bstatic -Ttext 0x1
LINKFLAGS =-Bstatic -Tacoral.lds

CORE_FILES=hal/src/start.o acoral.o

export TOPDIR

O_TARGET:=hal/start.o hal/hal_int_s.o hal/hal_nand.o \
		  kernel/core.o

acoral: clean acoral.bin

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

readHeader:
	gcc read_header.c -o read_header.exe

test:
	gcc spg1.c -c -o spg1.o
	gcc spg2.c -c -o spg2.o
	ld spg1.o spg2.o -o spg.exe
	