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
  Pulsout    : "Servo32v7 "
  
VAR
    Long stack, ir_results, state, state2, stateofpin, speed
    word seecounter, no_see_counter, servospeed0, servospeed1
    
'PUB Start

'seecounter := 0
'no_see_counter := 0
'
'Pulsout.Start
'sensor

Pub start

Pulsout.Start

sensor
Pub sensor

  if seecounter >=4
    seecounter := 4
  if no_see_counter >=4
    seecounter := 4
  waitcnt(clkfreq/30 + cnt)
  SqrWave.Freq(0, 3, 25000)                ' 38 kHz signal → P1
  dira[3]~                                 ' Set I/O pin to input when no signal needed
  dira[3]~~                                ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
  state := ina[4]                          ' Store I/R detector output
  dira[3]~                                 ' I/O pin → input to stop signal

  waitcnt(clkfreq/30 + cnt)
  SqrWave.Freq(0, 2, 25000)                ' 38 kHz signal → P1
  dira[2]~                                 ' Set I/O pin to input when no signal needed
  dira[2]~~                                ' I/O pin → output to transmit 38 kHz
  waitcnt(clkfreq/1000 + cnt)              ' Wait 1 ms
  state2 := ina[5]                          ' Store I/R detector output
  dira[2]~      
  
  outa[18] := state           ' display right sensor input
  dira[18] := state
  outa[19] := state2
  dira[19] := state2

  if state2 == 0
    seecounter := 0
    no_see_counter := 0
    set_servo_speed(2000, 2000)
      
  
  if state == 0
    seecounter := seecounter + 1
    if seecounter <=3
        servospeed0 := 1000
        servospeed1 := 1850
    if seecounter >3
        servospeed0 := 1000
        servospeed1 := 0
        seecounter := 4
    set_servo_speed(servospeed0, servospeed1)

  if state == 1
    no_see_counter := no_see_counter + 1
    if no_see_counter <= 3
        servospeed0 := 1400
        servospeed1 := 2000
    if no_see_counter > 3
        servospeed0 := 0
        servospeed1 := 2000
        no_see_counter := 4
    set_servo_speed(servospeed0, servospeed1)


Pub set_servo_speed(speed0, speed1)

  Pulsout.Set(0, speed0)
  Pulsout.Set(1, speed1)

sensor
    