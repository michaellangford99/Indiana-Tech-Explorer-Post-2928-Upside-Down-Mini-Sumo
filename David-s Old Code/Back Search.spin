{Back Search
Written By David Langford}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR

  long  back_input, state
   
OBJ
  Freqout      : "SquareWave"
  
PUB Back_Search(freq_pin, r1, r2, r3, r4, r5)

repeat 
    state := sensor_check(freq_pin, r1)
    back_input := state 
    state := sensor_check(freq_pin, r2)
    back_input := state >> 1
    state := sensor_check(freq_pin, r3)
    back_input := state >> 2
    state := sensor_check(freq_pin, r4)
    back_input := state >> 3
    state := sensor_check(freq_pin, r5)
    back_input := state >> 4

PRI sensor_check(rpin, tpin) 
                               
    Freqout.freq(0, tpin, 38500)
    dira[tpin]~
  
    dira[tpin]~~
    waitcnt(clkfreq/1000 + cnt)
    dira[rpin]~
    state := ina[rpin]
    dira[tpin]~
    return state

PUB get_ir

  return back_input
