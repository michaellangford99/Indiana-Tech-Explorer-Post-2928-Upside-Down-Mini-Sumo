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
  SqrWave2    : "SquareWave"  

VAR
    Long stack, stack2, ir_results, state, state2

PUB IrDetect
  
repeat
  SqrWave.Freq(0, 1, 38000)
  
                    ' 38 kHz signal → P1
  dira[1]~                                   ' Set I/O pin to input when no signal needed

  dira[1]~~                                ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
  state := ina[0]                          ' Store I/R detector output
  dira[1]~                                 ' I/O pin → input to stop signal
  ir_results.byte := state
    
  'Start 38 kHz square wave
  SqrWave2.Freq(1, 3, 38000)
                    ' 38 kHz signal → P1
  dira[3]~                                   ' Set I/O pin to input when no signal needed

  dira[3]~~                                ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
  state2 := ina[2]                          ' Store I/R detector output
  ir_results.byte[1] := state2
  dira[3]~                                 ' I/O pin → input to stop signal
  outa[16..17] := %11
  dira[16..17] := ir_results
  waitcnt(clkfreq/100 + cnt)       'play around with this value