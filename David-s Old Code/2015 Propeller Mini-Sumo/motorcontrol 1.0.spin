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

CON
   
  _clkmode = xtal1 + pll16x                  ' System clock → 80 MHz
  _xinfreq = 5_000_000  

VAR

long speeda, speedb, stack1[500], stack2[1500], sa, sb

PUB init

  cognew(run1, @stack1)
  cognew(run2, @stack2)
  return

PUB run1 | tc1, tHa1, t1, c1

  ctra[30..26] := %00100     ' Counters A and B → NCO single-ended
  ctra[5..0] := 12                            ' Set pins for counters to control
  frqa := 1                          ' Add 1 to phs with each clock tick
                         
  dira[12] := 1                    ' Set I/O pins to output
  dira[13] := 0

  repeat
    if speeda < 0
      ctra[30..26] := %00100
      ctra[5..0] := 13                            ' Set pins for counters to control
      frqa := 1                          ' Add 1 to phs with each clock tick                        
      dira[13] := 1                    ' Set I/O pins to output
      dira[12] := 0
      sa := -speeda                  'negate speed
    else
      ctra[30..26] := %00100
      ctra[5..0] := 12                            ' Set pins for counters to control
      frqa := 1                          ' Add 1 to phs with each clock tick                        
      dira[12] := 1                    ' Set I/O pins to output
      dira[13] := 0
      sa := speeda


  
    tC1 := clkfreq/10000                            ' Set up cycle time
    tHa1 := tc1 - (100 - sa)*(tc1/100)          ' Set up high times for both signals
    t1 := cnt                                       ' Mark current time.   
    phsa := -tHa1                                   ' Define and start the A pulse
    t1 += tC1                                        ' Calculate next cycle repeat
    waitcnt(t1)                                     ' Wait for next cycle


PUB run2 | tc2, tHb2, t2, c2

  ctra[30..26] := %00100     ' Counters A and B → NCO single-ended
  ctra[5..0] := 14                            ' Set pins for counters to control       
  frqa := 1                          ' Add 1 to phs with each clock tick
                         
  dira[14] := 1                    ' Set I/O pins to output
  dira[15] := 0

  repeat
    if speedb < 0
      ctra[30..26] := %00100
      ctra[5..0] := 15                            ' Set pins for counters to control
      frqa := 1                          ' Add 1 to phs with each clock tick                        
      dira[15] := 1                    ' Set I/O pins to output
      dira[14] := 0
      sb := -speedb                  'negate speed
    else
      ctra[30..26] := %00100
      ctra[5..0] := 14                            ' Set pins for counters to control
      frqa := 1                          ' Add 1 to phs with each clock tick                        
      dira[14] := 1                    ' Set I/O pins to output
      dira[15] := 0
      sb := speedb



  
    tC2 := clkfreq/10000                            ' Set up cycle time    
    tHb2 := tc2 - (100 - sb)*(tc2/100)       ' Set up high times for both signals 
    t2 := cnt                                       ' Mark current time.
    phsa := -tHb2                                   ' Define and start the B pulse
    t2 += tC2                                        ' Calculate next cycle repeat
    waitcnt(t2)                                     ' Wait for next cycle

PUB speed(getspeeda, getspeedb)

  speeda := -getspeeda
  speedb := getspeedb
    