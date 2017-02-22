{Gyroscope for mazebot ver 1.0}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

VAR
  long x_, y_, z_

  long a, b, c, d, stack, left_servo, right_servo, gyro_return
   
OBJ
  pst      : "Parallax Serial Terminal"
  gyro     : "Gtest"
  servo    : "Servo32v7 "

Pub Main

  servo.start
  
  repeat
      filter
    
    
PUB cycle
waitcnt(clkfreq/100 + cnt)
pst.Start(115_200)
gyro.startup

cognew(s, @stack[2000])

repeat
  waitcnt(clkfreq/6000+cnt)
  gyro.main
  a:= b
  b:= c
  c:= d
  d:= gyro.getz/100

  z_ := (a+(2*b)+(2*c)+d)/6


pub s

  repeat
    waitcnt(clkfreq/100+cnt)
    pst.clear
    pst.dec(z_)

pri filter

   gyro_return := z_
   if gyro_return >= 0
   