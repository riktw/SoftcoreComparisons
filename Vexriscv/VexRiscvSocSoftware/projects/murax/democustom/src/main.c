#include <stdint.h>

#include <murax.h>

typedef struct
{
  volatile uint32_t RGBValue;
} RGB_Reg;

#define RGB      ((RGB_Reg*)(0xF0030000))

void main() {
	volatile uint32_t a = 1, b = 2, c = 3;
	uint32_t result = 0;
    
    char hello[] = "Hello world from VexRiscv\n";

	interruptCtrl_init(TIMER_INTERRUPT);
	prescaler_init(TIMER_PRESCALER);
	timer_init(TIMER_A);

	TIMER_PRESCALER->LIMIT = 12000-1; //1 ms rate

	TIMER_A->LIMIT = 1000-1;  //1 second rate
	TIMER_A->CLEARS_TICKS = 0x00010002;

	TIMER_INTERRUPT->PENDINGS = 0xF;
	TIMER_INTERRUPT->MASKS = 0x1;

	GPIO_A->OUTPUT_ENABLE = 0x000000FF;
	GPIO_A->OUTPUT = 0x00000000;
    
    RGB->RGBValue = 0x000000F;
	
	
	for(int i = 0; i < sizeof(hello); ++i)
    {
      UART->DATA = hello[i];
      while(!uart_writeAvailability(UART));
    }

	while(1){
		result += a;
		result += b + c;
		for(uint32_t idx = 0;idx < 500000;idx++) asm volatile("");
		GPIO_A->OUTPUT = (GPIO_A->OUTPUT & ~0x3F) | ((GPIO_A->OUTPUT + 1) & 0x3F);  //Counter on LED[5:0]
        
        RGB->RGBValue = RGB->RGBValue << 2;
        if(RGB->RGBValue >= 0xF0000000)
        {
          RGB->RGBValue = 0x000000F;
        }
	}
}

void irqCallback(){
	if(TIMER_INTERRUPT->PENDINGS & 1){  //Timer A interrupt
		GPIO_A->OUTPUT ^= 0x80; //Toogle led 7
		TIMER_INTERRUPT->PENDINGS = 1;
	}
}



