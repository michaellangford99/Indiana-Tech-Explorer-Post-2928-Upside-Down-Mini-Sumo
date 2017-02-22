{Object_Title_and_Purpose}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR

  long  ir_input
   
OBJ
  Freqout      : "SquareWave"
  
PUB Front_Search(freq_pin, r1, r2, r3, r4, r5)

repeat 
    state := sensor_check(freq_pin, r1)
    ir_input := state 
    state := sensor_check(freq_pin, r2)
    ir_input := state >> 1
    state := sensor_check(freq_pin, r3)
    ir_input := state >> 2
    state := sensor_check(freq_pin, r4)
    ir_input := state >> 3
    state := sensor_check(freq_pin, r5)
    ir_input := state >> 4

PRI sensor_check(rpin, tpin) 
                               
    Ir.freq(0, tpin, 38500)
    dira[tpin]~
  
    dira[tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    dira[rpin]~
    state := ina[rpin]
    dira[tpin]~
    return state

PUB get_ir

  return ir_input
