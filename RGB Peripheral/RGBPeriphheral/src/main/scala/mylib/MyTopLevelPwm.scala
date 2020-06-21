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

class WishboneRGB(config : WishboneConfig, prescaler : Int) extends Component {
    val io = new Bundle {
        val wb = slave(Wishbone(config))
        val red = out Bool
        val green = out Bool
        val blue = out Bool
    }
    
    io.red := True
    io.green := True
    io.blue := True
    
    val wishboneFactory = WishboneSlaveFactory(io.wb)
    val rgbReg = Reg(UInt(32 bits)) init (0)
    wishboneFactory.driveAndRead(rgbReg, 4)
    
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

//Generate the MyTopLevel's Verilog
object WishboneRGBVerilog {
  def main(args: Array[String]) {
    val wbconf = new WishboneConfig(32,32); 
    SpinalVerilog(new WishboneRGB(wbconf, 10))
  }
}

//Generate the MyTopLevel's VHDL
object WishboneRGBVhdl {
  def main(args: Array[String]) {
    val wbconf = new WishboneConfig(32,32); 
    SpinalVhdl(new WishboneRGB(wbconf, 10))
  }
}

