/*
 * SpinalHDL
 * Copyright (c) Dolu, All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library.
 */

package mylib

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._
import scala.util.Random

//TODO: separate file
class picorv32_wb(
  enableCounters: Boolean,
  enableCounters64: Boolean,
  enableRegs16_32: Boolean,
  enableRegsDualport: Boolean,
  twoStageShift: Boolean,
  barrelShifter: Boolean,
  twoCycleCompare: Boolean,
  twoCycleAlu: Boolean,
  enableCompressed: Boolean,
  catchMisalign: Boolean,
  catchIlligalInstruction: Boolean,
  enablePcpi: Boolean,
  enableMul: Boolean,
  enableFastMul: Boolean,
  enableDiv: Boolean,
  enableIrq: Boolean,
  enableIrqQregs: Boolean,
  enableIrqTimer: Boolean,
  enableTrace: Boolean,
  regsInitZero: Boolean,
  maskedIrq: Int,
  latchedIrq: Int,
  progAddressReset: Int,
  progAddressIrq: Int,
  stackAddress: Int
  ) extends BlackBox {
  val generic = new Generic {
    val ENABLE_COUNTERS = picorv32_wb.this.enableCounters 
    val ENABLE_COUNTERS64 = picorv32_wb.this.enableCounters64
    val ENABLE_REGS_16_31 = picorv32_wb.this.enableRegs16_32
    val ENABLE_REGS_DUALPORT = picorv32_wb.this.enableRegsDualport
    val TWO_STAGE_SHIFT = picorv32_wb.this.twoStageShift
    val BARREL_SHIFTER = picorv32_wb.this.barrelShifter
    val TWO_CYCLE_COMPARE = picorv32_wb.this.twoCycleCompare
    val TWO_CYCLE_ALU = picorv32_wb.this.twoCycleAlu
    val COMPRESSED_ISA = picorv32_wb.this.enableCompressed
    val CATCH_MISALIGN = picorv32_wb.this.catchMisalign
    val CATCH_ILLINSN = picorv32_wb.this.catchIlligalInstruction
    val ENABLE_PCPI = picorv32_wb.this.enablePcpi
    val ENABLE_MUL = picorv32_wb.this.enableMul
    val ENABLE_FAST_MUL = picorv32_wb.this.enableFastMul
    val ENABLE_DIV = picorv32_wb.this.enableDiv
    val ENABLE_IRQ = picorv32_wb.this.enableIrq
    val ENABLE_IRQ_QREGS = picorv32_wb.this.enableIrqQregs
    val ENABLE_IRQ_TIMER = picorv32_wb.this.enableIrqTimer
    val ENABLE_TRACE = picorv32_wb.this.enableTrace
    val REGS_INIT_ZERO = picorv32_wb.this.regsInitZero
    val MASKED_IRQ = picorv32_wb.this.maskedIrq
    val LATCHED_IRQ = picorv32_wb.this.latchedIrq
    val PROGADDR_RESET = picorv32_wb.this.progAddressReset
    val PROGADDR_IRQ = picorv32_wb.this.progAddressIrq
    val STACKADDR = picorv32_wb.this.stackAddress
  }
  val io = new Bundle {
    val trap = out Bool
    
    val wb_rst_i = in Bool
    val wb_clk_i = in Bool
    val wbm_adr_o = out Bits(32 bits)
    val wbm_dat_o = out Bits(32 bits)
    val wbm_dat_i = in Bits(32 bits)
    val wbm_we_o = out Bool
    val wbm_sel_o = out Bits(4 bits)
    val wbm_stb_o = out Bool
    val wbm_ack_i = in Bool
    val wbm_cyc_o = out Bool
    
    val pcpi_valid = out Bool
    val pcpi_insn = out Bits(32 bits)
    val pcpi_rs1 = out Bits(32 bits)
    val pcpi_rs2 = out Bits(32 bits)
    val pcpi_wr = in Bool
    val pcpi_rd = in Bits(32 bits)
    val pcpi_wait = in Bool
    val pcpi_ready = in Bool
    
    val irq = in Bits(32 bits)
    val eoi = out Bits(32 bits)
    
    val trace_valid = out Bool
    val trace_data = out Bits(36 bits)
    
    val mem_instr = out Bool
  }

  noIoPrefix()
  
  addRTLPath("./src/verilog/picorv32.v")
}

class picorv32_wb_mapped extends Component {
  val io = new Bundle {
    val wbm = master(Wishbone(WishboneConfig(32, 32, 4)))
    val mem_instr = out Bool
    val irq = in Bits(32 bits)
    val eoi = out Bits(32 bits)
  }
  
  //TODO make nicer
  val picorv = new picorv32_wb(
    true, //  enableCounters 
    true, //  enableCounters64 
    true, //  enableRegs16_32 
    true, //  enableRegsDualport 
    true, //  twoStageShift 
    false, //  barrelShifter    //true for faster model
    false, //  twoCycleCompare 
    false, //  twoCycleAlu 
    false, //  enableCompressed   //true for faster model
    true, //  catchMisalign 
    true, //  catchIlligalInstruction 
    false, //  enablePcpi 
    false, //  enableMul         //true for faster model
    false, //  enableFastMul     //true for faster model
    false, //  enableDiv        //true for faster model
    false, //  enableIrq 
    true, //  enableIrqQregs 
    true, //  enableIrqTimer 
    false, //  enableTrace 
    false, //  regsInitZero 
    0x00000000, //  maskedIrq 
    0xffffffff, //  latchedIrq 
    0x00000000, //  progAddressReset 
    0x00000010, //  progAddressIrq 
    0xffffffff  //  stackAddress
  )
            
  
  picorv.io.pcpi_wr := False
  picorv.io.pcpi_rd := B"x00000000"
  picorv.io.pcpi_wait := False
  picorv.io.pcpi_ready := False
  picorv.io.irq := B"xFFFFFFFF"
  
