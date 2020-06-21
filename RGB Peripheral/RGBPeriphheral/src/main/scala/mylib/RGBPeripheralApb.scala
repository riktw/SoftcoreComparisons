package demo

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc._
import scala.util.Random

class Apb3RGB(config : Apb3Config, prescaler : Int, baseAddress : BigInt) extends Component {
    val io = new Bundle {
        val apb = slave(Apb3(config))
        val red = out Bool
        val green = out Bool
        val blue = out Bool
    }
    
    io.red := True
    io.green := True
    io.blue := True
    
    val Apb3Factory = Apb3SlaveFactory(io.apb)
    val rgbReg = Reg(UInt(32 bits)) init (0)
    Apb3Factory.driveAndRead(rgbReg, baseAddress + 0)
    
    val redValue, greenValue, blueValue = UInt(8 bits)
    redValue := rgbReg(23 downto 16)
    greenValue := rgbReg(15 downto 8)
    blueValue := rgbReg(7 downto 0)
    
    val redCounter, greenCounter, blueCounter = Reg(UInt(8 bits)) init 0
    val prescalerReg = Reg(UInt(32 bits)) init 0
    
    prescalerReg := prescalerReg + 1
    
    when(prescalerReg === prescaler){
        prescalerReg := 0
    
        redCounter := redCounter + 1
        greenCounter := greenCounter + 1
        blueCounter := blueCounter + 1
    }
    
    when(redCounter > redValue){
        io.red := False
    }
    when(greenCounter > greenValue){
        io.green := False
    }
    when(blueCounter > blueValue){
        io.blue := False
    }
    
}

//Generate the MyTopLevel's VHDL
object Apb3RGBVhdl {
  def main(args: Array[String]) {
    val apbconf = new Apb3Config(32,32); 
    SpinalVhdl(new Apb3RGB(apbconf, 10, 0x0000000))
  }
}
