package mylib

import spinal.core._
import spinal.sim._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._
import scala.util.Random


//MyTopLevel's testbench
object MyTopLevelPwmSim {
  def main(args: Array[String]) {
    val wbconf = new WishboneConfig(16,32); 
    SimConfig.withWave.doSim(new WishboneRGB(wbconf, 4)){dut =>
      //Fork a process to generate the reset and the clock on the dut
      dut.clockDomain.forkStimulus(period = 10)
      
      def wb = dut.io.wb

      def wbWrite(address : BigInt, data : BigInt) : Unit = {
        wb.ADR #= address
        wb.DAT_MOSI #= data
        wb.WE #= true
        wb.CYC #= true
        wb.STB #= true
        dut.clockDomain.waitSamplingWhere(wb.ACK.toBoolean)
        wb.ADR #= 0
        wb.DAT_MOSI #= 0
        wb.WE #= false
        wb.CYC #= false
        wb.STB #= false
        dut.clockDomain.waitSampling()
      }

      def wbReadImpl(address : BigInt) : BigInt = {
        wb.ADR #= address
        wb.WE #= false
        wb.CYC #= true
        wb.STB #= true
        dut.clockDomain.waitSamplingWhere(wb.ACK.toBoolean)
        wb.ADR  #= 0
        wb.WE #= false
        wb.CYC #= false
        wb.STB #= false
        wb.DAT_MISO.toBigInt
      }

      
      
      dut.clockDomain.waitSampling(1)
      
      def testSetA : Unit = {
        wbWrite(4, 0)
        dut.clockDomain.waitSampling(5000)
        wbWrite(4, 0x00804020)
        dut.clockDomain.waitSampling(5000)
      }
      
      testSetA
      
    }
  }
}
