#ifndef UART_H_
#define UART_H_
#include <stdint.h>

typedef struct
{
  volatile uint32_t CLOCK_DIVIDER;
  volatile uint32_t SETTINGS;
  volatile uint32_t WRITE;
  volatile uint32_t WRITE_READY;
  volatile uint32_t READ_VALID;
  volatile uint32_t READ;
} Uart_Reg;

enum UartParity {NONE = 0,EVEN = 1,ODD = 2};
enum UartStop {ONE = 0,TWO = 1};

typedef struct {
	uint32_t dataLength;
	enum UartParity parity;
	enum UartStop stop;
	uint32_t clockDivider;
} Uart_Config;


static uint32_t uart_writeAvailability(Uart_Reg *reg){
	return (reg->WRITE_READY) & 0xFF;
}
static uint32_t uart_readOccupancy(Uart_Reg *reg){
	return reg->READ_VALID;
}

static void uart_write(Uart_Reg *reg, uint32_t data){
	while(uart_writeAvailability(reg) == 1);
	reg->WRITE = data;
}

static void uart_applyConfig(Uart_Reg *reg, Uart_Config *config){
	reg->CLOCK_DIVIDER = config->clockDivider;
	reg->SETTINGS = ((config->dataLength-1) << 0) | (config->parity << 8) | (config->stop << 16);
}

#endif /* UART_H_ */


