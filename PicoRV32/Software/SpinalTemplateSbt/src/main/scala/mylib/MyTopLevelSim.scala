package mylib

import spinal.core._
import spinal.sim._
import spinal.core.sim._

import scala.util.Random

//MyTopLevel's testbench
object MyTopLevelSim {
  def main(args: Array[String]) {
    SimConfig.withWave.doSim(new MyTopLevel){dut =>
      //Fork a process to generate the reset and the clock on the dut
      dut.clockDomain.forkStimulus(period = 10)
      dut.io.uart.rxd #= true
      var changedChar = false
      var modelState = 0
      for(idx <- 0 to 99999){

        dut.clockDomain.waitRisingEdge()
        if(dut.io.flag.toBoolean == true && changedChar == false){
          print(dut.io.charOut.toInt.toChar)
          changedChar = true;
        }
        if(dut.io.flag.toBoolean == false){
          changedChar = false;
        }
      }
    }
  }
}
