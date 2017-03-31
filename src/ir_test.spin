CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ
                                
  pst : "Parallax Serial Terminal"  
  ir  : "IRSensors"
  m   : "motor_control"
  
var

long irfbits[3], irrf

PUB Main
            
  'pst.Start(115_200)
  ir.start(8)
  m.start
  repeat
    'pst.home
    'pst.dec(9)
    waitcnt(clkfreq/50 + cnt)                                                       
    ir.IrDetect(13,14,15)

      irfbits[0] := ir.GetIR(1)                                  '=
      irfbits[1] := ir.GetIR(2)  << 1                            '=
      irfbits[2] := ir.GetIR(3)  << 2                            '= <<<< SENSORS SECTION 
      irrf.byte[0]:=irfbits[0] + irfbits[1] + irfbits[2]
    
    'pst.bin(irrf, 3)

    '{
    case irrf
        %000: m.set(-15, -15)
        %011: m.set(0, -15)
        %110: m.set(-15, 0)
        %010: m.set(-15,-15)
        %101: m.set(-15,-15)
        %100: m.set(-15,0)
        %001: m.set(0,-15)
        %111: m.set(-15,15)
        other: m.set(0,0)

        '}
    