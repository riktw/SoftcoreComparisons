ARCH = $(shell uname -m)
ifneq ("$(ARCH)", "ppc64")
ifneq ("$(ARCH)", "ppc64le")
	CROSS_COMPILE ?= powerpc64le-linux-gnu-
endif
endif

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy

CFLAGS = -O3 -g -Wall -std=c99 -msoft-float -mno-string -mno-multiple -mno-vsx -mno-altivec -mlittle-endian -fno-stack-protector -mstrict-align -ffreestanding -fdata-sections -ffunction-sections -I../include
ASFLAGS = $(CFLAGS)
LDFLAGS = -T powerpc.lds

all: dhry.hex

dhry.elf: dhrystone.o head.o console.o my_printf.o 
	$(LD) $(LDFLAGS) -o $@ $^

dhry.bin: dhry.elf
	$(OBJCOPY) -O binary $^ $@

dhry.hex: dhry.bin
	../scripts/bin2hex.py $^ > $@

clean:
	@rm -f *.o dhry.elf dhry.bin dhry.hex
