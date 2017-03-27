CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ
                                
  pst : "Parallax Serial Terminal"  
  ir  : "IRSensors"
  
var

long irfbits[3], irrf

PUB Main
            
  pst.Start(115_200)
  ir.start(8)
  repeat
    pst.home
    'pst.dec(9)
    'waitcnt(clkfreq/50 + cnt)
    ir.IrDetect(13,14,15)

      irfbits[0] := ir.GetIR(1)                                  '=
      irfbits[1] := ir.GetIR(2)  << 1                            '=
      irfbits[2] := ir.GetIR(3)  << 2                            '= <<<< SENSORS SECTION 
      irrf.byte[0]:=irfbits[0] + irfbits[1] + irfbits[2]
    
    pst.bin(irrf, 3)
    