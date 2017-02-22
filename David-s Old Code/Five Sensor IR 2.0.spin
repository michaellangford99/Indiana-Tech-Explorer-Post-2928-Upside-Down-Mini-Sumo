'Propeller Sumo Five IR

CON

  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  Ir : "SquareWave.spin"
  pst : "Parallax Serial Terminal"
  serout : "TestDualPWM"
  
VAR

  long state, ir_input, motor_sequence, ir_case, motora, motorb, stack

PUB main

  ir_input := %00000
  pst.Start(115200)
    
repeat
  ir_input.byte[0] := sensor_check(16, 18)
  ir_input.byte[1] := sensor_check(16, 20)
  ir_input.byte[2] := sensor_check(16, 22)
  ir_input.byte[3] := sensor_check(16, 24)
  ir_input.byte[4] := sensor_check(16, 26)
  'pst.clear
  'pst.dec(ir_input.byte[0])
  'pst.dec(ir_input.byte[1])
  'pst.dec(ir_input.byte[2])
  'pst.dec(ir_input.byte[3])
  'pst.dec(ir_input.byte[4])

  ir_case.byte[0] := ir_input.byte[1]
  ir_case.byte[1] := ir_input.byte[2]
  ir_case.byte[2] := ir_input.byte[3]
  motora := motorb := 200
  logic_handler(ir_case)
  pst.clear
  pst.dec(motor_sequence)                               
  serout.speed(motora, motorb)
  
PRI sensor_check(rpin, tpin) 
                               
  Ir.freq(0, tpin, 38500)
  dira[tpin]~
  dira[tpin]~~
  waitcnt(clkfreq/1000 + cnt)
  dira[rpin]~
  state := ina[rpin]
  dira[tpin]~
  return state

PRI logic_handler(data)

  case data
    %000000010000000100000001 : motor_sequence := 0
    %000000010000000100000000 : motor_sequence := 1
    %000000010000000000000001 : motor_sequence := 2
    %000000010000000000000000 : motor_sequence := 3
    %000000000000000100000001 : motor_sequence := 4
    %000000000000000100000000 : motor_sequence := 5
    %000000000000000000000001 : motor_sequence := 6
    %000000000000000000000000 : motor_sequence := 7
                               motora := 100
                               motorb := 100
    