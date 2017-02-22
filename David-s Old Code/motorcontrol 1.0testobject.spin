{Object_Title_and_Purpose}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
   
OBJ
  mc : "motorcontrol 1.0"
  
PUB Main

  mc.init


Pub speed(speeda, speedb)

  mc.speed(-200, -200)
    