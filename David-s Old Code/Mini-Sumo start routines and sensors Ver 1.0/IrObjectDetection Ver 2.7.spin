''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' IrObjectDetection.spin
'' Detect objects with IR LED and receiver and display with Parallax Serial Terminal.

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ

  SqrWave    : "SquareWave"
  
VAR
    Long stack, ir_results, state1, state2, state3, state
    
PUB Start

dira[17..19]~~
cognew(IR_LEFT, @stack[20])
cognew(IR_MIDDLE, @stack[40])
cognew(IR_RIGHT, @stack[60])
cognew(IR_HANDLER, @stack[80])

PUB IR_LEFT

repeat   
  SqrWave.Freq(0, 9, 38000)                ' 38 kHz signal → P1
  dira[9]~                                 ' Set I/O pin to input when no signal needed
  !dira[9]                                 ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
  state1 := ina[8]                          ' Store I/R detector output
  !dira[9]                                 ' I/O pin → input to stop signal
  
PUB IR_MIDDLE

repeat    
  'Start 38 kHz square wave
  SqrWave.Freq(0, 11, 38000)                ' 38 kHz signal → P3                    
  dira[11]~                                 ' Set I/O pin to input when no signal needed
  dira[11]~~                                ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)               ' Wait 1 ms
  state2 := ina[10]                         ' Store I/R detector output
  dira[11]~                                 ' I/O pin → input to stop signal

PUB IR_RIGHT
repeat
  SqrWave.Freq(0, 13, 38000)
  dira[13]~
  dira[13]~~
  waitcnt(clkfreq/1000 + cnt)
  state3 := ina[12]
  dira[13]~

PUB IR_HANDLER

repeat
  dira[17..19]~~ 
  ir_results.byte[2] := state1
  ir_results.byte[0] := state2
  ir_results.byte[1] := state3
  outa[17] := ir_results.byte[0]            ' display left sensor input
  outa[18] := ir_results.byte[1]            ' display right sensor input
  outa[19] := ir_results.byte[2]

 case ir_results                          'spin equivalent of branch
   %000  : state  := 23                   'if both see, turn led on p23 on
   %111  : state  := 22
   other : state  := 21                   'otherwise turn led on p22 on

 dira[state] := 1
 outa[state] := 1
 waitcnt(clkfreq/1000 + cnt)
 dira[21..23]~       