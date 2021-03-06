'Propeller Sumo Five IR

CON

  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  Ir : "SquareWave.spin"
  pst : "Parallax Serial Terminal"

VAR

  long state, ir_input

PUB main
  
  ir_input := %00000
  pst.Start(115200)
                
repeat 
  ir_input.byte[0] := sensor_check(16, 18)
  ir_input.byte[1] := sensor_check(16, 20)
  ir_input.byte[2] := sensor_check(16, 22)
  ir_input.byte[3] := sensor_check(16, 24)
  ir_input.byte[4] := sensor_check(16, 26)
  pst.clear
  pst.dec(ir_input.byte[0])
  pst.dec(ir_input.byte[1])
  pst.dec(ir_input.byte[2])
  pst.dec(ir_input.byte[3])
  pst.dec(ir_input.byte[4])                             
  
PRI sensor_check(rpin, tpin) 

  Ir.freq(0, tpin, 38500)
  dira[tpin]~
  dira[tpin]~~
  waitcnt(clkfreq/1000 + cnt)
  dira[rpin]~
  state := ina[rpin]
  dira[tpin]~
  return state

PRI logic(data)

  case data
    %0 :   