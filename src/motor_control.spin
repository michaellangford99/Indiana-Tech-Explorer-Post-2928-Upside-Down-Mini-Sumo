CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        reset=6
        serout=7
        baud=9600

        
        
VAR
   long stack[500], s1, s2, d1, d2
   
OBJ
    serial : "FUllDuplexSerial"
    
PUB Start
   serial.Start(31, serout, %0000, baud)

   dira[reset]~~
   outa[reset] := 0

   waitcnt(clkfreq/100+cnt)

   outa[reset] := 1

   waitcnt(clkfreq/100+cnt)
   
   cognew(Motors, @stack)

PUB Motors

repeat
    'waitcnt(clkfreq/100+cnt)
    'motor 1
    serial.tx(d1)
    serial.tx(s1)       
    'waitcnt(clkfreq/100+cnt)
    'motor 2
    serial.tx(d2)
    serial.tx(s2)
    
PUB Set(sp1, sp2)

 sp1 := -sp1

 if sp1 > -1
   s1 := sp1
   d1 := 0
 else
   s1 := -sp1
   d1 := 1

 if sp2 > -1
   s2 := sp2
   d2 := 2
 else
   s2 := -sp2
   d2 := 3