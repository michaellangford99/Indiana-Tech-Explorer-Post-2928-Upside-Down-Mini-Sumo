''This code example is from Propeller Education Kit Labs: Fundamentals, v1.2.
''A .pdf copy of the book is available from www.parallax.com, and also through
''the Propeller Tool software's Help menu (v1.2.6 or newer).
''
{{
TestDualPWM.spin
Demonstrates using two counter modules to send a dual PWM signal.
The cycle time is the same for both signals, but the high times are independent of 
each other.
}}

var

long x

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000  

PUB speed(speeda, speedb) | tc, tHa, tHb, t, c

  ctra[30..26] := ctrb[30..26] := %00100     ' Counters A and B → NCO single-ended
  ctra[5..0] := 0                            ' Set pins for counters to control
  ctrb[5..0] := 1       
  frqa := frqb := 1                          ' Add 1 to phs with each clock tick
                         
  dira[0] := dira[1] := 1                    ' Set I/O pins to output

  x := 0
  repeat until x <=10000
    tC := clkfreq/10000                            ' Set up cycle time
    tHa := tc - (100 - speeda)*(tc/100)                       ' Set up high times for both signals
    tHb := tc - (100 - speedb)*(tc/100)       '--
    t := cnt                                       ' Mark current time.   
    phsa := -tHa                                   ' Define and start the A pulse
    phsb := -tHb                                   ' Define and start the B pulse
    t += tC                                        ' Calculate next cycle repeat
    waitcnt(t)                                     ' Wait for next cycle
    x := x + 1

  return  