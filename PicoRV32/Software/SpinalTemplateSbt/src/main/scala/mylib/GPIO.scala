package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.io.TriStateArray
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._

class WishboneGpio(config : WishboneConfig, offset : Int, gpioWidth : Int) extends Component{
  val io = new Bundle{
    val wb = slave(Wishbone(config))
    val gpio = master(TriStateArray(gpioWidth bits))
  }

  val ctrl = WishboneSlaveFactory(io.wb)

  ctrl.read(io.gpio.read, offset + 0)
  ctrl.driveAndRead(io.gpio.write, offset + 4)
  ctrl.driveAndRead(io.gpio.writeEnable, offset + 8)
  io.gpio.writeEnable.getDrivingReg init(0)
}
