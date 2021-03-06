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

VAR

  long speeda
  long speedb
  
CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000  

PUB TestPwm | tc, tHa, tHb, t, c, spa, spb

  ctra[30..26] := ctrb[30..26] := %00100     ' Counters A and B → NCO single-ended
  ctra[5..0] := 0                            ' Set pins for counters to control
  ctrb[5..0] := 1       
  frqa := frqb := 1                          ' Add 1 to phs with each clock tick
                         
  dira[0] := dira[1] := 1                    ' Set I/O pins to output
  dira[2] := dira[3] := 1

  speeda := 0
  speedb := 0                                   
  
  repeat
    
    if speeda < 0
      ctra[5..0] := 2
      spa := -speeda
      outa[0] := 0
    else
      ctra[5..0] := 0
      spa := speeda
      outa[2] := 0
                                
    if speedb < 0
      ctrb[5..0] := 3
      spb := -speedb
      outa[1] := 0
    else
      ctrb[5..0] := 1
      spb := speedb
      outa[3] := 0  
    
    
    tC := clkfreq/10000                            ' Set up cycle time
    tHa := tc - (100 - spa)*(tc/100)                       ' Set up high times for both signals
    tHb := tc - (100 - spb)*(tc/100)       '--
    t := cnt                                       ' Mark current time.   
    phsa := -tHa                                   ' Define and start the A pulse
    phsb := -tHb                                   ' Define and start the B pulse
    t += tC                                        ' Calculate next cycle repeat
    waitcnt(t)                                     ' Wait for next cycle

Pub setmotors(s1, s2)

  speeda := s1
  speedb := s2
  