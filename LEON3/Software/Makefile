CFLAGS = -g -I $(BASE)/Inc -m32 -Wall -Wextra

CROSS_BASE:=/opt/sparc-elf-3.4.4
CROSS_PREFIX:=sparc-gaisler-elf

all:	example_program dhrystone customPeripheral


# The Dhrystone code performs a 64-bit division in the end
# Extract the relevant object files from libc, and link with JUST them.
_udivdi3.o:
	{ ar xv ${CROSS_BASE}/lib/gcc/sparc-elf/3.4.4*/v8/libgcc.a _udivdi3.o _clz.o ; } || exit 0

dhrystone-common:	dhrystone
	${CROSS_PREFIX}-strip $<
	${CROSS_PREFIX}-size $<

dhrystone:	dhrystone.c my_printf.c
	${CROSS_PREFIX}-gcc -mcpu=leon3 -O3 -DMAIN=main -o $@ $^ 
	$(MAKE) dhrystone-common

dhrystone-small:	dhrystone.c my_printf.c | _udivdi3.o
	${CROSS_PREFIX}-gcc -nostdlib -mcpu=leon3 -O2 -DMAIN=start -o $@ $^ _udivdi3.o _clz.o
	mv $@ dhrystone
	$(MAKE) dhrystone-common

example_program:	example_program.c my_printf.c
	${CROSS_PREFIX}-gcc -mcpu=leon3 -Os -DMAIN=main -o $@ $^ 
	# ${CROSS_PREFIX}-gcc -nostdlib -mcpu=leon3 -O2 -DMAIN=start -o $@ $^
	${CROSS_PREFIX}-strip $@
	${CROSS_PREFIX}-size $@
	
customPeripheral:	customPeripheral.c my_printf.c
	${CROSS_PREFIX}-gcc -mcpu=leon3 -O0 -g -DMAIN=main -o $@ $^ 
	# ${CROSS_PREFIX}-gcc -nostdlib -mcpu=leon3 -O2 -DMAIN=start -o $@ $^
	${CROSS_PREFIX}-strip $@
	${CROSS_PREFIX}-size $@

mand:	mand.c
	${CROSS_PREFIX}-gcc -mcpu=leon3 -O2 -msoft-float -o $@ $^ 
	${CROSS_PREFIX}-strip $@
	${CROSS_PREFIX}-size $@

mand-run:	mand
	bash -c '/opt/grmon-eval-3.1.0/linux/bin64/grmon -u -xilusb -c <(echo -e "load mand\nrun\nquit\n")'

%.o:	%.c
	${CC} -c ${CFLAGS} -o $@ $<

clean:
	rm -f example_program customPeripheral dhrystone _clz.o _udivdi3.o mand
