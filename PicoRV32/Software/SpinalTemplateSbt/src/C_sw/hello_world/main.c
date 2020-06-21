#include "../SocSoftware/uart.h"
#include "../SocSoftware/timer.h"
#include "../SocSoftware/gpio.h"
#include "../SocSoftware/SpinalPicorvSoc.h"
#include "my_printf.h"

char helloString[] = "Hello from PicoRV32!!!\n";

void putchar(char c)
{
  uart_write(UART1, c);
}

int main ()
{
  Uart_Config config;
  config.clockDivider = 651; //19200
  config.parity = 0;
  config.stop = 0;
  config.dataLength = 8;
  
  uart_applyConfig(UART1, &config);
  
  timer_setup(TIMER1, 10000, 5000);
  timer_start(TIMER1);
  gpio_setdirection(GPIO1, 0, 1);
  gpio_setdirection(GPIO1, 0, 2);
  
  dbg_printf(helloString);
  GPIO1->OUTPUT = 1;
  
  while(1)
  {
    if(timer_done(TIMER1))
    {
      GPIO1->OUTPUT = ~GPIO1->OUTPUT;
      timer_reset(TIMER1);
      timer_start(TIMER1);
      dbg_printf(".");
    }
  }
}



