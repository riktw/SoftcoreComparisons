#ifndef TIMERCTRL_H_
#define TIMERCTRL_H_

#include <stdint.h>

typedef struct
{
  volatile uint32_t IRQ;
  volatile uint32_t COUNTER;
  volatile uint32_t DIVIDER;
  volatile uint32_t SETTINGS;
} Timer_Reg;

static void timer_setup(Timer_Reg *reg, uint32_t divider, uint32_t counter)
{
  reg->COUNTER = counter;
  reg->DIVIDER = divider;
}

static void timer_start(Timer_Reg *reg)
{
  reg->SETTINGS = 0x01;
}

static uint8_t timer_done(Timer_Reg *reg)
{
  return(reg->SETTINGS == 0x09);
}

static void timer_reset(Timer_Reg *reg)
{
  reg->SETTINGS = 0x04;
}


#endif /* TIMERCTRL_H_ */
