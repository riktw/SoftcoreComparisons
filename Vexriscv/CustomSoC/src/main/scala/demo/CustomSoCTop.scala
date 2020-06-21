package demo

import spinal.core._
import vexriscv.demo._


object JaebSoCWithRamInit{
  def main(args: Array[String]) {
    SpinalVerilog(JaebSoC(JaebSoCConfig.default.copy(
      onChipRamSize = 32 kB, 
      coreFrequency = 100 MHz, 
      gpioWidth = 8, 
      onChipRamHexFile = "src/main/hex/dhrystone.hex")
      ))
  }
}
