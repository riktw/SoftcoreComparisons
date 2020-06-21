package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.io.TriStateArray
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._

class WishboneRAM(config : WishboneConfig, offset : Int, ramWords : Int) extends Component{
  val io = new Bundle{
    val wb = slave(Wishbone(config))
  }

	val addrNoOffset = (io.wb.ADR - offset) >> 2
	val wordRange = (log2Up(ramWords) - 1) downto 0
	val mem = Mem(Bits(config.dataWidth bits),wordCount = ramWords)
	val ackReg = RegInit(False)
	
	when(io.wb.CYC && io.wb.STB){
		ackReg := True;
	}.elsewhen(ackReg === True){
		ackReg := False;
	}
	
	io.wb.ACK := ackReg
	
	mem.write(
		enable  = io.wb.CYC && io.wb.STB && io.wb.WE,
		address = addrNoOffset(wordRange),
		data    = io.wb.DAT_MOSI
	)
	
	io.wb.DAT_MISO := mem.readSync(
		enable  = (io.wb.CYC && io.wb.STB && !io.wb.WE),
		address = addrNoOffset(wordRange)
	)

}
