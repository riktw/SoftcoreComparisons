package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.io.TriStateArray
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._

class WishboneTest(config : WishboneConfig, offset : Int) extends Component{
  val io = new Bundle{
    val wb = slave(Wishbone(config))
    val charOut = out Bits(8 bits)
    val updateOut = out Bool
  }

	val ackReg = RegInit(False)
	
	when(io.wb.CYC && io.wb.STB){
		ackReg := True;
	}.elsewhen(ackReg === True){
		ackReg := False;
	}
	
	io.wb.ACK := ackReg
	
	io.updateOut := False
	io.charOut := B"x00"
	
	io.wb.DAT_MISO := B"x00000000"
	
	when(io.wb.CYC && io.wb.STB && io.wb.WE){
      when(io.wb.ADR === offset){
        io.updateOut := True
        io.charOut := io.wb.DAT_MOSI(7 downto 0)
      }
	}

}
