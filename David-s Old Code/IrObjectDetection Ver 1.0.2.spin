''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
'' IrObjectDetection.spin
'' Detect objects with IR LED and receiver and display with Parallax Serial Terminal.

{{                                                  schematic by David Langford

          220 Ω 
     └─────┐    IR emitter circuit
     ┌─────────┘
     

          _
     └────||
     ┌────||)         IR reciever circuit
      ──||  (+ ── )
     
}}

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000

OBJ
   
  SqrWave    : "SquareWave"
  SqrWave2   : "SquareWave2"

VAR

long stack
  
PUB IrDetect | state

  cognew(Ir2Detect, @stack[200])
  'Start 38 kHz square wave  
  SqrWave.Freq(0, 1, 38500)                  ' 38 kHz signal → P1  
  dira[1]~                                   ' Set I/O pin to input when no signal needed

  repeat
    
   ' Detect object.
    dira[1]~~                                ' I/O pin → output to transmit 38 kHz
    waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
    state := ina[0]                          ' Store I/R detector output
    dira[1]~                                 ' I/O pin → input to stop signal
    dira[16] := state
    outa[16] := state

PUB Ir2Detect | state2

  'Start 38 kHz square wave  
  SqrWave2.Freq(0, 25, 38500)                  ' 38 kHz signal → P1
  dira[25]~                                   ' Set I/O pin to input when no signal needed

  repeat
    
   ' Detect object.
    dira[25]~~                                ' I/O pin → output to transmit 38 kHz
    waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
    state2 := ina[24]                          ' Store I/R detector output
    dira[25]~                                 ' I/O pin → input to stop signal
    dira[17] := state2
    outa[17] := state2
    