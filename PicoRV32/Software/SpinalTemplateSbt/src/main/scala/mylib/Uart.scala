package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._
import spinal.lib.bus.wishbone._


class WishboneUart(config : WishboneConfig, offset : Int) extends Component{
  val io = new Bundle{
    val wb = slave(Wishbone(config))
    val uart = master(Uart())
  }
  
  val clockDivWidth = 16
  val uartCtrlConfig = UartCtrlGenerics(8, clockDivWidth, 1, 5, 2)
  val uartCtrl = new UartCtrl(uartCtrlConfig)
  io.uart <> uartCtrl.io.uart

  val wbCtrl = WishboneSlaveFactory(io.wb)
  val clockDivRegsNeeded = uartCtrl.io.config.clockDivider.getWidth / config.dataWidth;
  
  val clockDivReg = Reg(UInt(clockDivWidth bit)) init(0)  //needed to get an empty register, else tests fail as clockdiv is random
  
  if(clockDivRegsNeeded != 0){
    for(cnt <- 1 to clockDivRegsNeeded){
      val dataWidthInBytes = (config.dataWidth / 8)
      wbCtrl.readAndWrite(clockDivReg.subdivideIn(config.dataWidth bits)(cnt-1), (offset + 0) + (dataWidthInBytes*(cnt-1)))
    }
  }else{
    wbCtrl.readAndWrite(clockDivReg, offset + 0)
  }
  
  uartCtrl.io.config.clockDivider := clockDivReg
  uartCtrl.io.writeBreak := False
  uartCtrl.io.read.ready := True
  
  val uartDataToWrite, uartDataAccepted = Reg(Bool) init(False)
  val uartWriteData = wbCtrl.createWriteOnly(Bits(8 bits), offset + 8)
  wbCtrl.onWrite(offset + 8){
    uartDataToWrite := True
    uartDataAccepted := False
  }
  when(uartCtrl.io.write.ready === False){
    uartDataAccepted := True
  }
  when(uartCtrl.io.write.ready === True && uartDataAccepted === True){
    uartDataToWrite := False
  }
  
  val uartDataAvailable = Reg(Bool) init(False)
  val uartDataRead = Reg(Bits(8 bits)) init(0)
  
  when(uartCtrl.io.read.valid === True){
    uartDataRead := uartCtrl.io.read.payload
    uartDataAvailable := True
  }
  
  uartCtrl.io.write.valid := uartDataToWrite
  uartCtrl.io.write.payload := uartWriteData
  wbCtrl.driveAndRead(uartCtrl.io.config.frame, offset + 4)
  wbCtrl.read(uartDataToWrite, offset + 12)
  wbCtrl.read(uartDataAvailable , offset + 16)
  wbCtrl.read(uartDataRead, offset + 20)
  wbCtrl.onRead(offset + 20){
    uartDataAvailable := False
  }

}
