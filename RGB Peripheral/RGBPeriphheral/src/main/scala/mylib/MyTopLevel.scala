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
import spinal.lib.bus.wishbone._
import spinal.lib.bus.misc._
import scala.util.Random

class WishboneTimerBuffer(config : WishboneConfig, prescaler : Int) extends Component {
    val io = new Bundle {
        val wb = slave(Wishbone(config))
    }
    
    val wishboneFactory = WishboneSlaveFactory(io.wb)
    val timerReg = Reg(UInt(32 bits)) init (0)
    val prescalerReg = Reg(UInt(32 bits)) init (0)
    val prescalerValue = 
    wishboneFactory.read(timerReg, 0)
    
    prescalerReg := prescalerReg + 1
    when(prescalerReg === prescaler){
        timerReg := timerReg + 1
        prescalerReg := 0
    }

}

//Generate the MyTopLevel's Verilog
object MyTopLevelVerilog {
  def main(args: Array[String]) {
    val wbconf = new WishboneConfig(32,32); 
    SpinalVerilog(new WishboneTimerBuffer(wbconf, 10))
  }
}

//Generate the MyTopLevel's VHDL
object MyTopLevelVhdl {
  def main(args: Array[String]) {
    val wbconf = new WishboneConfig(32,32); 
    SpinalVhdl(new WishboneTimerBuffer(wbconf, 10))
  }
}

