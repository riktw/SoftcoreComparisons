#ifndef GPIO_H_
#define GPIO_H_

typedef struct
{
  volatile uint32_t INPUT;
  volatile uint32_t OUTPUT;
  volatile uint32_t OUTPUT_ENABLE;
} Gpio_Reg;

//input is 0 for gpio as output, anything else for gpio as input
static void gpio_setdirection(Gpio_Reg *reg, uint8_t pinNumber, uint8_t input)
{
  if(input == 0)
  {
    reg->OUTPUT_ENABLE &= ~(1 << pinNumber);
  }
  else
  {
    reg->OUTPUT_ENABLE |= (1 << pinNumber);
  }
}

static uint8_t gpio_readpin(Gpio_Reg *reg, uint8_t pinNumber)
{
  return (uint8_t)(reg->INPUT & (1 << pinNumber));
}

//data is 0 for low, anything else for high
static void gpio_writepin(Gpio_Reg *reg, uint8_t pinNumber, uint8_t data)
{
  if(data == 0)
  {
    reg->OUTPUT &= ~(1 << pinNumber);
  }
  else
  {
    reg->OUTPUT |= (1 << pinNumber);
  }
}


#endif /* GPIO_H_ */


