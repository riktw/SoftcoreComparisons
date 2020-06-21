#include "uart.h"

#define RGBBASE 0xFFFFFF80
#define HW_RGB(x) *(volatile unsigned int *)(RGBBASE+x)

int main(int argc, char **argv)
{
	puts("Hello, world from ZPU!\n");
    unsigned int rgbval = 0x0000000F;
	// Now echo any characters received back down the line.
	while(1)
    {
      HW_RGB(0) = rgbval;
      
      rgbval = rgbval << 1;
      if(rgbval >= 0x0f000000)
      {
        rgbval = 0x0000000F;
      }
      
      
      int i = 0;
      for(i = 0; i < 2000000; ++i)
      {
      }
      
    }
	

	return(0);
}

