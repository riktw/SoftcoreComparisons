package demo

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.misc._
import scala.util.Random

class Zpu3RGB(prescaler : Int, baseAddress : BigInt) extends Component {
    val io = new Bundle {
        val mem_addr = in Bits(8 bits)
        val mem_data = in Bits(32 bits)
        val mem_enable = in Bool
        val red = out Bool
        val green = out Bool
        val blue = out Bool
    }
    
    io.red := True
    io.green := True
    io.blue := True
    
    val rgbReg = Reg(UInt(32 bits)) init (0)

    when(io.mem_enable === True){
      when(io.mem_addr.asUInt === (baseAddress + 0)){
        rgbReg := io.mem_data.asUInt
      }
    }
    
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
object Zpu3RGBVhdl {
  def main(args: Array[String]) {
    SpinalVhdl(new Zpu3RGB(10, 0x0000000))
  }
}
