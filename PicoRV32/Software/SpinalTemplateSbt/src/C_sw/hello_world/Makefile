USE_MYSTDLIB = 1
OBJS = main.o my_printf.o stdlib.o
CFLAGS = -MD -O0 -march=rv32i -DTIME -DRISCV
TOOLCHAIN_PREFIX = /opt/riscv32im/bin/riscv32-unknown-elf-

ifeq ($(USE_MYSTDLIB),1)
CFLAGS += -DUSE_MYSTDLIB -ffreestanding -nostdlib
OBJS += start.o
else
OBJS += syscalls.o
endif

hello.bin: hello.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@	
	
hello.hex: hello.elf
	$(TOOLCHAIN_PREFIX)objcopy -O ihex $< $@

ifeq ($(USE_MYSTDLIB),1)
hello.elf: $(OBJS) sections.lds
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -Wl,-Bstatic,-T,sections.lds,-Map,hello.map,--strip-debug -o $@ $(OBJS) -lgcc
	chmod -x $@
else
hello.elf: $(OBJS)
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -Wl,-Bstatic,-T,../firmware/riscv.ld,-Map,hello.map,--strip-debug -o $@ $(OBJS) -lgcc -lc
	chmod -x $@
endif

	
%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<

%.o: %.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<

hello_1.o hello_2.o: CFLAGS += -Wno-implicit-int -Wno-implicit-function-declaration

clean:
	rm -rf *.o *.d hello.elf hello.map hello.bin hello.hex

.PHONY: test clean

-include *.d

