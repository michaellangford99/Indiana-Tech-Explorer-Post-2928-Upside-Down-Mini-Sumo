CON
   
  _CLKMODE = XTAL1 + PLL16X
  _CLKFREQ = 80_000_000

OBJ
                                
  pst : "Parallax Serial Terminal"  
  ir  : "IRSensors"
  m   : "motor_control"
  pins : "pin_numbers"
  
var

long fbits[3], ir_f
long bbits[3], ir_b
long lbits[3], ir_l
long rbits[3], ir_r

PUB Main
            
  pst.Start(115_200)
  ir.start(8)
  m.start

  
  repeat
    pst.home
    waitcnt(clkfreq/50 + cnt)
                                                         
    ir.IrDetect(pins#F_0,pins#F_1,pins#F_2)
    fbits[0] := ir.GetIR(1)                                  
    fbits[1] := ir.GetIR(2)  << 1                            
    fbits[2] := ir.GetIR(3)  << 2                             
    ir_f.byte[0]:=fbits[0] + fbits[1] + fbits[2]

    ir.IrDetect(pins#B_0,pins#B_1,pins#B_2)
    bbits[0] := ir.GetIR(1)                                  
    bbits[1] := ir.GetIR(2)  << 1                            
    bbits[2] := ir.GetIR(3)  << 2                           
    ir_b.byte[0]:=bbits[0] + bbits[1] + bbits[2]

    ir.IrDetect(pins#L_0,pins#L_1,pins#L_2)
    lbits[0] := ir.GetIR(1)                                 
    lbits[1] := ir.GetIR(2)  << 1                           
    lbits[2] := ir.GetIR(3)  << 2                            
    ir_l.byte[0]:=lbits[0] + lbits[1] + lbits[2]

    ir.IrDetect(pins#R_0,pins#R_1,pins#R_2)
    rbits[0] := ir.GetIR(1)                                 
    rbits[1] := ir.GetIR(2)  << 1                            
    rbits[2] := ir.GetIR(3)  << 2                             
    ir_r.byte[0]:=rbits[0] + rbits[1] + rbits[2]

    pst.str(string("front: "))
    pst.bin(ir_f, 3)
    pst.newline

    pst.str(string("back : "))
    pst.bin(ir_b, 3)
    pst.newline

    pst.str(string("left : "))
    pst.bin(ir_l, 3)
    pst.newline

    pst.str(string("right: "))
    pst.bin(ir_r, 3)
    pst.newline
                 
    {
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
    