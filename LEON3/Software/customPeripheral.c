#include "my_printf.h"



int MAIN()
{
    volatile int *console = (volatile int *) 0x80000100;
    volatile int *rgbled = (volatile int *) 0x80000500;
    console[3] = 651;   //Set baud to 19200
    dbg_printf("Hello world from LEON3!\n");
    
    unsigned int rgbval = 0x0000000f;
    
    while(1)
    {
      
      for(int i = 0; i < 1000000; i++){
        
      }
      rgbled[0] = rgbval;
      rgbval = rgbval << 1;
      if(rgbval > 0xf000000){
        rgbval = 0x0000000f;
      }
    }
}
