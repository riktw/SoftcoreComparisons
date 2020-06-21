package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.io.TriStateArray
import spinal.lib.bus.wishbone._

case class Timer(width : Int) extends Component{
  val io = new Bundle{
    val tick      = in Bool
    val clear     = in Bool
    val limit     = in UInt(width bits)
    val divider   = in UInt(width bits)

    val full      = out Bool
    val value     = out UInt(width bits)
  }

  val counter = Reg(UInt(width bits)) init(0)
  val divider = Reg(UInt(width bits)) init(0)
  when(io.tick && !io.full){
    divider := divider + 1
  when(divider >= io.divider){
      counter := counter + 1
      divider := 0
    }
  }
  when(io.clear){
    counter := 0
    divider := 0
  }

  io.full := counter === io.limit && io.tick
  io.value := counter
}

class WishboneTimer(config : WishboneConfig, offset : Int) extends Component{
  val io = new Bundle{
    val wb = slave(Wishbone(config))
    val IRQ = out Bool
  }
  
  val timer = Timer(16)
  val settings = Reg(UInt(8 bit)) init(0)
  val counter = UInt(16 bits)
  val divider = UInt(16 bits)
  val counterRegsNeeded = counter.getWidth / config.dataWidth; 
  val dividerRegsNeeded = divider.getWidth / config.dataWidth;

  io.IRQ := (timer.io.full && settings(1))
  
  val ctrl = WishboneSlaveFactory(io.wb)
  ctrl.read(io.IRQ, offset + 0)
  ctrl.readAndWrite(settings, offset + 12)
  if(counterRegsNeeded != 0){
    for(cnt <- 1 to counterRegsNeeded){
      val dataWidthInBytes = (config.dataWidth / 8)
      ctrl.driveAndRead(counter.subdivideIn(config.dataWidth bits)(cnt-1), (offset + 4) + (dataWidthInBytes*(cnt-1)))
    }
  }else{
    ctrl.driveAndRead(counter, offset + 4)
  }
      
  
  if(dividerRegsNeeded != 0){
    for(cnt <- 1 to dividerRegsNeeded){
      val dataWidthInBytes = (config.dataWidth / 8)
      ctrl.driveAndRead(divider.subdivideIn(config.dataWidth bits)(cnt-1), (offset + 8) + (dataWidthInBytes*(cnt-1)))
    }
  }else{
    ctrl.driveAndRead(divider, offset + 8)
  }
  
  timer.io.limit := counter
  timer.io.divider := divider
  timer.io.clear := settings(2)
  timer.io.tick := settings(0)
  settings(3) := timer.io.full
}

