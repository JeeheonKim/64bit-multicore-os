all: BootLoader.bin

BootLoader.bin: BootLoader0.asm
	nasm -o BootLoader.bin BootLoader.asm
	
clean:
	rm -f BootLoader.bin