  val rstn = Reg(Bool) init(True)
  
  val rstCounter = Counter(0 to 7)
  rstCounter.increment()
  when(rstCounter === 6){rstn := False}
  
  picorv.io.wb_rst_i := rstn
  picorv.io.wb_clk_i <> ClockDomain.current.readClockWire
  io.wbm.ADR <> picorv.io.wbm_adr_o.asUInt
  picorv.io.wbm_dat_o <> io.wbm.DAT_MOSI
  picorv.io.wbm_dat_i <> io.wbm.DAT_MISO
  picorv.io.wbm_we_o <> io.wbm.WE
  picorv.io.wbm_sel_o <> io.wbm.SEL
  picorv.io.wbm_stb_o <> io.wbm.STB
  picorv.io.wbm_ack_i <> io.wbm.ACK
  picorv.io.wbm_cyc_o <> io.wbm.CYC
  
}

class WishboneInterconComponent(config : WishboneConfig, decodings : Seq[SizeMapping]) extends Component{
  val io = new Bundle{
    val busMasters = Vec(slave(Wishbone(config)),1)
    val busSlaves = Vec(master(Wishbone(config)),decodings.size)
  }
  val intercon = new WishboneInterconFactory()
  val slaves = io.busSlaves zip decodings
  val masters = io.busMasters.map(_ -> io.busSlaves)

  for( slave <- slaves){
    intercon.addSlave(slave._1 , slave._2)
  }
  for( master <- masters){
    intercon.addMaster(master._1,master._2)
  }
}

import spinal.lib.io.TriStateArray
//Hardware definition
class MyTopLevel extends Component {
  val io = new Bundle {
    val flag  = out Bool
    val charOut = out Bits(8 bits)
    val uart = master(Uart())
    val gpio = master(TriStateArray(2 bits))
  }
  
  val wbROMOffset = 0x00000000
  val wbRAMOffset = 0x10000000
  val wbGPIOOffset = 0x11000000
  val wbTimerOffset = 0x12000000
  val wbUartOffset = 0x20000000
  
  val decodings = List((SizeMapping(wbROMOffset, 65535*4 Bytes)), 
                        (SizeMapping(wbRAMOffset, 1*4 Bytes)), 
                        (SizeMapping(wbUartOffset, 128 Bytes)),
                        (SizeMapping(wbTimerOffset, 128 Bytes)),
                        (SizeMapping(wbGPIOOffset, 128 Bytes)))
  
  val conf = new WishboneConfig(32,32, 4);
  val picorv = new picorv32_wb_mapped()
  val WBrom = new WishboneROM(conf, wbROMOffset, 32768, "src/C_sw/dhrystone/dhry.hex")
  val WBGPIO = new WishboneGpio(conf, wbGPIOOffset, 2)
  val WBTimer = new WishboneTimer(conf, wbTimerOffset)
  val WBUart = new WishboneUart(conf, wbUartOffset)
  val WBtest = new WishboneTest(conf, wbRAMOffset)
  
  val Wbint = new WishboneInterconComponent(conf, decodings )
  
  Wbint.io.busSlaves(0) >> WBrom.io.wb
  Wbint.io.busSlaves(1) >> WBtest.io.wb
  Wbint.io.busSlaves(2) >> WBUart.io.wb
  Wbint.io.busSlaves(3) >> WBTimer.io.wb
  Wbint.io.busSlaves(4) >> WBGPIO.io.wb
  Wbint.io.busMasters(0) << picorv.io.wbm

  picorv.io.irq := B"x00000000"
  io.flag := WBtest.io.updateOut
  io.charOut := WBtest.io.charOut
  io.uart <> WBUart.io.uart
  io.gpio <> WBGPIO.io.gpio
  
}

//Generate the MyTopLevel's Verilog
object MyTopLevelVerilog {
  def main(args: Array[String]) {
    val obj = SpinalVerilog(new MyTopLevel)
    obj.mergeRTLSource("mergeRTL")
  }
}

//Generate the MyTopLevel's VHDL
object MyTopLevelVhdl {
  def main(args: Array[String]) {
    SpinalVhdl(new MyTopLevel)
  }
}


//Define a custom SpinalHDL configuration with synchronous reset instead of the default asynchronous one. This configuration can be resued everywhere
object MySpinalConfig extends SpinalConfig(defaultConfigForClockDomains = ClockDomainConfig(resetKind = SYNC))

//Generate the MyTopLevel's Verilog using the above custom configuration.
object MyTopLevelVerilogWithCustomConfig {
  def main(args: Array[String]) {
    MySpinalConfig.generateVerilog(new MyTopLevel)
  }
}
