LED:ch1.bin

ch1.bin:start.s ch1.c
	arm-none-eabi-gcc -g -c start.s
	arm-none-eabi-gcc -g -c ch1.c
	arm-none-eabi-ld -Ttext 0x00000000 -g start.o ch1.o -o ch1.elf
	arm-none-eabi-objcopy -O binary -S ch1.elf ch1.bin
clean:
	del ch1.bin ch1.elf *.o /F/Q 

