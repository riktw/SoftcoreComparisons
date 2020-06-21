#include <stdint.h>
#include <stdbool.h>
#include "io.h"
#include "my_printf.h"
#include "console.h"
#define TIMER_BASE	0xc0004000

volatile int *timer = (volatile int *) TIMER_BASE;
#define HELLO_WORLD "Hello World from PowerPC!!\r\n"

#define TEST1 "Booting..."

#define TEST2 "Done!"

#define TESTPF "Printf?..."

int main(void)
{
	potato_uart_init();
    
    putstr(TEST1, strlen(TEST1));
    
    dbg_printf(TESTPF);

    dbg_printf("Time: %u\r\n", readw(TIMER_BASE));
    
	dbg_printf(HELLO_WORLD);
    
    dbg_printf("Time: %u\r\n", readw(TIMER_BASE));
    
    putstr(TEST2, strlen(TEST2));

	while (1) {
		unsigned char c = getchar();
		putchar(c);
	}
}
