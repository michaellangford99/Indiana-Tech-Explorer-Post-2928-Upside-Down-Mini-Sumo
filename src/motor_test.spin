CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
  
   
OBJ
   m : "motor_control"
  
PUB Main | x

    m.start
   
   repeat x from 0 to 127
    m.set(x,x)
    waitcnt(clkfreq/50+cnt)

   repeat x from 127 to 0
    m.set(x,x)
    waitcnt(clkfreq/50+cnt)

   repeat x from 0 to -127
    m.set(x,x)
    waitcnt(clkfreq/50+cnt)

   repeat x from -127 to 0
    m.set(x,x)
    waitcnt(clkfreq/50+cnt)

   
   repeat
    m.set(0,0)
   

     