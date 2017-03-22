CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000

        reset=6
        serout=7
        baud=9600

        
        
VAR
   long stack[200], s1, s2
   
OBJ
    serial : "FUllDuplexSerial"
PUB Start
   serial.Start(0, serout, %0000, baud)

   dira[reset]~~
   outa[reset] := 0

   waitcnt(clkfreq/100+cnt)

   outa[reset] := 1

   waitcnt(clkfreq/100+cnt)
   cognew(Motors, @stack)

PUB Motors

repeat

    'motor 1
    if s1 >= 0
        serial.tx(0)
        serial.tx(s1)
    if s1 < 0
        serial.tx(1)
        serial.tx(-s1)

    'motor 2
    if s2 >= 0
        serial.tx(2)
        serial.tx(s2)
    if s2 < 0
        serial.tx(3)
        serial.tx(-s2)

PUB Set(sp1, sp2)

  s1 := sp1
  s2 := sp2
